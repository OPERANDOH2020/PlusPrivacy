//
//  PerSecondReportAggregator.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PerSecondReportAggregator.h"

@implementation PerSecondReportAggregator

-(NSArray<NSArray<BaseReportWithDate*>*> *_Nonnull)aggregateReports:(NSArray<BaseReportWithDate*> * _Nonnull)reports inSecondGroupsOfLength:(NSInteger)numOfSeconds {
    
    if (reports.count == 1) {
        return @[reports];
    }
    
    NSArray *sortedReportsByDate = [reports sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        BaseReportWithDate *a = obj1, *b = obj2;
        return [a.reportDate compare:b.reportDate];
        
    }];
    
    
    BaseReportWithDate *first = sortedReportsByDate.firstObject;
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSInteger currentArrayIndex = 0;
    NSDate *maxDateForCurrentSecond = [first.reportDate dateByAddingTimeInterval:numOfSeconds];
    
    while (currentArrayIndex < sortedReportsByDate.count) {
        
        NSMutableArray *itemsForCurrentGroup = [[NSMutableArray alloc] init];
        BOOL keepScanningForCurrentDate = YES;

        while (currentArrayIndex < sortedReportsByDate.count && keepScanningForCurrentDate) {
            BaseReportWithDate *report = sortedReportsByDate[currentArrayIndex];
            NSComparisonResult comparisonResult = [report.reportDate compare:maxDateForCurrentSecond];
            if (comparisonResult == NSOrderedSame || comparisonResult == NSOrderedAscending) {
                [itemsForCurrentGroup addObject:report];
                currentArrayIndex++;
            } else {
                keepScanningForCurrentDate = NO;
            }
        }
        
        [result addObject:itemsForCurrentGroup];
        if (currentArrayIndex < sortedReportsByDate.count) {
            BaseReportWithDate *unprocessedReport = sortedReportsByDate[currentArrayIndex];
            maxDateForCurrentSecond = [unprocessedReport.reportDate dateByAddingTimeInterval:numOfSeconds];
        }
    }
    
    
    return result;
}

@end
