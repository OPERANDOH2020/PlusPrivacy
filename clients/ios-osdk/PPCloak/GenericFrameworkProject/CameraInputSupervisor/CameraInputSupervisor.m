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

BOOL isCameraEvent(int subType, NSDictionary *evData){
    
    NSString *mediaTypeValue = evData[kPPCaptureDeviceMediaTypeValue];
    if (subType == EventCaptureDeviceGetDefaultDeviceWithMediaType &&
        [mediaTypeValue isEqualToString:AVMediaTypeVideo]) {
        return YES;
    }
    
    if (subType == EventCaptureDeviceGetDefaultDeviceWithTypeMediaTypeAndPosition &&
        ([mediaTypeValue isEqualToString:AVMediaTypeVideo] ||
         [mediaTypeValue isEqualToString:AVMediaTypeMuxed])) {
            return YES;
    }
    
    return NO;
}


@interface AVCameraInputSupervisor()
@property (strong, nonatomic) InputSupervisorModel *model;
@property (strong, nonatomic) AccessedInput *cameraSensor;

@end

@implementation AVCameraInputSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPAVCaptureDeviceEvent) &&
    isCameraEvent(event.eventIdentifier.eventSubtype, event.eventData);
}

-(InputType *)monitoringInputType {
    return InputType.Camera;
}


-(void)denyValuesOrActionsForModuleName:(NSString*)moduleName inEvent:(PPEvent*)event {
    // apply SDKC code here
    
}



@end
