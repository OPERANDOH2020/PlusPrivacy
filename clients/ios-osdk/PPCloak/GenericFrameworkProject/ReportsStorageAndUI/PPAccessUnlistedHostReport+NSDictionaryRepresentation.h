//
//  PPAccessUnlistedHostReport+NSDictionaryRepresentation.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPAccessUnlistedHostReport.h"
#import "DictionaryRepresentableProtocol.h"

@interface PPAccessUnlistedHostReport(NSDictionaryRepresentation) <DictionaryRepresentable>

-(instancetype _Nullable)initWithNSDictionary:(NSDictionary* _Nullable)dictionary;
-(NSDictionary* _Nullable)dictionaryRepresentation;

@end
