/*
 * Original method implementations by Apple (inet.c); modified by AR on 7/24/2014
 */

/*
 * Copyright (c) 2008 Apple Inc. All rights reserved.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_START@
 *
 * This file contains Original Code and/or Modifications of Original Code
 * as defined in and that are subject to the Apple Public Source License
 * Version 2.0 (the 'License'). You may not use this file except in
 * compliance with the License. The rights granted to you under the License
 * may not be used to create, or enable the creation or redistribution of,
 * unlawful or unlicensed copies of an Apple operating system, or to
 * circumvent, violate, or enable the circumvention or violation of, any
 * terms of an Apple operating system software license agreement.
 *
 * Please obtain a copy of the License at
 * http://www.opensource.apple.com/apsl/ and read it before using this file.
 *
 * The Original Code and all software distributed under the License are
 * distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
 * EXPRESS OR IMPLIED, AND APPLE HEREBY DISCLAIMS ALL SUCH WARRANTIES,
 * INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT.
 * Please see the License for the specific language governing rights and
 * limitations under the License.
 *
 * @APPLE_OSREFERENCE_LICENSE_HEADER_END@
 */
/*
 * Copyright (c) 1983, 1988, 1993, 1995
 *	The Regents of the University of California.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#import "ConnectionInfo.h"
#import "otherConnectionHeaders.h"

@implementation ConnectionPair

//welp, w/e 
+ (NSString *)reverseString:(NSString *)str
{
    NSMutableString *reversed = [NSMutableString string];
    NSInteger charIndex = [str length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subRange = NSMakeRange(charIndex, 1);
        [reversed appendString:[str substringWithRange:subRange]];
    }
    return reversed;
}

-(id)initWithAddress:(char *)address andPort:(NSInteger)port
{
    if (self = [super init]) {
        self.address = [NSString stringWithCString:address encoding:NSASCIIStringEncoding];
        self.port = port;
    }
    
    return  self;
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"Address: %@ port: %ld", self.address, (long)self.port];
}
@end

@implementation ConnectionInfo

-(NSString *)description
{
    return [NSString stringWithFormat:@"Local connection: %@ foreignConnection: %@ state: %@", self.localConnection, self.foreignConnection, self.tcpState];
}

@end

@implementation ConnectionInfoHelper


char *tcpstates[] = {
    "CLOSED",	"LISTEN",	"SYN_SENT",	"SYN_RCVD",
    "ESTABLISHED",	"CLOSE_WAIT",	"FIN_WAIT_1",	"CLOSING",
    "LAST_ACK",	"FIN_WAIT_2",	"TIME_WAIT"
};

int	aflag = 1;	/* show all sockets (including servers) */
int	bflag = 0;	/* show i/f total bytes in/out */
int	Lflag = 0;	/* show size of listen queues */
int	Wflag = 1;	/* wide display */
int	sflag = 0;	/* show protocol statistics */
int Aflag = 0;
int nflag = 1;

typedef struct
{
    char *address;
    int port;
} PrintInfo;

char *
inetname(struct in_addr *inp)
{
    register char *cp;
    static char line[MAXHOSTNAMELEN];
    struct hostent *hp;
    struct netent *np;
    
    cp = 0;
    if (!nflag && inp->s_addr != INADDR_ANY) {
        int net = inet_netof(*inp);
        int lna = inet_lnaof(*inp);
        
        if (lna == INADDR_ANY) {
            np = getnetbyaddr(net, AF_INET);
            if (np)
                cp = np->n_name;
        }
        if (cp == 0) {
            hp = gethostbyaddr((char *)inp, sizeof (*inp), AF_INET);
            if (hp) {
                cp = hp->h_name;
                //### trimdomain(cp, strlen(cp));
            }
        }
    }
    if (inp->s_addr == INADDR_ANY)
        strcpy(line, "*");
    else if (cp) {
        strncpy(line, cp, sizeof(line) - 1);
        line[sizeof(line) - 1] = '\0';
    } else {
        inp->s_addr = ntohl(inp->s_addr);
#define C(x)	((u_int)((x) & 0xff))
        sprintf(line, "%u.%u.%u.%u", C(inp->s_addr >> 24),
                C(inp->s_addr >> 16), C(inp->s_addr >> 8), C(inp->s_addr));
    }
    return (line);
}


