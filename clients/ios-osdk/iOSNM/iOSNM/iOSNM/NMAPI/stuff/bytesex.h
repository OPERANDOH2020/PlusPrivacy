/*
 * Copyright (c) 2004, Apple Computer, Inc. All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1.  Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer. 
 * 2.  Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution. 
 * 3.  Neither the name of Apple Computer, Inc. ("Apple") nor the names of
 *     its contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission. 
 * 
 * THIS SOFTWARE IS PROVIDED BY APPLE AND ITS CONTRIBUTORS "AS IS "AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL APPLE OR ITS CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
/* bytesex.h */
#ifndef _STUFF_BYTESEX_H_
#define _STUFF_BYTESEX_H_

#if defined(__MWERKS__) && !defined(__private_extern__)
#define __private_extern__ __declspec(private_extern)
#endif

#include <mach-o/fat.h>
#include <mach-o/loader.h>
#undef MACHINE_THREAD_STATE	/* need to undef these to avoid warnings */
#undef MACHINE_THREAD_STATE_COUNT
#undef THREAD_STATE_NONE
#undef VALID_THREAD_STATE_FLAVOR
#undef MACHINE_THREAD_STATE	/* need to undef these to avoid warnings */
#undef MACHINE_THREAD_STATE_COUNT
#undef THREAD_STATE_NONE
#undef VALID_THREAD_STATE_FLAVOR
#undef MACHINE_THREAD_STATE	/* need to undef these to avoid warnings */
#undef MACHINE_THREAD_STATE_COUNT
#undef THREAD_STATE_NONE
#undef VALID_THREAD_STATE_FLAVOR
#include <mach/arm/thread_status.h>
#include <mach-o/nlist.h>
#include <mach-o/reloc.h>
#include <mach-o/ranlib.h>
#include  "bool.h"

enum byte_sex_z {
    UNKNOWN_BYTE_SEX,
    BIG_ENDIAN_BYTE_SEX,
    LITTLE_ENDIAN_BYTE_SEX
};
typedef enum NXByteOrder byte_sex;

#define SWAP_SHORT(a) ( ((a & 0xff) << 8) | ((unsigned short)(a) >> 8) )

#define SWAP_INT(a)  ( ((a) << 24) | \
		      (((a) << 8) & 0x00ff0000) | \
		      (((a) >> 8) & 0x0000ff00) | \
	 ((unsigned int)(a) >> 24) )

#ifndef __LP64__
#define SWAP_LONG(a) ( ((a) << 24) | \
		      (((a) << 8) & 0x00ff0000) | \
		      (((a) >> 8) & 0x0000ff00) | \
	((unsigned long)(a) >> 24) )
#endif

__private_extern__ long long SWAP_LONG_LONG(
    long long ll);

__private_extern__ float SWAP_FLOAT(
    float f);

__private_extern__ double SWAP_DOUBLE(
    double d);

__private_extern__  byte_sex get_host_byte_sex(
    void);



__private_extern__ void swap_m68k_thread_state_regs(
    struct m68k_thread_state_regs *cpu,
     byte_sex target_byte_sex);

__private_extern__ void swap_m68k_thread_state_68882(
    struct m68k_thread_state_68882 *fpu,
     byte_sex target_byte_sex);

__private_extern__ void swap_m68k_thread_state_user_reg(
    struct m68k_thread_state_user_reg *user_reg,
     byte_sex target_byte_sex);


/* current i386 thread states */
#if i386_THREAD_STATE == 1
__private_extern__ void swap_i386_float_state(
    struct __darwin_i386_float_state *fpu,
     byte_sex target_byte_sex);

__private_extern__ void swap_i386_exception_state(
    i386_exception_state_t *exc,
     byte_sex target_byte_sex);
#endif /* i386_THREAD_STATE == 1 */

/* i386 thread states on older releases */
#if i386_THREAD_STATE == -1
__private_extern__ void swap_i386_thread_fpstate(
    i386_thread_fpstate_t *fpu,
     byte_sex target_byte_sex);

__private_extern__ void swap_i386_thread_exceptstate(
    i386_thread_exceptstate_t *exc,
     byte_sex target_byte_sex);

__private_extern__ void swap_i386_thread_cthreadstate(
    i386_thread_cthreadstate_t *user,
     byte_sex target_byte_sex);
#endif /* i386_THREAD_STATE == -1 */

#ifdef x86_THREAD_STATE64
__private_extern__ void swap_x86_thread_state64(
    x86_thread_state64_t *cpu,
     byte_sex target_byte_sex);

__private_extern__ void swap_x86_float_state64(
    x86_float_state64_t *fpu,
     byte_sex target_byte_sex);

__private_extern__ void swap_x86_state_hdr(
    struct x86_state_hdr *hdr,
     byte_sex target_byte_sex);

__private_extern__ void swap_x86_exception_state64(
    x86_exception_state64_t *exc,
     byte_sex target_byte_sex);

__private_extern__ void swap_x86_debug_state32(
    x86_debug_state32_t *debug,
     byte_sex target_byte_sex);

__private_extern__ void swap_x86_debug_state64(
    x86_debug_state64_t *debug,
     byte_sex target_byte_sex);
#endif /* x86_THREAD_STATE64 */

__private_extern__ void swap_hppa_integer_thread_state(
    struct hp_pa_integer_thread_state *regs,
     byte_sex target_byte_order);

__private_extern__ void swap_hppa_frame_thread_state(
  struct hp_pa_frame_thread_state *frame,
   byte_sex target_byte_order);

__private_extern__ void swap_hppa_fp_thread_state(
  struct hp_pa_fp_thread_state *fp,
   byte_sex target_byte_order);

__private_extern__ void swap_sparc_thread_state_regs(
  struct sparc_thread_state_regs *cpu,
   byte_sex target_byte_order);

__private_extern__ void swap_sparc_thread_state_fpu(
  struct sparc_thread_state_fpu *fpu,
   byte_sex target_byte_order);

__private_extern__ void swap_arm_thread_state_t(
    arm_thread_state_t *cpu,
     byte_sex target_byte_sex);



/*
 * swap_object_headers() swaps the object file headers from the host byte sex
 * into the non-host byte sex.  It returns TRUE if it can and did swap the
 * headers else returns FALSE and does not touch the headers and prints an error
 * using the error() routine.
 */
__private_extern__  char swap_object_headers(
    void *mach_header, /* either a mach_header or a mach_header_64 */
    struct load_command *load_commands);

/*
 * get_toc_byte_sex() guesses the byte sex of the table of contents of the
 * library mapped in at the address, addr, of size, size based on the first
 * object file's bytesex.  If it can't figure it out, because the library has
 * no object file members or is malformed it will return UNKNOWN_BYTE_SEX.
 */
__private_extern__ byte_sex get_toc_byte_sex(
    char *addr,
    uint32_t size);

#endif /* _STUFF_BYTESEX_H_ */
