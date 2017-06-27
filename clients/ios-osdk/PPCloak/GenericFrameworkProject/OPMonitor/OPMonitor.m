//
//  OPMonitor.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 1/18/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "OPMonitor.h"
#import "LocationInputSupervisor.h"
#import "NSURLSessionSupervisor.h"
#import "ProximityInputSupervisor.h"
#import "PedometerInputSupervisor.h"
#import "ContactsInputSupervisor.h"
#import "MicrophoneInputSupervisor.h"
#import "CameraInputSupervisor.h"
#import "TouchIdSupervisor.h"
#import "MagnetometerInputSupervisor.h"
#import "AccelerometerInputSupervisor.h"
#import "BarometerInputSupervisor.h"
#import "PlistReportsStorage.h"
#import "JRSwizzle.h"
#import "LocationInputSwizzler.h"
#import "CommonViewUtils.h"
#import "PPFlowBuilder.h"
#import "Security.h"

#import <PPCommonUI/PPCommonUI-Swift.h>




@interface NSArray(FindObjectOfClass)
-(id _Nullable)firstObjectOfClass:(Class)class;
@end

@implementation NSArray(FindObjectOfClass)

-(id)firstObjectOfClass:(Class)class{
    for (id obj in self) {
        if ([obj isKindOfClass:class]) {
            return obj;
        }
    }
    return nil;
}

@end

@interface OPMonitor() <InputSupervisorDelegate>

@property (strong, nonatomic) OPMonitorSettings *monitorSettings;
@property (strong, nonatomic) NSDictionary *scdJson;
@property (strong, nonatomic) SCDDocument *document;
@property (strong, nonatomic) UIButton *handle;
@property (strong, nonatomic) PlistReportsStorage *plistRepository;
@property (strong, nonatomic) NSArray<id<InputSourceSupervisor>> *supervisorsArray;


@property (strong, nonatomic) LocationInputSwizzler *locationInputSwizzler;

@end

@implementation OPMonitor

+(void)initializeMonitoring {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppSCD" ofType:@"json"];
    NSString *fileText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [fileText dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if (json) {
        [[OPMonitor sharedInstance] beginMonitoringWithAppDocument:json];
    } else {
        NSString *message = [NSString stringWithFormat:@"Could not find json document at path %@ or the text is not a valid JSON object: %@", fileText, path];
        [CommonViewUtils showOkAlertWithMessage:message completion:nil];
    }
    
}

+(instancetype)sharedInstance{
    static OPMonitor *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[OPMonitor alloc] init];
    });
    
    return  shared;
}

+(void)load{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        checkNoSwizzlingForOPMonitor();
        checkNoSwizzlingForApiHooks();
        checkForOtherFrameworks();
    });
    
    [self initializeMonitoring];
}


-(void)beginMonitoringWithAppDocument:(NSDictionary *)document {
    
    [[CommonTypeBuilder sharedInstance] buildSCDDocumentWith:document in: ^void(SCDDocument * _Nullable scdDocument, NSError * _Nullable error) {
        
        if (error || !scdDocument) {
            NSString *errorMessage = [error description];
            [CommonViewUtils showOkAlertWithMessage:errorMessage completion:nil];
            [self displayNotificationIfPossible:errorMessage];
            return;
            
        }
        
        self.monitorSettings = [[OPMonitorSettings alloc] initFromDefaults];
        self.scdJson = document;
        self.plistRepository = [[PlistReportsStorage alloc] init];
        self.document = scdDocument;
        self.supervisorsArray = [self buildSupervisorsWithDocument:scdDocument];
        
        LocationInputSupervisor *locSupervisor = [self.supervisorsArray firstObjectOfClass:[LocationInputSupervisor class]];
        [self setupLocationInputSwizzlerUsingSupervisor:locSupervisor];
        
    }];
    

}


