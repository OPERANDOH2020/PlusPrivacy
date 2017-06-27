//
//  OPMonitorInputSourceReport.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitorInputSourceEvent.h"

@interface OPMonitorInputSourceEvent()

@property (strong, nonatomic, readwrite) NSString *accessFrequencyType;
@property (strong, nonatomic, readwrite) NSArray *values;

@end

@implementation OPMonitorInputSourceEvent

-(instancetype)initWithType:(NSString *)accessFrequencyType sampleValues:(NSArray *)sampleValues {
    if (self = [super init]) {
        self.accessFrequencyType = accessFrequencyType;
        self.values = sampleValues;
    }
    
    return self;
}

@end
