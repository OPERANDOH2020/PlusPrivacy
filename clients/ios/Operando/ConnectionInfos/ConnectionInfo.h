//
//  SystemMonitor.h
//  SystemMonitor
//
//  Created by Ren, Alice on 7/24/14.
//
//

#import <Foundation/Foundation.h>


@interface ConnectionPair : NSObject

@property (strong, nonatomic, nullable) NSString *address;
@property (assign, nonatomic) NSInteger port;

-(id)initWithAddress:(char*)address andPort:(NSInteger)port;

@end


@interface ConnectionInfo : NSObject

@property (strong, nonatomic) ConnectionPair *localConnection;
@property (strong, nonatomic) ConnectionPair *foreignConnection;
@property (strong, nonatomic) NSString *tcpState;

@end

@interface ConnectionInfoHelper : NSObject

NSMutableArray* getActiveConnections(uint32_t proto, char *name, int af);
+(NSArray<ConnectionInfo*>*) printTCPConnections;
+ (NSArray<ConnectionInfo*>*) printUDPConnections;

@end
