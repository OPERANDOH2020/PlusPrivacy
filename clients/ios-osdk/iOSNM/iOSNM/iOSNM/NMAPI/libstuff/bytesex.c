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
/* byte_sex.c */

#define __cr cr
#define __ctr ctr
#define __dar dar
#define __dsisr dsisr
#define __exception exception
#define __fpregs fpregs
#define __fpscr fpscr
#define __fpscr_pad fpscr_pad
#define __lr lr
#define __mq mq
#define __pad0 pad0
#define __pad1 pad1
#define __r0 r0
#define __r1 r1
#define __r10 r10
#define __r11 r11
#define __r12 r12
#define __r13 r13
#define __r14 r14
#define __r15 r15
#define __r16 r16
#define __r17 r17
#define __r18 r18
#define __r19 r19
#define __r2 r2
#define __r20 r20
#define __r21 r21
#define __r22 r22
#define __r23 r23
#define __r24 r24
#define __r25 r25
#define __r26 r26
#define __r27 r27
#define __r28 r28
#define __r29 r29
#define __r3 r3
#define __r30 r30
#define __r31 r31
#define __r4 r4
#define __r5 r5
#define __r6 r6
#define __r7 r7
#define __r8 r8
#define __r9 r9
#define __srr0 srr0
#define __srr1 srr1
#define __vrsave vrsave
#define __xer xer

#define __darwin_i386_exception_state i386_exception_state
#define __darwin_i386_float_state i386_float_state
#define __darwin_i386_thread_state i386_thread_state
#define __busy busy
#define __c0 c0
#define __c1 c1
#define __c2 c2
#define __c3 c3
#define __cs cs
#define __darwin_fp_control fp_control
#define __darwin_fp_status fp_status
#define __darwin_mmst_reg mmst_reg
#define __darwin_xmm_reg xmm_reg
#define __denorm denorm
#define __ds ds
#define __eax eax
#define __ebp ebp
#define __ebx ebx
#define __ecx ecx
#define __edi edi
#define __edx edx
#define __eflags eflags
#define __eip eip
#define __err err
#define __errsumm errsumm
#define __es es
#define __esi esi
#define __esp esp
#define __faultvaddr faultvaddr
#define __fpu_cs fpu_cs
#define __fpu_dp fpu_dp
#define __fpu_ds fpu_ds
#define __fpu_fcw fpu_fcw
#define __fpu_fop fpu_fop
#define __fpu_fsw fpu_fsw
#define __fpu_ftw fpu_ftw
#define __fpu_ip fpu_ip
#define __fpu_mxcsr fpu_mxcsr
#define __fpu_mxcsrmask fpu_mxcsrmask
#define __fpu_reserved fpu_reserved
#define __fpu_reserved1 fpu_reserved1
#define __fpu_rsrv1 fpu_rsrv1
#define __fpu_rsrv2 fpu_rsrv2
#define __fpu_rsrv3 fpu_rsrv3
#define __fpu_rsrv4 fpu_rsrv4
#define __fpu_stmm0 fpu_stmm0
#define __fpu_stmm1 fpu_stmm1
#define __fpu_stmm2 fpu_stmm2
#define __fpu_stmm3 fpu_stmm3
#define __fpu_stmm4 fpu_stmm4
#define __fpu_stmm5 fpu_stmm5
#define __fpu_stmm6 fpu_stmm6
#define __fpu_stmm7 fpu_stmm7
#define __fpu_xmm0 fpu_xmm0
#define __fpu_xmm1 fpu_xmm1
#define __fpu_xmm2 fpu_xmm2
#define __fpu_xmm3 fpu_xmm3
#define __fpu_xmm4 fpu_xmm4
#define __fpu_xmm5 fpu_xmm5
#define __fpu_xmm6 fpu_xmm6
#define __fpu_xmm7 fpu_xmm7
#define __fs fs
#define __gs gs
#define __invalid invalid
#define __mmst_reg mmst_reg
#define __mmst_rsrv mmst_rsrv
#define __ovrfl ovrfl
#define __pc pc
#define __precis precis
#define __rc rc
#define __ss ss
#define __stkflt stkflt
#define __tos tos
#define __trapno trapno
#define __undfl undfl
#define __xmm_reg xmm_reg
#define __zdiv zdiv

