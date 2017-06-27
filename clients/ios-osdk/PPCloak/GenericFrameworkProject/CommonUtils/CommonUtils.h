//
//  CommonUtils.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/31/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPCommonTypes/PPCommonTypes.h>

@interface CommonUtils : NSObject

+(AccessedInput *)extractInputOfType:(InputType *)type from:(NSArray<AccessedInput *> *)sensors;
@end
