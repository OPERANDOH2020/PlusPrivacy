//
//  DictionaryRepresentableProtocol.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef DictionaryRepresentableProtocol_h
#define DictionaryRepresentableProtocol_h

#import <Foundation/Foundation.h>

@protocol DictionaryRepresentable <NSObject>

-(instancetype _Nullable)initWithNSDictionary:(NSDictionary* _Nullable)dictionary;
-(NSDictionary* _Nullable)dictionaryRepresentation;

@end

#endif /* DictionaryRepresentableProtocol_h */
