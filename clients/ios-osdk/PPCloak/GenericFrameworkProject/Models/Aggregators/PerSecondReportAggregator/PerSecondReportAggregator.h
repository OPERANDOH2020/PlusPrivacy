//
//  PerSecondReportAggregator.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseReportWithDate.h"

@interface PerSecondReportAggregator : NSObject
-(NSArray<NSArray<BaseReportWithDate*>*> *_Nonnull)aggregateReports:(NSArray<BaseReportWithDate *> * _Nonnull)reports inSecondGroupsOfLength:(NSInteger)numOfSeconds;
@end
