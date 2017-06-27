//
//  MicrophoneInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "MicrophoneInputSupervisor.h"
#import "Common.h"
#import "CommonUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "JRSwizzle.h"


@interface MicrophoneInputSupervisor()
@property (strong, nonatomic) AccessedInput *micSensor;
@property (strong, nonatomic) InputSupervisorModel *model;
@end

@implementation MicrophoneInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.micSensor = [CommonUtils extractInputOfType:InputType.Microphone from:model.scdDocument.accessedInputs];
}


-(void)processMicrophoneUsage {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.micSensor) {
        return nil;
    }
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Microphone dateReported:[NSDate date]];
}
-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
