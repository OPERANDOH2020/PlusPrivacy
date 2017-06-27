//
//  PlistReportsStorage.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportsStorageProtocol.h"


typedef enum : NSUInteger {
    TypeObjectNotInRepository,
} PlistReportsStorageErrorType;

@interface PlistReportsStorage : NSObject <PPPrivacyLevelReportsRepository, PPUnlistedHostReportsRepository, PPUnlistedInputReportsRepository, PPAccessFrequencyReportsRepository>

@end
