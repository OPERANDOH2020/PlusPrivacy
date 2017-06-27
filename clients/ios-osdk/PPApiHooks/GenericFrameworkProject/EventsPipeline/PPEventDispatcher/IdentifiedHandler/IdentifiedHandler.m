//
//  IdentifiedHandler.m
//  PPApiHooks
//
//  Created by Costin Andronache on 5/22/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "IdentifiedHandler.h"

@implementation IdentifiedHandler
-(instancetype)initWithIdentifier:(NSString*)identifier handler:(EventHandler)handler {
    if (self = [super init]) {
        self.identifier = identifier;
        self.handler = handler;
    }
    
    return self;
}
@end
