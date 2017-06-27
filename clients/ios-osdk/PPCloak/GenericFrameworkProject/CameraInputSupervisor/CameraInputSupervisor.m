//
//  CameraInputSupervisor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/1/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CameraInputSupervisor.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "CommonUtils.h"
#import "JRSwizzle.h"



@interface CameraInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *cameraSensor;

@end

@implementation CameraInputSupervisor

-(void)setupWithModel:(InputSupervisorModel *)model {
    self.model = model;
    self.cameraSensor = [CommonUtils extractInputOfType: InputType.Camera from:model.scdDocument.accessedInputs];
    
}


-(void)processCameraAccess {
    PPUnlistedInputAccessViolation *report = nil;
    if ((report = [self detectUnregisteredAccess])) {
        [self.model.delegate newUnlistedInputAccessViolationReported:report];
    }
}

-(void)processPhotoLibraryAccess {
    [self processCameraAccess];
}

-(PPUnlistedInputAccessViolation*)detectUnregisteredAccess {
    if (self.cameraSensor) {
        return nil;
    }
    
    return [[PPUnlistedInputAccessViolation alloc] initWithInputType:InputType.Camera dateReported:[NSDate date]];
}

-(void)newURLRequestMade:(NSURLRequest *)request{
    
}
@end
