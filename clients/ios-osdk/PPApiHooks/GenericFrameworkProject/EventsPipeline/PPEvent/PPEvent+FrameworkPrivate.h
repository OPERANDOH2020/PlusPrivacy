//
//  PPEvent+FrameworkPrivate.h
//  PPApiHooks
//
//  Created by Costin Andronache on 3/15/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPEvent.h"

@interface PPEvent(FrameworkPrivate)
-(void)consumeWhenNoHandlerAvailable;
@end
