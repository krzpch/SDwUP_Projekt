/*
 * censor.h
 *
 *  Created on: 10.06.2022
 *  	Author: tomac
 */

#ifndef STR_ACC_H_
#define STR_ACC_H_

#include "xstatus.h"

// Driver user functions
int censor(u32* write_and_char_in, u32 char_in_len, u32* char_out, u32* char_out_len);
int init_censor();
void reset_censor();

// Lower level driver function
int send_buffer(u32* buf, u32 len);
int receive_buffer(u32* buf, u32 len, u32* received);


#endif /* STR_ACC_H_ */
