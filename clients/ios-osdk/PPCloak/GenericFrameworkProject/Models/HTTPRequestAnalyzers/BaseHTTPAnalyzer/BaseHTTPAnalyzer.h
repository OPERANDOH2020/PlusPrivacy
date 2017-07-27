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
-(void)naiveSearchTextValues:(NSArray<NSString*>* _Nonnull)textValues inRequestBody:(NSURLRequest* _Nonnull)request completion:(void(^ _Nullable)(NSArray<NSString*> *_Nullable foundValues))completion;


-(NSArray<NSNumber*> *_Nullable)naiveSearchNumericValues:(NSArray<NSNumber*>* _Nonnull)numericValues compareUpToFractionDigit:(NSInteger)frDigit inRequestURL:(NSURL* _Nonnull)url;

-(void)naiveSearchNumericValues:(NSArray<NSNumber *> * _Nonnull)numericValues compareUpToFractionDigit:(NSInteger)frDigit inRequestBody:(NSURLRequest* _Nonnull)request completin:(void(^ _Nullable)(NSArray<NSNumber*>* _Nullable foundValues))completion ;

@end
