//
//  NSURLSessionHook.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 11/28/16.
//  Copyright © 2016 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"
#import "Common.h"


@interface NSURLSessionSupervisor: NSObject <InputSourceSupervisor>
@end
