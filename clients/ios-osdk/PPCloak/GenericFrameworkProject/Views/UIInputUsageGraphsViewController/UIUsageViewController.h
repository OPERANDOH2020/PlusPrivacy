//
//  UIInputUsageGraphsViewController.h
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportsStorageProtocol.h"
#import <PPCommonTypes/PPCommonTypes.h>

@interface UIUsageViewControllerCallbacks : NSObject
@property (strong, nonatomic) void (^__nullable exitCallback)();
@property (strong, nonatomic) void (^ __nullable inputTypeSelectedCallback)(InputType* _Nonnull inputType);
@property (strong, nonatomic) void (^ __nullable networkReportsSelectedCallback)();
@end

@interface UIUsageViewControllerModel : NSObject
@property (assign, nonatomic) BOOL displayNetworkReportsOption;
@property (strong, nonatomic, nullable) NSArray<InputType*> *inputTypesOptions;
@end

@interface UIUsageViewController : UITableViewController

-(void)setupWithModel:(UIUsageViewControllerModel* __nullable)model andCallbacks:(UIUsageViewControllerCallbacks* __nullable)callbacks;

@end
