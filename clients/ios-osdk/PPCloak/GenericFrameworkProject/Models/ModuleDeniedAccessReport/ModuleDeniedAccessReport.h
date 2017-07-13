//
//  ModuleDeniedAccessReport.h
//  PPCloak
//
//  Created by Costin Andronache on 7/13/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PPCommonTypes/PPCommonTypes.h>

@interface ModuleDeniedAccessReport : NSObject
@property (readonly, nonatomic) NSString *moduleName;
@property (readonly, nonatomic) InputType *inputType;



-(instancetype)initWithModuleName:(NSString*)moduleName inputType:(InputType*)inputType;

@end
