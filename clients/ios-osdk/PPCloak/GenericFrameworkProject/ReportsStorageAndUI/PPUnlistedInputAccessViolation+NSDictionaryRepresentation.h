//
//  PPUnlistedInputAccessViolation+NSDictionaryRepresentation.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPUnlistedInputAccessViolation.h"
#import "DictionaryRepresentableProtocol.h"

@interface PPUnlistedInputAccessViolation(NSDictionaryRepresentation) <DictionaryRepresentable>

-(instancetype _Nullable)initWithNSDictionary:(NSDictionary* _Nullable)dictionary;
-(NSDictionary* _Nullable)dictionaryRepresentation;

@end