-(UIButton *)getHandle {
    if (self.handle == nil) {
        self.handle = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 44, 44)];
        [self.handle setTitle:@"PP" forState:UIControlStateNormal];
        self.handle.backgroundColor = [UIColor redColor];
        [self.handle addTarget:self action:@selector(didPressHandle:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return  self.handle;
}

-(void)didPressHandle:(id)sender {
    [self displayFlowIfNecessary];
}

-(void)displayFlowIfNecessary {
    
    static BOOL isFlowDisplayed = NO;
    
    if (isFlowDisplayed) {
        return;
    }
    OneDocumentRepository *repo = [[OneDocumentRepository alloc] initWithDocument:self.document];
    
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    __block UIViewController *flowRoot = nil;
    __weak typeof(self) weakSelf = self;
    

    
    PPReportsSourcesBundle *reportSources = [[PPReportsSourcesBundle alloc] init];
    reportSources.accessFrequencyReportsSource = self.plistRepository;
    reportSources.privacyViolationReportsSource = self.plistRepository;
    reportSources.unlistedHostReportsSource = self.plistRepository;
    reportSources.unlistedInputReportsSource = self.plistRepository;
    
    PPFlowBuilderModel *flowModel = [[PPFlowBuilderModel alloc] init];
    flowModel.monitoringSettings = self.monitorSettings;
    flowModel.reportSources = reportSources;
    flowModel.scdRepository = repo;
    flowModel.scdJSON = self.scdJson;
    
    PPFlowBuilderLocationModel *locationRelated = [[PPFlowBuilderLocationModel alloc] init];
    
    locationRelated.getCurrentActiveLocationIndex = ^NSInteger{
        return weakSelf.locationInputSwizzler.indexOfCurrentSentLocation;
    };
    
    locationRelated.registerChangeCallback = ^(CurrentActiveLocationIndexChangedCallback  _Nullable callback) {
        [weakSelf.locationInputSwizzler registerNewChangeCallback:callback];
    };
    
    locationRelated.removeChangeCallback = ^(CurrentActiveLocationIndexChangedCallback  _Nullable callback) {
        [weakSelf.locationInputSwizzler removeChangeCallback:callback];
    };
    
    locationRelated.getCurrentRandomWalkSettingsCallback = ^RandomWalkLocationSettingsModel * _Nonnull{
        RandomWalkLocationSettingsModel *model = [[RandomWalkLocationSettingsModel alloc] init];
        model.currentSettings = weakSelf.locationInputSwizzler.currentSettings;
        model.randomWalkGenerator = [[RandomWalkGenerator alloc] init];
        return model;
    };
    
    locationRelated.onSaveCurrentRandomWalkSettings = ^(RandomWalkSwizzlerSettings *settings) {
        [weakSelf.locationInputSwizzler applyNewRandomWalkSettings:settings];
        [settings synchronizeToDefaults:[NSUserDefaults standardUserDefaults]];
        [CommonViewUtils showOkAlertWithMessage:@"Done" completion:nil];
    };
    
    flowModel.eveythingLocationRelated = locationRelated;
    
    flowModel.onExitCallback = ^{
        [rootViewController ppRemoveChildContentController:flowRoot];
        isFlowDisplayed = NO;
    };
    
    PPFlowBuilder *flowBuilder = [[PPFlowBuilder alloc] init];
    flowRoot = [flowBuilder buildFlowWithModel:flowModel];
    
    isFlowDisplayed = YES;
    [rootViewController ppAddChildContentController:flowRoot];
}

#pragma mark - Reports from input supervisors

-(void)newURLHostViolationReported:(PPAccessUnlistedHostReport *)report {
    return;
    
    [self.plistRepository addUnlistedHostReport:report withCompletion:nil];
    NSString *notification = [NSString stringWithFormat:@"Accessed unlisted host %@", report.urlHost];
    [self displayNotificationIfPossible:notification];
}

-(void)newUnlistedInputAccessViolationReported:(PPUnlistedInputAccessViolation *)report {
    [self.plistRepository addUnlistedInputReport:report withCompletion:nil];
    NSString *notification = [NSString stringWithFormat:@"Accessed unlisted input %@", InputType.namesPerInputType[report.inputType]];
    [self displayNotificationIfPossible:notification];

}


-(void)newPrivacyLevelViolationReported:(PPPrivacyLevelViolationReport *)report {
    // must complete later
}

-(void)newAccessFrequencyViolationReported:(PPAccessFrequencyViolationReport *)report{
    // must complete later
}


#pragma mark -

-(void)displayNotificationIfPossible:(NSString*)notification {
    if (!self.monitorSettings.allowNotifications) {
        return;
    }
    
    __weak UIViewController *rootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UINotificationViewController presentBadNotificationMessage:notification inController:rootViewController atDistanceFromTop:20];
    });
}

-(NSArray<id<InputSourceSupervisor>>*)buildSupervisorsWithDocument:(SCDDocument*)document {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    InputSupervisorModel *supervisorsModel = [[InputSupervisorModel alloc] init];
    supervisorsModel.scdDocument = document;
    supervisorsModel.delegate = self;
    supervisorsModel.privacyLevelAbuseDetector = [[PrivacyLevelAbuseDetector alloc] initWithDocument:document];
    supervisorsModel.httpAnalyzers = [[HTTPAnalyzers alloc] init];
    supervisorsModel.httpAnalyzers.locationHTTPAnalyzer = [[LocationHTTPAnalyzer alloc] init];
    supervisorsModel.eventsDispatcher = [PPEventDispatcher sharedInstance];
    
    
    NSArray *supervisorClasses = @[[LocationInputSupervisor class],
                                   [ProximityInputSupervisor class],
                                   [PedometerInputSupervisor class],
                                   [MagnetometerInputSupervisor class],
                                   [AccelerometerInputSupervisor class],
                                   [BarometerInputSupervisor class],
                                   [TouchIdSupervisor class],
                                   [CameraInputSupervisor class],
                                   [MicrophoneInputSupervisor class],
                                   [ContactsInputSupervisor class],
                                   [NSURLSessionSupervisor class]
                                   ];
    
    for (Class class in supervisorClasses) {
        id supervisor = [[class alloc] init];
        [supervisor setupWithModel:supervisorsModel];
        [result addObject:supervisor];
    }
    
    
    return  result;
}

-(void)setupLocationInputSwizzlerUsingSupervisor:(LocationInputSupervisor*)supervisor {
    NSError *error = nil;
    RandomWalkSwizzlerSettings *defaultLocationSettings = [RandomWalkSwizzlerSettings createFromDefaults: [NSUserDefaults standardUserDefaults] error:&error];
    
    if (error) {
        RandomWalkBoundCircle *circle = [[RandomWalkBoundCircle alloc] initWithCenter:CLLocationCoordinate2DMake(90, 90) radiusInKm:1];
        defaultLocationSettings = [RandomWalkSwizzlerSettings createWithCircle:circle walkPath:@[] enabled:NO error:nil];
    }
    
    self.locationInputSwizzler = [[LocationInputSwizzler alloc] init];
    [self.locationInputSwizzler applyNewRandomWalkSettings:defaultLocationSettings];
    
    
    [self.locationInputSwizzler setupWithSettings:defaultLocationSettings eventsDispatcher:[PPEventDispatcher sharedInstance] whenLocationsAreRequested:^(NSArray<CLLocation *> * _Nonnull locations) {
        
    }];
}

@end