#define __rax rax
#define __rbx rbx
#define __rcx rcx
#define __rdx rdx
#define __rdi rdi
#define __rsi rsi
#define __rbp rbp
#define __rsp rsp
#define __r8 r8
#define __r9 r9
#define __r10 r10
#define __r11 r11
#define __r12 r12
#define __r13 r13
#define __r14 r14
#define __r15 r15
#define __rip rip
#define __rflags rflags

#define __dr0 dr0
#define __dr1 dr1
#define __dr2 dr2
#define __dr3 dr3
#define __dr4 dr4
#define __dr5 dr5
#define __dr6 dr6
#define __dr7 dr7

#include <string.h>
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
#include  "bytesex.h"


__private_extern__
long long
SWAP_LONG_LONG(
long long ll)
{
	union {
	    char c[8];
	    long long ll;
	} in, out;
	in.ll = ll;
	out.c[0] = in.c[7];
	out.c[1] = in.c[6];
	out.c[2] = in.c[5];
	out.c[3] = in.c[4];
	out.c[4] = in.c[3];
	out.c[5] = in.c[2];
	out.c[6] = in.c[1];
	out.c[7] = in.c[0];
	return(out.ll);
}

__private_extern__
double
SWAP_DOUBLE(
double d)
{
	union {
	    char c[8];
	    double d;
	} in, out;
	in.d = d;
	out.c[0] = in.c[7];
	out.c[1] = in.c[6];
	out.c[2] = in.c[5];
	out.c[3] = in.c[4];
	out.c[4] = in.c[3];
	out.c[5] = in.c[2];
	out.c[6] = in.c[1];
	out.c[7] = in.c[0];
	return(out.d);
}

__private_extern__
float
SWAP_FLOAT(
float f)
{
	union {
	    char c[7];
	    float f;
	} in, out;
	in.f = f;
	out.c[0] = in.c[3];
	out.c[1] = in.c[2];
	out.c[2] = in.c[1];
	out.c[3] = in.c[0];
	return(out.f);
}

/*
 * get_host_byte_sex() returns the enum constant for the byte sex of the host
 * it is running on.
 */
__private_extern__
 byte_sex
get_host_byte_sex(
void)
{
    uint32_t s;

	s = (BIG_ENDIAN_BYTE_SEX << 24) | LITTLE_ENDIAN_BYTE_SEX;
	return(( byte_sex)*((char *)&s));
}

__private_extern__
void
swap_fat_header(
struct fat_header *fat_header,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	fat_header->magic     = SWAP_INT(fat_header->magic);
	fat_header->nfat_arch = SWAP_INT(fat_header->nfat_arch);
}

__private_extern__
void
swap_fat_arch(
struct fat_arch *fat_archs,
uint32_t nfat_arch,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nfat_arch; i++){
	    fat_archs[i].cputype    = SWAP_INT(fat_archs[i].cputype);
	    fat_archs[i].cpusubtype = SWAP_INT(fat_archs[i].cpusubtype);
	    fat_archs[i].offset     = SWAP_INT(fat_archs[i].offset);
	    fat_archs[i].size       = SWAP_INT(fat_archs[i].size);
	    fat_archs[i].align      = SWAP_INT(fat_archs[i].align);
	}
}

__private_extern__
void
swap_mach_header(
struct mach_header *mh,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	mh->magic = SWAP_INT(mh->magic);
	mh->cputype = SWAP_INT(mh->cputype);
	mh->cpusubtype = SWAP_INT(mh->cpusubtype);
	mh->filetype = SWAP_INT(mh->filetype);
	mh->ncmds = SWAP_INT(mh->ncmds);
	mh->sizeofcmds = SWAP_INT(mh->sizeofcmds);
	mh->flags = SWAP_INT(mh->flags);
}

__private_extern__
void
swap_mach_header_64(
struct mach_header_64 *mh,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	mh->magic = SWAP_INT(mh->magic);
	mh->cputype = SWAP_INT(mh->cputype);
	mh->cpusubtype = SWAP_INT(mh->cpusubtype);
	mh->filetype = SWAP_INT(mh->filetype);
	mh->ncmds = SWAP_INT(mh->ncmds);
	mh->sizeofcmds = SWAP_INT(mh->sizeofcmds);
	mh->flags = SWAP_INT(mh->flags);
	mh->reserved = SWAP_INT(mh->reserved);
}

