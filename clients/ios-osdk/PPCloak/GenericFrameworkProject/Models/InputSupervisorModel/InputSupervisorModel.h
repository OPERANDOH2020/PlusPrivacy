//
//  InputSupervisorModel.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/9/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPCommonTypes/PPCommonTypes.h>
#import "PrivacyLevelAbuseDetector.h"
#import "LocationHTTPAnalyzer.h"
#import <PPApiHooksCore/PPApiHooksCore.h>

@protocol InputSupervisorDelegate;

@interface HTTPAnalyzers : NSObject
@property (strong, nonatomic) LocationHTTPAnalyzer *locationHTTPAnalyzer;
// more to come later

@end

@interface InputSupervisorModel : NSObject
@property (strong, nonatomic) id<InputSupervisorDelegate> delegate;
@property (strong, nonatomic) SCDDocument *scdDocument;
@property (strong, nonatomic) PrivacyLevelAbuseDetector *privacyLevelAbuseDetector;
@property (strong, nonatomic) HTTPAnalyzers *httpAnalyzers;
@property (strong, nonatomic) PPEventDispatcher *eventsDispatcher;
@end
