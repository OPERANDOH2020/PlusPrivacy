//
//  UIInputGraphViewController.m
//  RSFrameworksHook
//
//  Created by Costin Andronache on 2/23/17.
//  Copyright © 2017 RomSoft. All rights reserved.
//

#import "UIInputGraphViewController.h"
#import "PerSecondReportAggregator.h"
#import "Common.h"

@interface UIGraphViewController ()

//@property (weak, nonatomic) IBOutlet BarChartView *barChartView;
@property (strong, nonatomic) PerSecondReportAggregator *reportAggregator;
@property (strong, nonatomic) NSArray<BaseReportWithDate*> *reportsArray;
@property (strong, nonatomic) void (^exitCallback)();


@end

@implementation UIGraphViewController


-(void)setupWithReports:(NSArray<BaseReportWithDate*>* _Nonnull)reports exitCallback:(void (^ __nullable)())exitCallback {
    
    self.reportsArray = reports;
    self.exitCallback = exitCallback;
    [self view];
    
//    BarChartData *data = [self createChartDataWithReports:reports inSecondGroupsOf:60];
//    self.barChartView.data = data;
//    self.barChartView.descriptionText = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reportAggregator = [[PerSecondReportAggregator alloc] init];
}

- (IBAction)didPressBackButton:(id)sender{
    SAFECALL(self.exitCallback)
}

- (IBAction)didChangeSegmentIndex:(UISegmentedControl*)sender {
    
    NSArray *seconds = @[@1, @60, @3600];
    
    NSInteger selectedSeconds = [seconds[sender.selectedSegmentIndex] integerValue];
    
//    BarChartData *data = [self createChartDataWithReports:self.reportsArray inSecondGroupsOf:selectedSeconds];
//    
//    self.barChartView.data = data;
}


//-(BarChartData*)createChartDataWithReports:(NSArray<BaseReportWithDate*> *)reports inSecondGroupsOf:(NSInteger)seconds {
//    
//    NSArray<NSArray<BaseReportWithDate*> *> *aggregatedReports = [self.reportAggregator aggregateReports:reports inSecondGroupsOfLength:seconds];
//    
//    
//    NSMutableArray<NSString*> *xVals = [[NSMutableArray alloc] init];
//    
//    NSMutableArray<BarChartDataEntry*> *dataEntries = [[NSMutableArray alloc] init];
//    
//    for (int i=0; i<aggregatedReports.count; i++) {
//        [xVals addObject:[NSString stringWithFormat:@"%d", i+1]];
//        
//        NSArray *arrAtI = aggregatedReports[i];
//        BarChartDataEntry *de = [[BarChartDataEntry alloc] initWithX:i y:arrAtI.count];
//        
//        [dataEntries addObject:de];
//    }
//    
//    NSString *message = [NSString stringWithFormat:@"Accesses in %ld seconds", (long)seconds];
//    BarChartDataSet *ds = [[BarChartDataSet alloc] initWithValues:dataEntries label:message];
//    BarChartData *chartData = [[BarChartData alloc] initWithDataSet:ds];
//    
//    
//    
//    return chartData;
//}


@end
