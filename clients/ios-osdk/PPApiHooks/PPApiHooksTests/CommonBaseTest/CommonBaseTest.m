//
//  CommonBaseTest.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/8/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "CommonBaseTest.h"

@implementation CommonBaseTest


-(void)setUp{
    [super setUp];
    if (!self.testDispatcher) {
        self.testDispatcher = [[TestDispatcher alloc] init];
    }
}

-(void)assertIdentifier:(PPEventIdentifier)i equals:(PPEventIdentifier)o{
    XCTAssert(i.eventType == o.eventType && i.eventSubtype == o.eventSubtype, @"Expected identifiers to match!");
}

-(void)assertDictionary:(NSDictionary *)dict containsValuesForKeys:(NSArray *)keys{
    for (NSString* stringKey in keys) {
        XCTAssert(dict[stringKey] != nil, @"Expected to find value for key: %@", stringKey);
    }
}

@end
