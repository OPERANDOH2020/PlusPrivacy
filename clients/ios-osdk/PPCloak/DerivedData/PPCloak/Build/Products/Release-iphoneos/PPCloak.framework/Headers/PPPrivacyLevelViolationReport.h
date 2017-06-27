//
//  PPPrivacyLevelViolationReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/28/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>

@interface PPPrivacyLevelViolationReport : NSObject

@property (readonly, nonatomic) InputType *inputType;
@property (readonly, nonatomic) PrivacyLevelType violatedPrivacyLevel;
@property (readonly, nonatomic) NSString *destinationURLForData;

-(instancetype)initWithInputType:(InputType*)inputType violatedPrivacyLevel:(PrivacyLevelType)privacyLevel destinationURL:(NSString*)destinationURL;

@end
