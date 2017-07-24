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

BOOL isCameraEvent(NSInteger subType, NSDictionary *evData){
    
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

@end

@implementation AVCameraInputSupervisor


-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPAVCaptureDeviceEvent) &&
    isCameraEvent(event.eventIdentifier.eventSubtype, event.eventData);
}

-(InputType *)monitoringInputType {
    return InputType.Camera;
}


@end