__private_extern__
void
swap_load_command(
struct load_command *lc,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	lc->cmd = SWAP_INT(lc->cmd);
	lc->cmdsize = SWAP_INT(lc->cmdsize);
}

__private_extern__
void
swap_segment_command(
struct segment_command *sg,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	/* segname[16] */
	sg->cmd = SWAP_INT(sg->cmd);
	sg->cmdsize = SWAP_INT(sg->cmdsize);
	sg->vmaddr = SWAP_INT(sg->vmaddr);
	sg->vmsize = SWAP_INT(sg->vmsize);
	sg->fileoff = SWAP_INT(sg->fileoff);
	sg->filesize = SWAP_INT(sg->filesize);
	sg->maxprot = SWAP_INT(sg->maxprot);
	sg->initprot = SWAP_INT(sg->initprot);
	sg->nsects = SWAP_INT(sg->nsects);
	sg->flags = SWAP_INT(sg->flags);
}

__private_extern__
void
swap_segment_command_64(
struct segment_command_64 *sg,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	/* segname[16] */
	sg->cmd = SWAP_INT(sg->cmd);
	sg->cmdsize = SWAP_INT(sg->cmdsize);
	sg->vmaddr = SWAP_LONG_LONG(sg->vmaddr);
	sg->vmsize = SWAP_LONG_LONG(sg->vmsize);
	sg->fileoff = SWAP_LONG_LONG(sg->fileoff);
	sg->filesize = SWAP_LONG_LONG(sg->filesize);
	sg->maxprot = SWAP_INT(sg->maxprot);
	sg->initprot = SWAP_INT(sg->initprot);
	sg->nsects = SWAP_INT(sg->nsects);
	sg->flags = SWAP_INT(sg->flags);
}

__private_extern__
void
swap_section(
struct section *s,
uint32_t nsects,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nsects; i++){
	    /* sectname[16] */
	    /* segname[16] */
	    s[i].addr = SWAP_INT(s[i].addr);
	    s[i].size = SWAP_INT(s[i].size);
	    s[i].offset = SWAP_INT(s[i].offset);
	    s[i].align = SWAP_INT(s[i].align);
	    s[i].reloff = SWAP_INT(s[i].reloff);
	    s[i].nreloc = SWAP_INT(s[i].nreloc);
	    s[i].flags = SWAP_INT(s[i].flags);
	    s[i].reserved1 = SWAP_INT(s[i].reserved1);
	    s[i].reserved2 = SWAP_INT(s[i].reserved2);
	}
}

__private_extern__
void
swap_section_64(
struct section_64 *s,
uint32_t nsects,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nsects; i++){
	    /* sectname[16] */
	    /* segname[16] */
	    s[i].addr = SWAP_LONG_LONG(s[i].addr);
	    s[i].size = SWAP_LONG_LONG(s[i].size);
	    s[i].offset = SWAP_INT(s[i].offset);
	    s[i].align = SWAP_INT(s[i].align);
	    s[i].reloff = SWAP_INT(s[i].reloff);
	    s[i].nreloc = SWAP_INT(s[i].nreloc);
	    s[i].flags = SWAP_INT(s[i].flags);
	    s[i].reserved1 = SWAP_INT(s[i].reserved1);
	    s[i].reserved2 = SWAP_INT(s[i].reserved2);
	}
}

__private_extern__
void
swap_symtab_command(
struct symtab_command *st,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	st->cmd = SWAP_INT(st->cmd);
	st->cmdsize = SWAP_INT(st->cmdsize);
	st->symoff = SWAP_INT(st->symoff);
	st->nsyms = SWAP_INT(st->nsyms);
	st->stroff = SWAP_INT(st->stroff);
	st->strsize = SWAP_INT(st->strsize);
}

