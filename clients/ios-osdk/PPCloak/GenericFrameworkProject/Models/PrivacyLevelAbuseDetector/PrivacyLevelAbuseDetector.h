//
//  PrivacyLevelAbuseDetector.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/9/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPCommonTypes/PPCommonTypes.h>
#import "PPPrivacyLevelViolationReport.h"

@interface PrivacyLevelAbuseDetector : NSObject
-(instancetype _Nonnull)initWithDocument:(SCDDocument* _Nonnull)document;

-(PPPrivacyLevelViolationReport* _Nullable)detectViolationForInput:(AccessedInput* _Nonnull)input sentOverNetworkRequest:(NSURLRequest* _Nonnull)request;
@end