PrintInfo inet6print(struct in6_addr *in6, int port)
{
    char line[1024];
    PrintInfo pi;
    
    
    if( NULL == inet_ntop(AF_INET6, in6, line, INET6_ADDRSTRLEN))
    {
        pi.address = "--unknown--";
    }
    else
    {
        pi.address = line;
    }
    
    pi.port = ntohs(port);
    
    return  pi;
}

PrintInfo inetprint(struct in_addr *in, int port, char *proto, int numeric_port)
{
    struct servent *sp = 0;
    char line[80], *cp;
    int width;
    
    char *ipString = inetname(in);
    
    if (Wflag)
        sprintf(line, "%s.", ipString);
    else
        sprintf(line, "%.*s.", (Aflag && !numeric_port) ? 12 : 16, inetname(in));
    cp = index(line, '\0');
    if (!numeric_port && port)
    sp = getservbyport((int)port, proto);
    if (sp || port == 0)
        sprintf(cp, "%.15s ", sp ? sp->s_name : "*");
    else
        sprintf(cp, "%d ", ntohs((u_short)port));
    width = (Aflag && !Wflag) ? 18 : 22;
    if (Wflag)
        printf("%-*s ", width, line);
    else
        printf("%-*.*s ", width, width, line);
    
    PrintInfo pi;
    pi.address = ipString;
    pi.port = ntohs(port);
    return pi;
}


