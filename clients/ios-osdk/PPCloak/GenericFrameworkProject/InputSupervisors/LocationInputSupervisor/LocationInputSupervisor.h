//
//  LocationInputSupervisor.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/20/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SupervisorProtocols.h"
#import "Common.h"
#import "LocationInputSwizzler.h"

@interface LocationInputSupervisor : NSObject <InputSourceSupervisor>
-(void)processNewlyRequestedLocations:(NSArray<CLLocation*>* _Nonnull)locations;
@end
