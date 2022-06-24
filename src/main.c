/*
 * main.c:
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "censor.h"

char read_char(){
	char c;
    outbyte ( c = inbyte() );
    return c;
}

int main()
{
	//volatile int Delay;
	int i = 0;
	char char_in;

	u32 char_in_buf[1500] = {0};
	u32 char_out_buf[1500] = {0};
	u32 number = 0;


	// Initialize GPIOs, FIFOs and accelerator. Check status
	init_platform();
	if ( init_censor() != XST_SUCCESS ){
		reset_censor();
		cleanup_platform();
		while(1);
	}

	print("Type words to censor (use space as delimiter):");

	do
	{
		char_in = read_char();
		if(char_in != 0xd)
		char_in_buf[i++] = (u32)((char_in<<1)+0x01);
	}
	while((char_in != '\r') && (char_in != '\n'));

	char_in_buf[i++] = 0x41;

	print("\r\nType text to censor:");

	do
	{
		char_in = read_char();
		if(char_in != 0xd)
		char_in_buf[i++] = (u32)(char_in<<1);
	}
	while((char_in != '\r') && (char_in != '\n'));

	char_in_buf[i++] = 0x40;

	censor(char_in_buf, (u32)i, char_out_buf, &number);

	print("\r\nCensored text: ");

	for(int x = 0; x<number; x++)
	{
		xil_printf("%c", (char)char_out_buf[x]);
	}

	print("\r\n");

	reset_censor();
    cleanup_platform();
    while(1);
}
