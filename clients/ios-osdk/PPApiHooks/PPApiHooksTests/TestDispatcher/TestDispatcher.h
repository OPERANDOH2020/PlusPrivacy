//
//  TestDispatcher.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEventDispatcher+Internal.h"

#define weak_XCTAssert(expression, ...) \
_XCTPrimitiveAssertTrue(weakself, expression, @#expression, __VA_ARGS__)

BOOL doublesApproximatelyEqual(double a, double b);
 

@interface TestDispatcher : PPEventDispatcher
@property (strong, nonatomic) void (^testEventHandler)(PPEvent *event);
@end