__private_extern__
void
swap_dysymtab_command(
struct dysymtab_command *dyst,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	dyst->cmd = SWAP_INT(dyst->cmd);
	dyst->cmdsize = SWAP_INT(dyst->cmdsize);
	dyst->ilocalsym = SWAP_INT(dyst->ilocalsym);
	dyst->nlocalsym = SWAP_INT(dyst->nlocalsym);
	dyst->iextdefsym = SWAP_INT(dyst->iextdefsym);
	dyst->nextdefsym = SWAP_INT(dyst->nextdefsym);
	dyst->iundefsym = SWAP_INT(dyst->iundefsym);
	dyst->nundefsym = SWAP_INT(dyst->nundefsym);
	dyst->tocoff = SWAP_INT(dyst->tocoff);
	dyst->ntoc = SWAP_INT(dyst->ntoc);
	dyst->modtaboff = SWAP_INT(dyst->modtaboff);
	dyst->nmodtab = SWAP_INT(dyst->nmodtab);
	dyst->extrefsymoff = SWAP_INT(dyst->extrefsymoff);
	dyst->nextrefsyms = SWAP_INT(dyst->nextrefsyms);
	dyst->indirectsymoff = SWAP_INT(dyst->indirectsymoff);
	dyst->nindirectsyms = SWAP_INT(dyst->nindirectsyms);
	dyst->extreloff = SWAP_INT(dyst->extreloff);
	dyst->nextrel = SWAP_INT(dyst->nextrel);
	dyst->locreloff = SWAP_INT(dyst->locreloff);
	dyst->nlocrel = SWAP_INT(dyst->nlocrel);
}

__private_extern__
void
swap_symseg_command(
struct symseg_command *ss,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	ss->cmd = SWAP_INT(ss->cmd);
	ss->cmdsize = SWAP_INT(ss->cmdsize);
	ss->offset = SWAP_INT(ss->offset);
	ss->size = SWAP_INT(ss->size);
}

__private_extern__
void
swap_fvmlib_command(
struct fvmlib_command *fl,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	fl->cmd = SWAP_INT(fl->cmd);
	fl->cmdsize = SWAP_INT(fl->cmdsize);
	fl->fvmlib.name.offset = SWAP_INT(fl->fvmlib.name.offset);
	fl->fvmlib.minor_version = SWAP_INT(fl->fvmlib.minor_version);
	fl->fvmlib.header_addr = SWAP_INT(fl->fvmlib.header_addr);
}

__private_extern__
void
swap_dylib_command(
struct dylib_command *dl,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	dl->cmd = SWAP_INT(dl->cmd);
	dl->cmdsize = SWAP_INT(dl->cmdsize);
	dl->dylib.name.offset = SWAP_INT(dl->dylib.name.offset);
	dl->dylib.timestamp = SWAP_INT(dl->dylib.timestamp);
	dl->dylib.current_version = SWAP_INT(dl->dylib.current_version);
	dl->dylib.compatibility_version =
				SWAP_INT(dl->dylib.compatibility_version);
}

__private_extern__
void
swap_sub_framework_command(
struct sub_framework_command *sub,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	sub->cmd = SWAP_INT(sub->cmd);
	sub->cmdsize = SWAP_INT(sub->cmdsize);
	sub->umbrella.offset = SWAP_INT(sub->umbrella.offset);
}

__private_extern__
void
swap_sub_umbrella_command(
struct sub_umbrella_command *usub,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	usub->cmd = SWAP_INT(usub->cmd);
	usub->cmdsize = SWAP_INT(usub->cmdsize);
	usub->sub_umbrella.offset = SWAP_INT(usub->sub_umbrella.offset);
}

__private_extern__
void
swap_sub_library_command(
struct sub_library_command *lsub,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	lsub->cmd = SWAP_INT(lsub->cmd);
	lsub->cmdsize = SWAP_INT(lsub->cmdsize);
	lsub->sub_library.offset = SWAP_INT(lsub->sub_library.offset);
}

__private_extern__
void
swap_sub_client_command(
struct sub_client_command *csub,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	csub->cmd = SWAP_INT(csub->cmd);
	csub->cmdsize = SWAP_INT(csub->cmdsize);
	csub->client.offset = SWAP_INT(csub->client.offset);
}

__private_extern__
void
swap_prebound_dylib_command(
struct prebound_dylib_command *pbdylib,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	pbdylib->cmd = SWAP_INT(pbdylib->cmd);
	pbdylib->cmdsize = SWAP_INT(pbdylib->cmdsize);
	pbdylib->name.offset = SWAP_INT(pbdylib->name.offset);
	pbdylib->nmodules = SWAP_INT(pbdylib->nmodules);
	pbdylib->linked_modules.offset =
		SWAP_INT(pbdylib->linked_modules.offset);
}

