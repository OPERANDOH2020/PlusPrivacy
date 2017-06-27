/*
 * Copyright (c) 1999 Apple Computer, Inc. All rights reserved.
 *
 * @APPLE_LICENSE_HEADER_START@
 * 
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this
 * file.
 * 
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 * 
 * @APPLE_LICENSE_HEADER_END@
 */
#define __darwin_i386_exception_state i386_exception_state
#define __darwin_i386_float_state i386_float_state
#define __darwin_i386_thread_state i386_thread_state

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
#include  "bool.h"
#include  "bytesex.h"
#include  "errors.h"
#include <mach-o/swap.h>
#include <mach-o/dyld.h>
#include <mach/arm/thread_status.h>
#include <mach/arm/thread_state.h>

/*
 * swap_object_headers() swaps the object file headers from the host byte sex
 * into the non-host byte sex.  It returns TRUE if it can and did swap the
 * headers else returns FALSE and does not touch the headers and prints an error
 * using the error() routine.
 */
__private_extern__
 char
swap_object_headers(
void *mach_header,
struct load_command *load_commands)
{
    unsigned long i;
    uint32_t magic, ncmds, sizeofcmds, cmd_multiple;
    cpu_type_t cputype;
    cpu_subtype_t cpusubtype;
    struct mach_header *mh;
    struct mach_header_64 *mh64;
     byte_sex target_byte_sex;
    struct load_command *lc, l;
    struct segment_command *sg;
    struct segment_command_64 *sg64;
    struct section *s;
    struct section_64 *s64;
    struct symtab_command *st;
    struct dysymtab_command *dyst;
    struct symseg_command *ss;
    struct fvmlib_command *fl;
    struct thread_command *ut;
    struct ident_command *id;
    struct entry_point_command *ep;
    struct source_version_command *sv;
    struct dylib_command *dl;
    struct sub_framework_command *sub;
    struct sub_umbrella_command *usub;
    struct sub_library_command *lsub;
    struct sub_client_command *csub;
    struct prebound_dylib_command *pbdylib;
    struct dylinker_command *dyld;
    struct routines_command *rc;
    struct routines_command_64 *rc64;
    struct twolevel_hints_command *hints;
    struct prebind_cksum_command *cs;
    struct uuid_command *uuid;
    struct linkedit_data_command *ld;
    struct rpath_command *rpath;
    struct encryption_info_command *ec;
    struct dyld_info_command *dc;
    struct version_min_command *vc;
    uint32_t flavor, count;
    unsigned long nflavor;
    char *p, *state, *cmd_name;

