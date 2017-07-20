//
//  PlistReportsStorage.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/6/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "PlistReportsStorage.h"
#import "Common.h"
#import "PPAccessUnlistedHostReport+NSDictionaryRepresentation.h"
#import "PPPrivacyLevelViolationReport+NSDictionaryRepresentation.h"
#import "PPUnlistedInputAccessViolation+NSDictionaryRepresentation.h"
#import "PPAccessFrequencyViolationReport+NSDictionaryRepresentation.h"
#import "PPModuleDeniedAccessReport+NSDictionaryRepresentation.h"



@interface PlistReportsStorage()

@property (strong, nonatomic) NSMutableArray<PPAccessFrequencyViolationReport*> *frequencyReportsArray;
@property (strong, nonatomic) NSMutableArray<PPAccessUnlistedHostReport*> *hostReportsArray;
@property (strong, nonatomic) NSMutableArray<PPUsageLevelViolationReport*> *privacyLevelReportsArray;
@property (strong, nonatomic) NSMutableArray<PPUnlistedInputAccessViolation*> *inputReportsArray;
@property (strong, nonatomic) NSMutableArray<PPModuleDeniedAccessReport*> *moduleDeniedAccessReportsArray;

@end

@implementation PlistReportsStorage

static NSString *kPlistReportStorageDomain = @"com.plistReportStorage";
static NSString *kIndexOutOfRangeDescription = @"Index is out of range";
static NSString *kObjectNotInRepository = @"Object is not in repository";

static NSString *kFrequencyRepository = @"kFrequencyRepository";
static NSString *kHostRepository = @"kHostRepository";
static NSString *kPrivacyLevelRepository = @"kPrivacyLevelRepository";
static NSString *kInputRepository = @"kInputRepository";
static NSString *kModuleDeniedAccessRepository = @"kModuleDeniedAccessRepository";

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self populateArrays];
    }
    return self;
}


#pragma mark - AccessFrequency Repository

-(void)addAccessFrequencyReport:(PPAccessFrequencyViolationReport *)report withCompletion:(PossibleErrorCallback)completion {
    
    [self.frequencyReportsArray addObject:report];
    [PlistReportsStorage synchronizeArray:self.frequencyReportsArray toPlistNamed:kFrequencyRepository];
    SAFECALL(completion, nil)
}

-(void)getFrequencyReportsIn:(AccessFrequencyReportsCallback)callback {
    SAFECALL(callback, self.frequencyReportsArray, nil)
}

#pragma mark - HostReports Repository

-(void)addUnlistedHostReport:(PPAccessUnlistedHostReport *)report withCompletion:(PossibleErrorCallback)completion {
    [self.hostReportsArray addObject:report];
    [PlistReportsStorage synchronizeArray:self.hostReportsArray toPlistNamed:kHostRepository];
    SAFECALL(completion, nil)
}

-(void)getUnlistedHostReportsIn:(UnlistedHostReportsCallback)callback {
    SAFECALL(callback, self.hostReportsArray, nil)
}


#pragma mark - PrivacyLevel Repository

-(void)addPrivacyLevelReport:(PPUsageLevelViolationReport *)report withCompletion:(PossibleErrorCallback)completion{
    
    [self.privacyLevelReportsArray addObject:report];
    [PlistReportsStorage synchronizeArray:self.privacyLevelReportsArray toPlistNamed:kPrivacyLevelRepository];
    
    SAFECALL(completion, nil)
}

-(void)getPrivacyLevelReportsIn:(PrivacyLevelReportsCallback)callback {
    SAFECALL(callback, self.privacyLevelReportsArray, nil)
}

#pragma mark - UnlistedInput Repository 

-(void)addUnlistedInputReport:(PPUnlistedInputAccessViolation *)report withCompletion:(PossibleErrorCallback)completion {
    [self.inputReportsArray addObject:report];
    [PlistReportsStorage synchronizeArray:self.inputReportsArray toPlistNamed:kInputRepository];
    SAFECALL(completion, nil)
}

-(void)getUnlistedInputReportsIn:(UnlistedInputReportsCallback)callback{
    SAFECALL(callback, self.inputReportsArray, nil)
}

-(void)getCurrentInputTypesInViolationReportsIn:(InputTypesCallback)callback{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (PPUnlistedInputAccessViolation *report in self.inputReportsArray) {
        if (![result containsObject:report.inputType]) {
            [result addObject:report.inputType];
        }
    }
    
    SAFECALL(callback, result, nil)
}