NSArray<ConnectionInfo*>* protopr(uint32_t proto, char *name, int af)
{
    NSMutableArray *connectionInfos = [[NSMutableArray alloc] init];
    
    int istcp;
    static int first = 1;
    char *buf;
    const char *mibvar;
    struct xinpgen *xig, *oxig;
#if !TARGET_OS_EMBEDDED
    struct xtcpcb64 *tp = NULL;
    struct xinpcb64 *inp;
    struct xsocket64 *so;
#else
    struct tcpcb *tp = NULL;
    struct inpcb *inp;
    struct xsocket *so;
#endif
    size_t len;
    
    istcp = 0;
    switch (proto) {
        case IPPROTO_TCP:
#ifdef INET6
            if (tcp_done != 0)
                return;
            else
                tcp_done = 1;
#endif
            istcp = 1;
#if !TARGET_OS_EMBEDDED
            mibvar = "net.inet.tcp.pcblist64";
#else
            mibvar = "net.inet.tcp.pcblist";
#endif
            break;
        case IPPROTO_UDP:
#ifdef INET6
            if (udp_done != 0)
                return;
            else
                udp_done = 1;
#endif
#if !TARGET_OS_EMBEDDED
            mibvar = "net.inet.udp.pcblist64";
#else
            mibvar = "net.inet.udp.pcblist";
#endif
            break;
        case IPPROTO_DIVERT:
#if !TARGET_OS_EMBEDDED
            mibvar = "net.inet.divert.pcblist64";
#else
            mibvar = "net.inet.divert.pcblist";
#endif
            break;
        default:
#if !TARGET_OS_EMBEDDED
            mibvar = "net.inet.raw.pcblist64";
#else
            mibvar = "net.inet.raw.pcblist";
#endif
            break;
    }
    len = 0;
    if (sysctlbyname(mibvar, 0, &len, 0, 0) < 0) {
        if (errno != ENOENT)
            warn("sysctl: %s", mibvar);
        return nil;
    }
    if ((buf = malloc(len)) == 0) {
        warn("malloc %lu bytes", (u_long)len);
        return nil;
    }
    if (sysctlbyname(mibvar, buf, &len, 0, 0) < 0) {
        warn("sysctl: %s", mibvar);
        free(buf);
        return nil;
    }
    
    /*
     * Bail-out to avoid logic error in the loop below when
     * there is in fact no more control block to process
     */
    if (len <= sizeof(struct xinpgen)) {
        free(buf);
        return nil;
    }
    
    oxig = xig = (struct xinpgen *)buf;
    for (xig = (struct xinpgen *)((char *)xig + xig->xig_len);
         xig->xig_len > sizeof(struct xinpgen);
         xig = (struct xinpgen *)((char *)xig + xig->xig_len))
    {
        ConnectionInfo *connectionInfo = [[ConnectionInfo alloc] init];
        
        if (istcp) {
#if !TARGET_OS_EMBEDDED
            tp = (struct xtcpcb64 *)xig;
            inp = &tp->xt_inpcb;
            so = &inp->xi_socket;
#else
            tp = &((struct xtcpcb *)xig)->xt_tp;
            inp = &((struct xtcpcb *)xig)->xt_inp;
            so = &((struct xtcpcb *)xig)->xt_socket;
#endif
        } else {
#if !TARGET_OS_EMBEDDED
            inp = (struct xinpcb64 *)xig;
            so = &inp->xi_socket;
#else
            inp = &((struct xinpcb *)xig)->xi_inp;
            so = &((struct xinpcb *)xig)->xi_socket;
#endif
        }
        
        /* Ignore sockets for protocols other than the desired one. */
        if (so->xso_protocol != (int)proto)
            continue;
        
        /* Ignore PCBs which were freed during copyout. */
        if (inp->inp_gencnt > oxig->xig_gen)
            continue;
        
        if ((af == AF_INET && (inp->inp_vflag & INP_IPV4) == 0)
#ifdef INET6
            || (af == AF_INET6 && (inp->inp_vflag & INP_IPV6) == 0)
#endif /* INET6 */
            || (af == AF_UNSPEC && ((inp->inp_vflag & INP_IPV4) == 0
#ifdef INET6
                                    && (inp->inp_vflag &
                                        INP_IPV6) == 0
#endif /* INET6 */
                                    ))
            )
            continue;
        
        /*
         * Local address is not an indication of listening socket or
         * server sockey but just rather the socket has been bound.
         * That why many UDP sockets were not displayed in the original code.
         */
        if (!aflag && istcp && tp->t_state <= TCPS_LISTEN)
            continue;
        
        if (Lflag && !so->so_qlimit)
            continue;
        
        if (first) {
            if (!Lflag) {
                printf("Active Internet connections");
                if (aflag)
                    printf(" (including servers)");
            } else
                printf(
                       "Current listen queue sizes (qlen/incqlen/maxqlen)");
            putchar('\n');
            if (Aflag)
#if !TARGET_OS_EMBEDDED
                printf("%-16.16s ", "Socket");
#else
            printf("%-8.8s ", "Socket");
#endif
            if (Lflag)
                printf("%-14.14s %-22.22s\n",
                       "Listen", "Local Address");
            else
                printf((Aflag && !Wflag) ?
                       "%-5.5s %-6.6s %-6.6s  %-18.18s %-18.18s %s\n" :
                       "%-5.5s %-6.6s %-6.6s  %-22.22s %-22.22s %s\n",
                       "Proto", "Recv-Q", "Send-Q",
                       "Local Address", "Foreign Address",
                       "(state)");
            first = 0;
        }
        if (Aflag) {
            if (istcp)
#if !TARGET_OS_EMBEDDED
                printf("%16lx ", (u_long)inp->inp_ppcb);
#else
            printf("%8lx ", (u_long)inp->inp_ppcb);
            
#endif
            else
#if !TARGET_OS_EMBEDDED
                printf("%16lx ", (u_long)so->so_pcb);
#else
            printf("%8lx ", (u_long)so->so_pcb);
#endif
        }
        if (Lflag) {
            char buf[15];
            
            snprintf(buf, 15, "%d/%d/%d", so->so_qlen,
                     so->so_incqlen, so->so_qlimit);
            printf("%-14.14s ", buf);
        }
        else {
            const char *vchar;
            
#ifdef INET6
            if ((inp->inp_vflag & INP_IPV6) != 0)
                vchar = ((inp->inp_vflag & INP_IPV4) != 0)
                ? "46" : "6 ";
            else
#endif
                vchar = ((inp->inp_vflag & INP_IPV4) != 0)
                ? "4 " : "  ";
            
            printf("%-3.3s%-2.2s %6u %6u  ", name, vchar,
                   so->so_rcv.sb_cc,
                   so->so_snd.sb_cc);
        }
        if (nflag)
        {
            if (inp->inp_vflag & INP_IPV4)
            {
                PrintInfo localPi = inetprint(&inp->inp_laddr, (int)inp->inp_lport,name, 1);
                PrintInfo foreignPi = inetprint(&inp->inp_faddr,(int)inp->inp_fport, name, 1);
                
                connectionInfo.localConnection = [[ConnectionPair alloc] initWithAddress:localPi.address andPort:localPi.port];
                connectionInfo.foreignConnection = [[ConnectionPair alloc] initWithAddress:foreignPi.address andPort:foreignPi.port];
            }
#ifdef INET6
            else if (inp->inp_vflag & INP_IPV6)
            {
                PrintInfo localPi = inet6print(&inp->in6p_laddr,(int)inp->inp_lport);
                PrintInfo foreignPi = inet6print(&inp->in6p_faddr,(int)inp->inp_fport);
                
                connectionInfo.localConnection = [[ConnectionPair alloc] initWithAddress:localPi.address andPort:localPi.port];
                connectionInfo.foreignPair = [[ConnectionPair alloc] initWithAddress:foreignPi.address andPort:foreignPi.port];
                
            } /* else nothing printed now */
#endif /* INET6 */
        } else if (inp->inp_flags & INP_ANONPORT)
        {
            if (inp->inp_vflag & INP_IPV4) {
                inetprint(&inp->inp_laddr, (int)inp->inp_lport,
                          name, 1);
                if (!Lflag)
                    inetprint(&inp->inp_faddr,
                              (int)inp->inp_fport, name, 0);
            }
#ifdef INET6
            else if (inp->inp_vflag & INP_IPV6) {
                inet6print(&inp->in6p_laddr,
                           (int)inp->inp_lport, name, 1);
                if (!Lflag)
                    inet6print(&inp->in6p_faddr,
                               (int)inp->inp_fport, name, 0);
            } /* else nothing printed now */
#endif /* INET6 */
        } else {
            if (inp->inp_vflag & INP_IPV4) {
                inetprint(&inp->inp_laddr, (int)inp->inp_lport,
                          name, 0);
                if (!Lflag)
                    inetprint(&inp->inp_faddr,
                              (int)inp->inp_fport, name,
                              inp->inp_lport !=
                              inp->inp_fport);
            }
#ifdef INET6
            else if (inp->inp_vflag & INP_IPV6)
            {
                inet6print(&inp->in6p_laddr,(int)inp->inp_lport, name, 0);
                if (!Lflag)
                    inet6print(&inp->in6p_faddr,
                               (int)inp->inp_fport, name,
                               inp->inp_lport !=
                               inp->inp_fport);
            } /* else nothing printed now */
#endif /* INET6 */
        }
        if (istcp && !Lflag) {
            if (tp->t_state < 0 || tp->t_state >= TCP_NSTATES)
                printf("%d", tp->t_state);
            else {
                printf("%s", tcpstates[tp->t_state]);
                connectionInfo.tcpState = [NSString stringWithCString:tcpstates[tp->t_state] encoding:NSASCIIStringEncoding];
#if defined(TF_NEEDSYN) && defined(TF_NEEDFIN)
                /* Show T/TCP `hidden state' */
                if (tp->t_flags & (TF_NEEDSYN|TF_NEEDFIN))
                    putchar('*');
#endif /* defined(TF_NEEDSYN) && defined(TF_NEEDFIN) */
            }
        }
        putchar('\n');
        [connectionInfos addObject:connectionInfo];
    }
    if (xig != oxig && xig->xig_gen != oxig->xig_gen) {
        if (oxig->xig_count > xig->xig_count) {
            printf("Some %s sockets may have been deleted.\n",
                   name);
        } else if (oxig->xig_count < xig->xig_count) {
            printf("Some %s sockets may have been created.\n",
                   name);
        } else {
            printf("Some %s sockets may have been created or deleted",
                   name);
        }
    }
    free(buf);
    return connectionInfos;
}


+(NSArray<ConnectionInfo*>*) printTCPConnections
{
    return protopr(IPPROTO_TCP, "tcp", AF_INET);
}

+ (NSArray<ConnectionInfo*>*) printUDPConnections
{
    return protopr(IPPROTO_UDP, "udp", AF_INET);
}



@end
