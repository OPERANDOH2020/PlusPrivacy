//
//  PPInputSwizzlingModule.h
//  PPCloak
//
//  Created by Costin Andronache on 7/27/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPApiHooksCore/PPApiHooksCore.h>


@interface PPInputSwizzlingModule : NSObject
-(void)installInputSwizzlerOnEventDispatcher:(PPEventDispatcher*)eventsDispatcher;

@end
