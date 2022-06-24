/*
 * censor.c

 *
 *  Created on: 10.06.2022
 *      Author: tomac
 */

#include "xparameters.h"
#include "xllfifo.h"
#include "xstatus.h"
#include "censor.h"

XLlFifo Instance;

#define FIFO_DEVICE_ID XPAR_AXI_FIFO_MM_S_0_DEVICE_ID
#define ACCELERATOR_LATENCY 43
#define ACCELERATOR_FIFO_LEN 2048

int censor(u32* write_and_char_in, u32 char_in_len, u32* char_out, u32* char_out_len)
{
		u32 results = 0;
		u32 len_diff = 0;

		// Buffers longer than FIFO len are not supported
		if(ACCELERATOR_FIFO_LEN > 2048)
			return 1;

		//Send char_in to accelerator
		//Send ACCELERATOR_LATENCY more values to push out results form accelerator
		if( send_buffer((u32*)write_and_char_in, (char_in_len+ACCELERATOR_LATENCY)*sizeof(u32)) == XST_FAILURE )
			return 1;

		for(int i = 0; i<char_in_len; i++)
		{
			if((write_and_char_in[i] & 0x01) == 0x01)
			{
				len_diff++;
			}
		}

		//Get results
	    if( receive_buffer((u32*)char_out, (char_in_len-len_diff)*sizeof(u32), &results) == XST_FAILURE )
	    	return 1;
	    //Return number of characters
	    *char_out_len = results;

		return 0;
}

/**
 * Initialize FIFOs and its driver
 */
int init_censor(){
	XLlFifo_Config *Config;
	int Status;

	/* Initialize the Device Configuration Interface driver */
	Config = XLlFfio_LookupConfig(FIFO_DEVICE_ID);
	if (!Config) {
		return XST_FAILURE;
	}

	Status = XLlFifo_CfgInitialize(&Instance, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	/* Check for the Reset value */
	Status = XLlFifo_Status(&Instance);
	XLlFifo_IntClear(&Instance,0xffffffff);
	Status = XLlFifo_Status(&Instance);
	if(Status != 0x0) {
		return XST_FAILURE;
	}


	return XST_SUCCESS;

}

/**
 * Send reset signal to FIFOs and accelrator
 */
void reset_censor(){
	XLlFifo_RxReset(&Instance);
	XLlFifo_TxReset(&Instance);
}

/**
 * Send data to the input FIFO and accelerator
 */
int send_buffer(u32* buf, u32 len){

	//Write data to the input FIFO
	XLlFifo_Write(&Instance, buf, len);
	//Initialize data transfer
 	XLlFifo_TxSetLen(&Instance, len);

 	// Check for Transmission completion
 	while( !(XLlFifo_IsTxDone(&Instance)) ){

 	}

 	return XST_SUCCESS;

}


/**
 * Receive date form the output FIFO
 */
int receive_buffer(u32* buf, u32 len, u32* received){
u32 bytes;
int Status;

	//wait for data frame ready
	while(XLlFifo_RxOccupancy(&Instance)==0);
	//get number of data in frame
	bytes = XLlFifo_RxGetLen(&Instance);
	//Expected number of elements should be ready
	if( len < bytes ) return XST_FAILURE;

    //Perform read operation form FIFO
	XLlFifo_Read(&Instance, buf, len);
	//Return number of data read
	*received = len/sizeof(32);

	//Check operation status
	Status = XLlFifo_IsRxDone(&Instance);
	if(Status != TRUE){
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}

