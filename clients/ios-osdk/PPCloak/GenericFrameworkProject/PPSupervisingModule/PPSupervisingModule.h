//
//  PPSupervisingModule.h
//  PPCloak
//
//  Created by Costin Andronache on 7/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"
#import <PPApiHooksCore/PPApiHooksCore.h>
#import <PPCommonTypes/PPCommonTypes.h>

typedef void(^PresentNotificationCallback)(NSString* notificationMessage);

@interface PPSupervisingModuleModel : NSObject
@property (readonly, nonatomic) SCDDocument *scd;
@property (readonly, nonatomic) PPEventDispatcher *eventsDispatcher;

-(instancetype)initWithSCD:(SCDDocument*)scd eventsDispatcher:(PPEventDispatcher*)eventsDispatcher;

@end

@interface PPSupervisingModuleCallbacks : NSObject
@property (strong, nonatomic) PresentNotificationCallback presentNotificationCallback;
@end

@interface PPSupervisingModule : NSObject

-(void)beginSupervisingWithModel:(PPSupervisingModuleModel*)model callbacks:(PPSupervisingModuleCallbacks*)callbacks;

@end
