//
//  UIWindow+RSHookHandle.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIWindow+RSHookHandle.h"
#import "OPMonitor.h"
#import "JRSwizzle.h"

@interface OPMonitor(FrameworkPrivate)
+(OPMonitor*)sharedInstance;
-(UIButton*)getHandle;
@end

@implementation UIWindow(rsHookHandle)

static UIButton *handle = nil;
static NSTimer *repositionHandleTimer = nil;

+(void)load {
    [self jr_swizzleMethod:@selector(addSubview:) withMethod:@selector(rsHook_addSubview:) error:nil];
}


-(void)rsHook_addSubview:(UIView*)view {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[OPMonitor sharedInstance] getHandle];
        [handle addTarget:self action:@selector(rsHookdragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            if ([self.subviews containsObject:handle]) {
                [self bringSubviewToFront:handle];
            } else {
                [self rsHook_addSubview:handle];
            }
        }];
        

        
        repositionHandleTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:blockOperation selector:@selector(main) userInfo:nil repeats:YES];
    });
    
    [self rsHook_addSubview:view];
}


- (void)rsHookdragMoving: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self];
}

- (void)rsHookdragEnded: (UIControl *) c withEvent:ev
{
    c.center = [[[ev allTouches] anyObject] locationInView:self];
}

@end
