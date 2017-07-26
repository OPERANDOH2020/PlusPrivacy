//
//  BaseHTTPAnalyzer.h
//  PPCloak
//
//  Created by Costin Andronache on 7/25/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPBasicHttpBodyParser.h"

@interface BaseHTTPAnalyzer : NSObject
@property (readonly, nonatomic, nonnull) id<HTTPBodyParser> httpBodyParser;

-(instancetype _Nonnull)initWithHttpBodyParser:(id<HTTPBodyParser> _Nonnull)parser;

-(void)dictionaryFromRequestBody:(NSURLRequest* _Nonnull)request withCompletion:(DictionaryParsingCompletion _Nullable)completion;


-(BOOL)searchRecursivelyInDictValues:(NSArray* _Nullable)dictValues processingNumbersArray:(BOOL(^ _Nonnull)(NSArray<NSNumber*>* _Nonnull))numbersArrayProcessor processingStringsArray:(BOOL(^ _Nonnull)(NSArray<NSString*>* _Nonnull))stringsArrayProcessor;




-(NSArray<NSString*>* _Nullable)naiveSearchTextValues:(NSArray<NSString*> * _Nonnull)textValues inRequestURL:(NSURL* _Nonnull)url;
-(NSArray<NSString*> *_Nullable)naiveSearchTextValues:(NSArray<NSString*>* _Nonnull)textValues inRequestBody:(NSURLRequest* _Nonnull)request completion:(void(^ _Nullable)(BOOL found))completion;


-(NSArray<NSNumber*> *_Nullable)naiveSearchNumericValues:(NSArray<NSNumber*>* _Nonnull)numericValues inRequestURL:(NSURL* _Nonnull)url;

-(NSArray<NSNumber*> *_Nullable)naiveSearchNumericValues:(NSArray<NSNumber *> *)numericValues inRequestBody:(NSURLRequest* _Nonnull)request;

@end