	magic = *((uint32_t *)mach_header);
	if(magic == MH_MAGIC){
	    mh = (struct mach_header *)mach_header;
	    ncmds = mh->ncmds;
	    sizeofcmds = mh->sizeofcmds;
	    cputype = mh->cputype;
	    cpusubtype = mh->cpusubtype;
	    cmd_multiple = 4;
	    mh64 = NULL;
	}
	else{
	    mh64 = (struct mach_header_64 *)mach_header;
	    ncmds = mh64->ncmds;
	    sizeofcmds = mh64->sizeofcmds;
	    cputype = mh64->cputype;
	    cpusubtype = mh64->cpusubtype;
	    cmd_multiple = 8;
	    mh = NULL;
	}
	/*
	 * Make a pass through the load commands checking them to the level
	 * that they can be parsed and then swapped.
	 */
	for(i = 0, lc = load_commands; i < ncmds; i++){
	    l = *lc;
	    /* check load command size for a correct multiple size */
	    if(lc->cmdsize % cmd_multiple != 0){
		error("in swap_object_headers(): malformed load command %lu "
		      "(cmdsize not a multiple of %u)", i, cmd_multiple);
		return(FALSE);
	    }
	    /* check that load command does not extends past end of commands */
	    if((char *)lc + lc->cmdsize >
	       (char *)load_commands + sizeofcmds){
		error("in swap_object_headers(): truncated or malformed load "
		      "command %lu (extends past the end of the all load "
		      "commands)", i);
		return(FALSE);
	    }
	    /* check that the load command size is not zero */
	    if(lc->cmdsize == 0){
		error("in swap_object_headers(): malformed load command %lu "
		      "(cmdsize is zero)", i);
		return(FALSE);
	    }
	    switch(lc->cmd){
	    case LC_SEGMENT:
		sg = (struct segment_command *)lc;
		if(sg->cmdsize != sizeof(struct segment_command) +
				     sg->nsects * sizeof(struct section)){
		    error("in swap_object_headers(): malformed load command "
			  "(inconsistent cmdsize in LC_SEGMENT command %lu for "
			  "the number of sections)", i);
		    return(FALSE);
		}
		break;

	    case LC_SEGMENT_64:
		sg64 = (struct segment_command_64 *)lc;
		if(sg64->cmdsize != sizeof(struct segment_command_64) +
				     sg64->nsects * sizeof(struct section_64)){
		    error("in swap_object_headers(): malformed load command "
			  "(inconsistent cmdsize in LC_SEGMENT_64 command %lu "
			  "for the number of sections)", i);
		    return(FALSE);
		}
		break;

	    case LC_SYMTAB:
		st = (struct symtab_command *)lc;
		if(st->cmdsize != sizeof(struct symtab_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_SYMTAB command %lu has incorrect cmdsize", i);
		    return(FALSE);
		}
		break;

	    case LC_DYSYMTAB:
		dyst = (struct dysymtab_command *)lc;
		if(dyst->cmdsize != sizeof(struct dysymtab_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_DYSYMTAB command %lu has incorrect cmdsize", i);
		    return(FALSE);
		}
		break;

	    case LC_SYMSEG:
		ss = (struct symseg_command *)lc;
		if(ss->cmdsize != sizeof(struct symseg_command)){
		    error("in swap_object_headers(): malformed load command "
			  "(LC_SYMSEG command %lu has incorrect cmdsize", i);
		    return(FALSE);
		}
		break;

	    case LC_IDFVMLIB:
	    case LC_LOADFVMLIB:
		fl = (struct fvmlib_command *)lc;
		if(fl->cmdsize < sizeof(struct fvmlib_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(%s command %lu has too small cmdsize field)",
			  fl->cmd == LC_IDFVMLIB ? "LC_IDFVMLIB ":
			  "LC_LOADFVMLIB", i);
		    return(FALSE);
		}
		if(fl->fvmlib.name.offset >= fl->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (name.offset field of %s command %lu "
			  "extends past the end of all load commands)",
			  fl->cmd == LC_IDFVMLIB ? "LC_IDFVMLIB ":
			  "LC_LOADFVMLIB", i);
		    return(FALSE);
		}
		break;

	    case LC_ID_DYLIB:
		cmd_name = "LC_ID_DYLIB";
		goto check_dylib_command;
	    case LC_LOAD_DYLIB:
		cmd_name = "LC_LOAD_DYLIB";
		goto check_dylib_command;
	    case LC_LOAD_WEAK_DYLIB:
		cmd_name = "LC_LOAD_WEAK_DYLIB";
		goto check_dylib_command;
	    case LC_REEXPORT_DYLIB:
		cmd_name = "LC_REEXPORT_DYLIB";
		goto check_dylib_command;
	    case LC_LOAD_UPWARD_DYLIB:
		cmd_name = "LC_LOAD_UPWARD_DYLIB";
		goto check_dylib_command;
	    case LC_LAZY_LOAD_DYLIB:
		cmd_name = "LC_LAZY_LOAD_DYLIB";
		goto check_dylib_command;
check_dylib_command:
		dl = (struct dylib_command *)lc;
		if(dl->cmdsize < sizeof(struct dylib_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(%s command %lu has too small cmdsize field)",
			  cmd_name, i);
		    return(FALSE);
		}
		if(dl->dylib.name.offset >= dl->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (name.offset field of %s command %lu "
			  "extends past the end of all load commands)",
			  cmd_name, i);
		    return(FALSE);
		}
		break;

	    case LC_SUB_FRAMEWORK:
		sub = (struct sub_framework_command *)lc;
		if(sub->cmdsize < sizeof(struct sub_framework_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_SUB_FRAMEWORK command %lu has too small cmdsize "
			  "field)", i);
		    return(FALSE);
		}
		if(sub->umbrella.offset >= sub->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (umbrella.offset field of "
			  "LC_SUB_FRAMEWORK command %lu extends past the end "
			  "of all load commands)", i);
		    return(FALSE);
		}
		break;

	    case LC_SUB_UMBRELLA:
		usub = (struct sub_umbrella_command *)lc;
		if(usub->cmdsize < sizeof(struct sub_umbrella_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_SUB_UMBRELLA command %lu has too small cmdsize "
			  "field)", i);
		    return(FALSE);
		}
		if(usub->sub_umbrella.offset >= usub->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (sub_umbrella.offset field of "
			  "LC_SUB_UMBRELLA command %lu extends past the end "
			  "of all load commands)", i);
		    return(FALSE);
		}
		break;

	    case LC_SUB_LIBRARY:
		lsub = (struct sub_library_command *)lc;
		if(lsub->cmdsize < sizeof(struct sub_library_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_SUB_LIBRARY command %lu has too small cmdsize "
			  "field)", i);
		    return(FALSE);
		}
		if(lsub->sub_library.offset >= lsub->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (sub_library.offset field of "
			  "LC_SUB_LIBRARY command %lu extends past the end "
			  "of all load commands)", i);
		    return(FALSE);
		}
		break;

	    case LC_SUB_CLIENT:
		csub = (struct sub_client_command *)lc;
		if(csub->cmdsize < sizeof(struct sub_client_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_SUB_CLIENT command %lu has too small cmdsize "
			  "field)", i);
		    return(FALSE);
		}
		if(csub->client.offset >= csub->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (client.offset field of "
			  "LC_SUB_CLIENT command %lu extends past the end "
			  "of all load commands)", i);
		    return(FALSE);
		}
		break;

	    case LC_PREBOUND_DYLIB:
		pbdylib = (struct prebound_dylib_command *)lc;
		if(pbdylib->cmdsize < sizeof(struct prebound_dylib_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(LC_PREBOUND_DYLIB command %lu has too small "
			  "cmdsize field)", i);
		    return(FALSE);
		}
		if(pbdylib->name.offset >= pbdylib->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (name.offset field of "
			  "LC_PREBOUND_DYLIB command %lu extends past the end "
			  "of all load commands)", i);
		    return(FALSE);
		}
		if(pbdylib->linked_modules.offset >= pbdylib->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (linked_modules.offset field of "
			  "LC_PREBOUND_DYLIB command %lu extends past the end "
			  "of all load commands)", i);
		    return(FALSE);
		}
		break;

	    case LC_ID_DYLINKER:
		cmd_name = "LC_ID_DYLINKER";
		goto check_dylinker_command;
	    case LC_LOAD_DYLINKER:
		cmd_name = "LC_LOAD_DYLINKER";
		goto check_dylinker_command;
	    case LC_DYLD_ENVIRONMENT:
		cmd_name = "LC_DYLD_ENVIRONMENT";
		goto check_dylinker_command;
check_dylinker_command:
		dyld = (struct dylinker_command *)lc;
		if(dyld->cmdsize < sizeof(struct dylinker_command)){
		    error("in swap_object_headers(): malformed load commands "
			  "(%s command %lu has too small cmdsize field)",
			  cmd_name, i);
		    return(FALSE);
		}
		if(dyld->name.offset >= dyld->cmdsize){
		    error("in swap_object_headers(): truncated or malformed "
			  "load commands (name.offset field of %s command %lu "
			  "extends past the end of all load commands)",
			  cmd_name, i);
		    return(FALSE);
		}
		break;

	    case LC_UNIXTHREAD:
	    case LC_THREAD:
		ut = (struct thread_command *)lc;
		state = (char *)ut + sizeof(struct thread_command);

	    	if(cputype == CPU_TYPE_MC680x0){
		    struct m68k_thread_state_regs *cpu;
		    struct m68k_thread_state_68882 *fpu;
		    struct m68k_thread_state_user_reg *user_reg;

		    nflavor = 0;
		    p = (char *)ut + ut->cmdsize;
		    while(state < p){
			flavor = *((uint32_t *)state);
			state += sizeof(uint32_t);
			count = *((uint32_t *)state);
			state += sizeof(uint32_t);
						default:
			    error("in swap_object_headers(): malformed "
				"load commands (unknown "
				"flavor %u for flavor number %lu in %s command"
				 "%lu can't byte swap it)", flavor, nflavor,
				ut->cmd == LC_UNIXTHREAD ? "LC_UNIXTHREAD ":
				"LC_THREAD", i);
			    return(FALSE);
			}
			nflavor++;
		    }
		    break;
		}

	    lc = (struct load_command *)((char *)lc + l.cmdsize);
	    /* check that next load command does not extends past the end */
	    if((char *)lc > (char *)load_commands + sizeofcmds){
		error("in swap_object_headers(): truncated or malformed load "
		      "commands (load command %lu extends past the end of all "
		      "load commands)", i + 1);
		return(FALSE);
	    }
	}
	/* check for an inconsistent size of the load commands */
	if((char *)load_commands + sizeofcmds != (char *)lc){
	    error("in swap_object_headers(): malformed load commands "
		  "(inconsistent sizeofcmds field in mach header)");
	    return(FALSE);
	}


	/*
	 * Now knowing the load commands can be parsed swap them.
	 */
	target_byte_sex = get_host_byte_sex() == BIG_ENDIAN_BYTE_SEX ?
			  LITTLE_ENDIAN_BYTE_SEX : BIG_ENDIAN_BYTE_SEX;
	for(i = 0, lc = load_commands; i < ncmds; i++){
	    l = *lc;
	    switch(lc->cmd){
	    case LC_SEGMENT:
		sg = (struct segment_command *)lc;
		s = (struct section *)
		    ((char *)sg + sizeof(struct segment_command));
		swap_section(s, sg->nsects, target_byte_sex);
		swap_segment_command(sg, target_byte_sex);
		break;

	    case LC_SEGMENT_64:
		sg64 = (struct segment_command_64 *)lc;
		s64 = (struct section_64 *)
		      ((char *)sg64 + sizeof(struct segment_command_64));
		swap_section_64(s64, sg64->nsects, target_byte_sex);
		swap_segment_command_64(sg64, target_byte_sex);
		break;

	    case LC_SYMTAB:
		st = (struct symtab_command *)lc;
		swap_symtab_command(st, target_byte_sex);
		break;

	    case LC_DYSYMTAB:
		dyst = (struct dysymtab_command *)lc;
		swap_dysymtab_command(dyst, target_byte_sex);
		break;

	    case LC_SYMSEG:
		ss = (struct symseg_command *)lc;
		swap_symseg_command(ss, target_byte_sex);
		break;

	    case LC_IDFVMLIB:
	    case LC_LOADFVMLIB:
		fl = (struct fvmlib_command *)lc;
		swap_fvmlib_command(fl, target_byte_sex);
		break;

	    case LC_ID_DYLIB:
	    case LC_LOAD_DYLIB:
	    case LC_LOAD_WEAK_DYLIB:
	    case LC_REEXPORT_DYLIB:
	    case LC_LOAD_UPWARD_DYLIB:
	    case LC_LAZY_LOAD_DYLIB:
		dl = (struct dylib_command *)lc;
		swap_dylib_command(dl, target_byte_sex);
		break;

	    case LC_SUB_FRAMEWORK:
		sub = (struct sub_framework_command *)lc;
		swap_sub_framework_command(sub, target_byte_sex);
		break;

	    case LC_SUB_UMBRELLA:
		usub = (struct sub_umbrella_command *)lc;
		swap_sub_umbrella_command(usub, target_byte_sex);
		break;

	    case LC_SUB_LIBRARY:
		lsub = (struct sub_library_command *)lc;
		swap_sub_library_command(lsub, target_byte_sex);
		break;

	    case LC_SUB_CLIENT:
		csub = (struct sub_client_command *)lc;
		swap_sub_client_command(csub, target_byte_sex);
		break;

	    case LC_PREBOUND_DYLIB:
		pbdylib = (struct prebound_dylib_command *)lc;
		swap_prebound_dylib_command(pbdylib, target_byte_sex);
		break;

	    case LC_ID_DYLINKER:
	    case LC_LOAD_DYLINKER:
	    case LC_DYLD_ENVIRONMENT:
		dyld = (struct dylinker_command *)lc;
		swap_dylinker_command(dyld, target_byte_sex);
		break;

	    case LC_UNIXTHREAD:
	    case LC_THREAD:
		ut = (struct thread_command *)lc;
		state = (char *)ut + sizeof(struct thread_command);
		p = (char *)ut + ut->cmdsize;
		swap_thread_command(ut, target_byte_sex);
                
	    	if(cputype == CPU_TYPE_ARM){
		    arm_thread_state_t *cpu;

		    while(state < p){
			flavor = *((uint32_t *)state);
			*((uint32_t *)state) = SWAP_INT(flavor);
			state += sizeof(uint32_t);
			count = *((uint32_t *)state);
			*((uint32_t *)state) = SWAP_INT(count);
			state += sizeof(uint32_t);
			switch(flavor){
			case ARM_THREAD_STATE:
			    cpu = (arm_thread_state_t *)state;
//			    swap_arm_thread_state_t(cpu, target_byte_sex);
//			    state += sizeof(arm_thread_state_t);
			    break;
			}
		    }
		    break;
		}
		break;

	    case LC_MAIN:
		ep = (struct entry_point_command *)lc;
		swap_entry_point_command(ep, target_byte_sex);
		break;

	    case LC_SOURCE_VERSION:
		sv = (struct source_version_command *)lc;
		swap_source_version_command(sv, target_byte_sex);
		break;

	    case LC_IDENT:
		id = (struct ident_command *)lc;
		swap_ident_command(id, target_byte_sex);
		break;

	    case LC_ROUTINES:
		rc = (struct routines_command *)lc;
		swap_routines_command(rc, target_byte_sex);
		break;

	    case LC_ROUTINES_64:
		rc64 = (struct routines_command_64 *)lc;
		swap_routines_command_64(rc64, target_byte_sex);
		break;

	    case LC_TWOLEVEL_HINTS:
		hints = (struct twolevel_hints_command *)lc;
		swap_twolevel_hints_command(hints, target_byte_sex);
		break;

	    case LC_PREBIND_CKSUM:
		cs = (struct prebind_cksum_command *)lc;
		swap_prebind_cksum_command(cs, target_byte_sex);
		break;

	    case LC_UUID:
		uuid = (struct uuid_command *)lc;
		swap_uuid_command(uuid, target_byte_sex);
		break;

	    case LC_CODE_SIGNATURE:
	    case LC_SEGMENT_SPLIT_INFO:
	    case LC_FUNCTION_STARTS:
	    case LC_DATA_IN_CODE:
	    case LC_DYLIB_CODE_SIGN_DRS:
		ld = (struct linkedit_data_command *)lc;
		swap_linkedit_data_command(ld, target_byte_sex);
		break;

	    case LC_RPATH:
		rpath = (struct rpath_command *)lc;
		swap_rpath_command(rpath, target_byte_sex);
		break;

	    case LC_ENCRYPTION_INFO:
		ec = (struct encryption_info_command *)lc;
		swap_encryption_command(ec, target_byte_sex);
		break;
		
	    case LC_DYLD_INFO:
	    case LC_DYLD_INFO_ONLY:
		dc = (struct dyld_info_command *)lc;
		swap_dyld_info_command(dc, target_byte_sex);
		break;
		
	    case LC_VERSION_MIN_MACOSX:
	    case LC_VERSION_MIN_IPHONEOS:
		vc = (struct version_min_command *)lc;
		swap_version_min_command(vc, target_byte_sex);
		break;
	    }

	    lc = (struct load_command *)((char *)lc + l.cmdsize);
	}
	if(mh != NULL)
	    swap_mach_header(mh, target_byte_sex);
	else
	    swap_mach_header_64(mh64, target_byte_sex);

	return(TRUE);
}