-(void)getViolationReportsOfInputType:(InputType *)inputType in:(UnlistedInputReportsCallback)callback {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (PPUnlistedInputAccessViolation *report in self.inputReportsArray) {
        if ([report.inputType isEqual:inputType]) {
            [result addObject:report];
        }
    }
    
    SAFECALL(callback, result, nil)
}

#pragma mark - ModuleDeniedAccess repository

-(void)addModuleDeniedAccessReport:(PPModuleDeniedAccessReport *)report withCompletion:(PossibleErrorCallback)completion {
    
    [self.moduleDeniedAccessReportsArray addObject:report];
    [PlistReportsStorage synchronizeArray:self.moduleDeniedAccessReportsArray toPlistNamed:kModuleDeniedAccessRepository];
    
    SAFECALL(completion, nil)
}

-(void)getModuleDeniedAccessReportsIn:(ModuleDeniedAccessReportsCallback)callback{
    SAFECALL(callback, self.moduleDeniedAccessReportsArray, nil)
}

#pragma mark - private methods

-(void)populateArrays {
    NSArray<NSDictionary*> *frequencyDicts = [[NSArray alloc] initWithContentsOfFile:[PlistReportsStorage plistPathForRepositoryName:kFrequencyRepository]];
    
    NSArray<NSDictionary*> *hostDicts = [[NSArray alloc] initWithContentsOfFile:[PlistReportsStorage plistPathForRepositoryName:kHostRepository]];
    
    NSArray<NSDictionary*> *privacyLevelDicts = [[NSArray alloc] initWithContentsOfFile:[PlistReportsStorage plistPathForRepositoryName:kPrivacyLevelRepository]];
    
    NSArray<NSDictionary*> *inputAccessDicts = [[NSArray alloc] initWithContentsOfFile:[PlistReportsStorage plistPathForRepositoryName:kInputRepository]];
    
    NSArray<NSDictionary*> *moduleDeniedAccessDicts = [[NSArray alloc] initWithContentsOfFile:[PlistReportsStorage plistPathForRepositoryName:kModuleDeniedAccessRepository]];
    
    
    //----//----//
    
    self.frequencyReportsArray = [PlistReportsStorage buildObjectsOfClass:[PPAccessFrequencyViolationReport class] fromDictionaries:frequencyDicts];
    
    self.hostReportsArray = [PlistReportsStorage buildObjectsOfClass:[PPAccessUnlistedHostReport class] fromDictionaries:hostDicts];
    
    self.privacyLevelReportsArray = [PlistReportsStorage buildObjectsOfClass:[PPUsageLevelViolationReport class] fromDictionaries:privacyLevelDicts];
    
    self.inputReportsArray = [PlistReportsStorage buildObjectsOfClass:[PPUnlistedInputAccessViolation class] fromDictionaries:inputAccessDicts];
    
    self.moduleDeniedAccessReportsArray = [PlistReportsStorage buildObjectsOfClass:[PPModuleDeniedAccessReport class] fromDictionaries:moduleDeniedAccessDicts];
}

+(void)synchronizeArray:(NSArray<id<DictionaryRepresentable>>*)array toPlistNamed:(NSString*)plistName {
    NSArray *dicts = [PlistReportsStorage createDictionaryRepresentationsOfObjects:array];
    [dicts writeToFile:[PlistReportsStorage plistPathForRepositoryName:plistName] atomically:YES];
}


+(NSString*)plistPathForRepositoryName:(NSString*)repositoryName {
    if (repositoryName == nil) {
        return @"";
    }
    NSString *pathComponent = [NSString stringWithFormat:@"%@.plist", repositoryName];
    
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    if (paths.firstObject) {
        return [paths.firstObject stringByAppendingPathComponent:pathComponent];
    }
    
    
    return @"";
}

+(NSMutableArray*)buildObjectsOfClass:(Class)class fromDictionaries:(NSArray<NSDictionary*>*)dictionaries {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in dictionaries) {
        id object = [[class alloc] initWithNSDictionary:dict];
        if (object) {
            [result addObject:object];
        }
    }
    
    return result;
}

+(NSArray<NSDictionary*>*)createDictionaryRepresentationsOfObjects:(NSArray<id<DictionaryRepresentable>>*)objects{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (id<DictionaryRepresentable> repr in objects) {
        NSDictionary *dict = [repr dictionaryRepresentation];
        if (dict) {
            [result addObject:dict];
        }
    }
    
    return result;
    
}

@end

