//
//  URLFormParsersProtocols.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 3/10/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#ifndef URLFormParsersProtocols_h
#define URLFormParsersProtocols_h

#import <Foundation/Foundation.h>

typedef void(^DictionaryParsingCompletion)(NSDictionary* _Nullable result, NSError* _Nullable error);
@protocol HTTPBodyParser <NSObject>

-(void)parseJSONFromBodyData:(NSData* _Nonnull)bodyData withCompletion:(DictionaryParsingCompletion _Nullable)completion;
-(void)parseFormURLEncodedFromBodyData:(NSData* _Nonnull)bodyData withCompletion:(DictionaryParsingCompletion _Nullable)completion;
-(void)parseMultipartBodyData:(NSData* _Nonnull)data withCompletion:(DictionaryParsingCompletion _Nullable)completion;

@end

#endif /* URLFormParsersProtocols_h */
