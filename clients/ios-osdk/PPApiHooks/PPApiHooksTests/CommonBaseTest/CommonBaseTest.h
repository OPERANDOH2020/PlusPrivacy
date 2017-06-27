//
//  CommonBaseTest.h
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PPEventDispatcher+Internal.h"
#import "TestDispatcher.h"

@interface CommonBaseTest : XCTestCase
@property (strong, nonatomic) TestDispatcher *testDispatcher;

-(void)assertIdentifier:(PPEventIdentifier)identifier equals:(PPEventIdentifier)other;
-(void)assertDictionary:(NSDictionary*)dict containsValuesForKeys:(NSArray*)keys;


@end