__private_extern__
void
swap_dylinker_command(
struct dylinker_command *dyld,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	dyld->cmd = SWAP_INT(dyld->cmd);
	dyld->cmdsize = SWAP_INT(dyld->cmdsize);
	dyld->name.offset = SWAP_INT(dyld->name.offset);
}

__private_extern__
void
swap_fvmfile_command(
struct fvmfile_command *ff,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	ff->cmd = SWAP_INT(ff->cmd);
	ff->cmdsize = SWAP_INT(ff->cmdsize);
	ff->name.offset = SWAP_INT(ff->name.offset);
	ff->header_addr = SWAP_INT(ff->header_addr);
}


__private_extern__
void
swap_thread_command(
struct thread_command *ut,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	ut->cmd = SWAP_INT(ut->cmd);
	ut->cmdsize = SWAP_INT(ut->cmdsize);
}




__private_extern__
void
swap_ident_command(
struct ident_command *id_cmd,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	id_cmd->cmd = SWAP_INT(id_cmd->cmd);
	id_cmd->cmdsize = SWAP_INT(id_cmd->cmdsize);
}

__private_extern__
void
swap_routines_command(
struct routines_command *r_cmd,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	r_cmd->cmd = SWAP_INT(r_cmd->cmd);
	r_cmd->cmdsize = SWAP_INT(r_cmd->cmdsize);
	r_cmd->init_address = SWAP_INT(r_cmd->init_address);
	r_cmd->init_module = SWAP_INT(r_cmd->init_module);
	r_cmd->reserved1 = SWAP_INT(r_cmd->reserved1);
	r_cmd->reserved2 = SWAP_INT(r_cmd->reserved2);
	r_cmd->reserved3 = SWAP_INT(r_cmd->reserved3);
	r_cmd->reserved4 = SWAP_INT(r_cmd->reserved4);
	r_cmd->reserved5 = SWAP_INT(r_cmd->reserved5);
	r_cmd->reserved6 = SWAP_INT(r_cmd->reserved6);
}

__private_extern__
void
swap_routines_command_64(
struct routines_command_64 *r_cmd,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	r_cmd->cmd = SWAP_INT(r_cmd->cmd);
	r_cmd->cmdsize = SWAP_INT(r_cmd->cmdsize);
	r_cmd->init_address = SWAP_LONG_LONG(r_cmd->init_address);
	r_cmd->init_module = SWAP_LONG_LONG(r_cmd->init_module);
	r_cmd->reserved1 = SWAP_LONG_LONG(r_cmd->reserved1);
	r_cmd->reserved2 = SWAP_LONG_LONG(r_cmd->reserved2);
	r_cmd->reserved3 = SWAP_LONG_LONG(r_cmd->reserved3);
	r_cmd->reserved4 = SWAP_LONG_LONG(r_cmd->reserved4);
	r_cmd->reserved5 = SWAP_LONG_LONG(r_cmd->reserved5);
	r_cmd->reserved6 = SWAP_LONG_LONG(r_cmd->reserved6);
}

__private_extern__
void
swap_twolevel_hints_command(
struct twolevel_hints_command *hints_cmd,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	hints_cmd->cmd = SWAP_INT(hints_cmd->cmd);
	hints_cmd->cmdsize = SWAP_INT(hints_cmd->cmdsize);
	hints_cmd->offset = SWAP_INT(hints_cmd->offset);
	hints_cmd->nhints = SWAP_INT(hints_cmd->nhints);
}

__private_extern__
void
swap_twolevel_hint(
struct twolevel_hint *hints,
uint32_t nhints,
 byte_sex target_byte_sex)
{
    struct swapped_twolevel_hint {
	union {
	    struct {
		uint32_t
		    itoc:24,
		    isub_image:8;
	    } fields;
	    uint32_t word;
	} u;
    } shint;

    uint32_t i;
     byte_sex host_byte_sex;

	host_byte_sex = get_host_byte_sex();

	for(i = 0; i < nhints; i++){
	    if(target_byte_sex == host_byte_sex){
		memcpy(&shint, hints + i, sizeof(struct swapped_twolevel_hint));
		shint.u.word = SWAP_INT(shint.u.word);
		hints[i].itoc = shint.u.fields.itoc;
		hints[i].isub_image = shint.u.fields.isub_image;
	    }
	    else{
		shint.u.fields.isub_image = hints[i].isub_image;
		shint.u.fields.itoc = hints[i].itoc;
		shint.u.word = SWAP_INT(shint.u.word);
		memcpy(hints + i, &shint, sizeof(struct swapped_twolevel_hint));
	    }
	}
}

