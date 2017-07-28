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
#import "ReportsStorageProtocol.h"

typedef void(^PresentNotificationCallback)(NSString* notificationMessage);

@interface PPSupervisingReportRepositories : NSObject

@property (strong, nonatomic) id<PPPrivacyLevelReportsRepository> privacyLevelReportsRepository;
@property (strong, nonatomic) id<PPUnlistedHostReportsRepository> unlistedHostReportsRepository;
@property (strong, nonatomic) id<PPAccessFrequencyReportsRepository> accessFrequencyReportsRepository;
@property (strong, nonatomic) id<PPModuleDeniedAccessReportsRepository> moduleDeniedAccessReportsRepository;
@property (strong, nonatomic) id<PPUnlistedInputReportsRepository> unlistedInputReportsRepository;

@end

@interface PPSupervisingModuleModel : NSObject
@property (readonly, nonatomic) SCDDocument *scd;
@property (readonly, nonatomic) PPEventDispatcher *eventsDispatcher;
@property (readonly, nonatomic) PPSupervisingReportRepositories *reportRepositories;

-(instancetype)initWithSCD:(SCDDocument*)scd eventsDispatcher:(PPEventDispatcher*)eventsDispatcher reportRepositories:(PPSupervisingReportRepositories*)reportRepositories;

@end

@interface PPSupervisingModuleCallbacks : NSObject
@property (strong, nonatomic) PresentNotificationCallback presentNotificationCallback;
@end

@interface PPSupervisingModule : NSObject

-(void)beginSupervisingWithModel:(PPSupervisingModuleModel*)model callbacks:(PPSupervisingModuleCallbacks*)callbacks;

@end
