//
//  OverviewViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 17/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverviewViewController.h"
#import "Overview.h"
#import "NSString+TimeInterval.h"
#import "NSDate-Utilities.h"

NSString * const kformatterTemplate = @"EdMMMyyyy";

@interface OverviewViewController ()

@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic) NSDate *refDate;

@end

@implementation OverviewViewController


- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:kformatterTemplate options:0
                                                                  locale:[NSLocale currentLocale]];
        [_formatter setDateFormat:formatString];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = kJBColorLineChartBackground;
}

- (void)loadOverviewData {

    Overview *overviewData = [[Overview alloc] initWithStartDate:[self.refDate firstDayOfTheMonth] andFinishDate:[self.refDate lastDayOfTheMonth]];
    
    self.weekDayCountLabel.text = [NSString stringWithFormat:@"%02d", [self.refDate businessDaysInMonth]];
    self.weekEndDayCountLabel.text = [NSString stringWithFormat:@"%02d", [self.refDate weekendDaysInMonth]];
    self.timeBalanceLabel.text = [NSString stringWithTimeInterval:overviewData.timeBalance];
    
    self.sessionCountLabel.text = [NSString stringWithFormat:@"%02d", overviewData.sessionCount];
    self.absentCountLabel.text = [NSString stringWithFormat:@"%02d", overviewData.absentCount];
    self.holidayCountLabel.text = [NSString stringWithFormat:@"%02d", overviewData.holidayCount];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.refDate = [NSDate today];
    [self loadOverviewData];
    
    //[self.lineChartView setState:JBChartViewStateExpanded];
    //[self.lineChartView reloadData];
}


@end
