//
//  OPMonitorInputSourceReport.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlusPrivacyCommonTypes/PlusPrivacyCommonTypes.h>

@interface OPMonitorInputSourceEvent : NSObject
@property (strong, nonatomic, readonly) NSString *accessFrequencyType;
@property (strong, nonatomic, readonly) NSArray *values;


-(instancetype)initWithType:(NSString*)accessFrequencyType sampleValues:(NSArray*)sampleValues;

@end
