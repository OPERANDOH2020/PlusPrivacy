//
//  TestDispatcher.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "TestDispatcher.h"

@implementation TestDispatcher

-(void)fireEvent:(PPEvent *)event{
    SAFECALL(self.testEventHandler, event)
}

@end


BOOL doublesApproximatelyEqual(double a, double b){
    const double epsilon = 1e-2;
    double difference = fabs(fabs(a) - fabs(b));
    return difference <= epsilon;
}