__private_extern__
void
swap_prebind_cksum_command(
struct prebind_cksum_command *cksum_cmd,
 byte_sex target_byte_sex)
{
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif
	cksum_cmd->cmd = SWAP_INT(cksum_cmd->cmd);
	cksum_cmd->cmdsize = SWAP_INT(cksum_cmd->cmdsize);
	cksum_cmd->cksum = SWAP_INT(cksum_cmd->cksum);
}

__private_extern__
void
swap_uuid_command(
struct uuid_command *uuid_cmd,
 byte_sex target_byte_sex)
{
	uuid_cmd->cmd = SWAP_INT(uuid_cmd->cmd);
	uuid_cmd->cmdsize = SWAP_INT(uuid_cmd->cmdsize);
}

__private_extern__
void
swap_linkedit_data_command(
struct linkedit_data_command *ld,
 byte_sex target_byte_sex)
{
	ld->cmd = SWAP_INT(ld->cmd);
	ld->cmdsize = SWAP_INT(ld->cmdsize);
	ld->dataoff = SWAP_INT(ld->dataoff);
	ld->datasize = SWAP_INT(ld->datasize);
}

__private_extern__
void
swap_version_min_command(
struct version_min_command *ver_cmd,
 byte_sex target_byte_sex)
{
	ver_cmd->cmd = SWAP_INT(ver_cmd->cmd);
	ver_cmd->cmdsize = SWAP_INT(ver_cmd->cmdsize);
	ver_cmd->version = SWAP_INT(ver_cmd->version);
}

__private_extern__
void swap_rpath_command(
struct rpath_command *rpath_cmd,
 byte_sex target_byte_sex)
{
	rpath_cmd->cmd = SWAP_INT(rpath_cmd->cmd);
	rpath_cmd->cmdsize = SWAP_INT(rpath_cmd->cmdsize);
	rpath_cmd->path.offset = SWAP_INT(rpath_cmd->path.offset);
}

__private_extern__
 void
swap_encryption_command(
struct encryption_info_command *ec,
 byte_sex target_byte_sex)
{
	ec->cmd = SWAP_INT(ec->cmd);
	ec->cmdsize = SWAP_INT(ec->cmdsize);
	ec->cryptoff = SWAP_INT(ec->cryptoff);
	ec->cryptsize = SWAP_INT(ec->cryptsize);
	ec->cryptid = SWAP_INT(ec->cryptid);
}

__private_extern__
 void
swap_dyld_info_command(
struct dyld_info_command *ed,
 byte_sex target_byte_sex)
{
	ed->cmd = SWAP_INT(ed->cmd);
	ed->cmdsize = SWAP_INT(ed->cmdsize);
	ed->rebase_off = SWAP_INT(ed->rebase_off);
	ed->rebase_size = SWAP_INT(ed->rebase_size);
	ed->bind_off = SWAP_INT(ed->bind_off);
	ed->bind_size = SWAP_INT(ed->bind_size);
	ed->weak_bind_off = SWAP_INT(ed->weak_bind_off);
	ed->weak_bind_size = SWAP_INT(ed->weak_bind_size);
	ed->lazy_bind_off = SWAP_INT(ed->lazy_bind_off);
	ed->lazy_bind_size = SWAP_INT(ed->lazy_bind_size);
	ed->export_off = SWAP_INT(ed->export_off);
	ed->export_size = SWAP_INT(ed->export_size);
}

__private_extern__
void
swap_entry_point_command(
struct entry_point_command *ep,
 byte_sex target_byte_sex)
{
	ep->cmd = SWAP_INT(ep->cmd);
	ep->cmdsize = SWAP_INT(ep->cmdsize);
	ep->entryoff = SWAP_LONG_LONG(ep->entryoff);
	ep->stacksize = SWAP_LONG_LONG(ep->stacksize);
}

__private_extern__
void
swap_source_version_command(
struct source_version_command *sv,
 byte_sex target_byte_sex)
{
	sv->cmd = SWAP_INT(sv->cmd);
	sv->cmdsize = SWAP_INT(sv->cmdsize);
	sv->version = SWAP_LONG_LONG(sv->version);
}

