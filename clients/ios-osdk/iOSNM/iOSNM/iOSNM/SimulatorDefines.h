//
//  SimulatorDefines.h
//  iOSNM
//
//  Created by Costin Andronache on 7/31/17.
//  Copyright © 2017 Personal. All rights reserved.
//

#ifndef SimulatorDefines_h
#define SimulatorDefines_h

typedef unsigned int		__uint32_t;

typedef struct
{
    __uint32_t	__r[13];	/* General purpose register r0-r12 */
    __uint32_t	__sp;		/* Stack pointer r13 */
    __uint32_t	__lr;		/* Link register r14 */
    __uint32_t	__pc;		/* Program counter r15 */
    __uint32_t	__cpsr;		/* Current program status register */
} arm_thread_state_t;

#define ARM_THREAD_STATE 1
#define ARM_THREAD_STATE_COUNT ((mach_msg_type_number_t) \
(sizeof (arm_thread_state_t)/sizeof(uint32_t)))

#endif /* SimulatorDefines_h */
