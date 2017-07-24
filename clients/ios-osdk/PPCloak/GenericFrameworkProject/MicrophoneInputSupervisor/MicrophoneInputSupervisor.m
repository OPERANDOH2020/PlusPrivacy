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





BOOL isMicrophoneEvent(NSInteger subType, NSDictionary *evData){
    NSString *mediaTypeValue = evData[kPPCaptureDeviceMediaTypeValue];
    if (subType == EventCaptureDeviceGetDefaultDeviceWithMediaType &&
        [mediaTypeValue isEqualToString:AVMediaTypeAudio]) {
        return YES;
    }
    
    if (subType == EventCaptureDeviceGetDefaultDeviceWithTypeMediaTypeAndPosition &&
        ([mediaTypeValue isEqualToString:AVMediaTypeAudio] ||
         [mediaTypeValue isEqualToString:AVMediaTypeMuxed])) {
            return YES;
        }
    
    return NO;
}

@interface MicrophoneInputSupervisor()
@end

@implementation MicrophoneInputSupervisor



-(InputType *)monitoringInputType {
    return InputType.Microphone;
}

-(BOOL)isEventOfInterest:(PPEvent *)event {
    return (event.eventIdentifier.eventType == PPAVCaptureDeviceEvent) &&
    isMicrophoneEvent(event.eventIdentifier.eventSubtype, event.eventData);
}





-(void)newURLRequestMade:(NSURLRequest *)request{
    
}


@end