__private_extern__
void
swap_nlist(
struct nlist *symbols,
uint32_t nsymbols,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nsymbols; i++){
	    symbols[i].n_un.n_strx = SWAP_INT(symbols[i].n_un.n_strx);
	    /* n_type */
	    /* n_sect */
	    symbols[i].n_desc = SWAP_SHORT(symbols[i].n_desc);
	    symbols[i].n_value = SWAP_INT(symbols[i].n_value);
	}
}

__private_extern__
void
swap_nlist_64(
struct nlist_64 *symbols,
uint32_t nsymbols,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nsymbols; i++){
	    symbols[i].n_un.n_strx = SWAP_INT(symbols[i].n_un.n_strx);
	    /* n_type */
	    /* n_sect */
	    symbols[i].n_desc = SWAP_SHORT(symbols[i].n_desc);
	    symbols[i].n_value = SWAP_LONG_LONG(symbols[i].n_value);
	}
}

__private_extern__
void
swap_ranlib(
struct ranlib *ranlibs,
uint32_t nranlibs,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nranlibs; i++){
	    ranlibs[i].ran_un.ran_strx = SWAP_INT(ranlibs[i].ran_un.ran_strx);
	    ranlibs[i].ran_off = SWAP_INT(ranlibs[i].ran_off);
	}
}

__private_extern__
void
swap_relocation_info(
struct relocation_info *relocs,
uint32_t nrelocs,
 byte_sex target_byte_sex)
{
    uint32_t i;
     byte_sex host_byte_sex;
     char to_host_byte_sex, scattered;

    struct swapped_relocation_info {
	int32_t r_address;
	union {
	    struct {
		unsigned int
		    r_type:4,
		    r_extern:1,
		    r_length:2,
		    r_pcrel:1,
		    r_symbolnum:24;
	    } fields;
	    uint32_t word;
	} u;
    } sr;

    struct swapped_scattered_relocation_info {
	uint32_t word;
	int32_t	r_value;
    } *ssr;

	host_byte_sex = get_host_byte_sex();
	to_host_byte_sex = ( char)(target_byte_sex == host_byte_sex);

	for(i = 0; i < nrelocs; i++){
	    if(to_host_byte_sex)
		scattered = ( char)(
			(SWAP_INT(relocs[i].r_address) & R_SCATTERED) != 0);
	    else
		scattered = ( char)
			(((relocs[i].r_address) & R_SCATTERED) != 0);
	    if(scattered == 0){
		if(to_host_byte_sex){
		    memcpy(&sr, relocs + i, sizeof(struct relocation_info));
		    sr.r_address = SWAP_INT(sr.r_address);
		    sr.u.word = SWAP_INT(sr.u.word);
		    relocs[i].r_address = sr.r_address;
		    relocs[i].r_symbolnum = sr.u.fields.r_symbolnum;
		    relocs[i].r_pcrel = sr.u.fields.r_pcrel;
		    relocs[i].r_length = sr.u.fields.r_length;
		    relocs[i].r_extern = sr.u.fields.r_extern;
		    relocs[i].r_type = sr.u.fields.r_type;
		}
		else{
		    sr.r_address = relocs[i].r_address;
		    sr.u.fields.r_symbolnum = relocs[i].r_symbolnum;
		    sr.u.fields.r_length = relocs[i].r_length;
		    sr.u.fields.r_pcrel = relocs[i].r_pcrel;
		    sr.u.fields.r_extern = relocs[i].r_extern;
		    sr.u.fields.r_type = relocs[i].r_type;
		    sr.r_address = SWAP_INT(sr.r_address);
		    sr.u.word = SWAP_INT(sr.u.word);
		    memcpy(relocs + i, &sr, sizeof(struct relocation_info));
		}
	    }
	    else{
		ssr = (struct swapped_scattered_relocation_info *)(relocs + i);
		ssr->word = SWAP_INT(ssr->word);
		ssr->r_value = SWAP_INT(ssr->r_value);
	    }
	}
}

__private_extern__
void
swap_indirect_symbols(
uint32_t *indirect_symbols,
uint32_t nindirect_symbols,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nindirect_symbols; i++)
	    indirect_symbols[i] = SWAP_INT(indirect_symbols[i]);
}

