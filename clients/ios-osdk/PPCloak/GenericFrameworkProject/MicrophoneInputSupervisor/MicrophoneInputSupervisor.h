//
//  MicrophoneInputSupervisor.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"

@interface MicrophoneInputSupervisor : NSObject <InputSourceSupervisor>

-(void)processMicrophoneUsage;

@end
