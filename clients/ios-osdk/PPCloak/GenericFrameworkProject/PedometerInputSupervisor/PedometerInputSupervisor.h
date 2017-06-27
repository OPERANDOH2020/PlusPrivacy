//
//  PedometerInputSupervisor.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "SupervisorProtocols.h"

@interface PedometerInputSupervisor : NSObject <InputSourceSupervisor>
-(void)processPedometerStatus;
@end