__private_extern__
void
swap_dylib_reference(
struct dylib_reference *refs,
uint32_t nrefs,
 byte_sex target_byte_sex)
{
    struct swapped_dylib_reference {
	union {
	    struct {
		uint32_t
		    flags:8,
		    isym:24;
	    } fields;
	    uint32_t word;
	} u;
    } sref;

    uint32_t i;
     byte_sex host_byte_sex;

	host_byte_sex = get_host_byte_sex();

	for(i = 0; i < nrefs; i++){
	    if(target_byte_sex == host_byte_sex){
		memcpy(&sref, refs + i, sizeof(struct swapped_dylib_reference));
		sref.u.word = SWAP_INT(sref.u.word);
		refs[i].flags = sref.u.fields.flags;
		refs[i].isym = sref.u.fields.isym;
	    }
	    else{
		sref.u.fields.isym = refs[i].isym;
		sref.u.fields.flags = refs[i].flags;
		sref.u.word = SWAP_INT(sref.u.word);
		memcpy(refs + i, &sref, sizeof(struct swapped_dylib_reference));
	    }
	}

}

__private_extern__
void
swap_dylib_module(
struct dylib_module *mods,
uint32_t nmods,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nmods; i++){
	    mods[i].module_name = SWAP_INT(mods[i].module_name);
	    mods[i].iextdefsym  = SWAP_INT(mods[i].iextdefsym);
	    mods[i].nextdefsym  = SWAP_INT(mods[i].nextdefsym);
	    mods[i].irefsym     = SWAP_INT(mods[i].irefsym);
	    mods[i].nrefsym     = SWAP_INT(mods[i].nrefsym);
	    mods[i].ilocalsym   = SWAP_INT(mods[i].ilocalsym);
	    mods[i].nlocalsym   = SWAP_INT(mods[i].nlocalsym);
	    mods[i].iextrel     = SWAP_INT(mods[i].iextrel);
	    mods[i].nextrel     = SWAP_INT(mods[i].nextrel);
	    mods[i].iinit_iterm = SWAP_INT(mods[i].iinit_iterm);
	    mods[i].ninit_nterm = SWAP_INT(mods[i].ninit_nterm);
	    mods[i].objc_module_info_addr =
				  SWAP_INT(mods[i].objc_module_info_addr);
	    mods[i].objc_module_info_size =
				  SWAP_INT(mods[i].objc_module_info_size);
	}
}

__private_extern__
void
swap_dylib_module_64(
struct dylib_module_64 *mods,
uint32_t nmods,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < nmods; i++){
	    mods[i].module_name = SWAP_INT(mods[i].module_name);
	    mods[i].iextdefsym  = SWAP_INT(mods[i].iextdefsym);
	    mods[i].nextdefsym  = SWAP_INT(mods[i].nextdefsym);
	    mods[i].irefsym     = SWAP_INT(mods[i].irefsym);
	    mods[i].nrefsym     = SWAP_INT(mods[i].nrefsym);
	    mods[i].ilocalsym   = SWAP_INT(mods[i].ilocalsym);
	    mods[i].nlocalsym   = SWAP_INT(mods[i].nlocalsym);
	    mods[i].iextrel     = SWAP_INT(mods[i].iextrel);
	    mods[i].nextrel     = SWAP_INT(mods[i].nextrel);
	    mods[i].iinit_iterm = SWAP_INT(mods[i].iinit_iterm);
	    mods[i].ninit_nterm = SWAP_INT(mods[i].ninit_nterm);
	    mods[i].objc_module_info_addr =
				  SWAP_LONG_LONG(mods[i].objc_module_info_addr);
	    mods[i].objc_module_info_size =
				  SWAP_LONG_LONG(mods[i].objc_module_info_size);
	}
}

__private_extern__
void
swap_dylib_table_of_contents(
struct dylib_table_of_contents *tocs,
uint32_t ntocs,
 byte_sex target_byte_sex)
{
    uint32_t i;
#ifdef __MWERKS__
     byte_sex dummy;
        dummy = target_byte_sex;
#endif

	for(i = 0; i < ntocs; i++){
	    tocs[i].symbol_index = SWAP_INT(tocs[i].symbol_index);
	    tocs[i].module_index = SWAP_INT(tocs[i].module_index);
	}
}
