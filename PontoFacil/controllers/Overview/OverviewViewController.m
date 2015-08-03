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
#import "Event+Management.h"

#import "JBChartView.h"
#import "JBBarChartView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"

NSString * const kformatterTemplate = @"MMM yyyy";
NSInteger const kJBBarChartViewControllerNumBars = 12;
CGFloat const kJBBarChartViewControllerBarPadding = 1.0f;
CGFloat const kJBBarChartViewControllerChartFooterPadding = 5.0f;
NSInteger const kJBBarChartViewControllerMaxBarHeight = 10;
NSInteger const kJBBarChartViewControllerMinBarHeight = 5;
CGFloat const kJBBarChartViewControllerChartFooterHeight = 25.0f;


@interface OverviewViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic) NSDate *refDate;
@property (nonatomic) NSFetchedResultsController *overviewDataSource;

@property (nonatomic, retain) JBBarChartView *barChartView;
@property (nonatomic) UILabel *footerViewLeftLabel;
@property (nonatomic) UILabel *footerViewRightLabel;

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

- (JBBarChartView *)barChartView {

    if (!_barChartView) {
        [self.graphContainerView layoutSubviews];
        _barChartView = [[JBBarChartView alloc] initWithFrame:self.graphContainerView.bounds];
        _barChartView.dataSource = self;
        _barChartView.delegate = self;
        _barChartView.minimumValue = 0.0f;
        _barChartView.inverted = NO;
        
        JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(0,0, self.graphContainerView.frame.size.width, kJBBarChartViewControllerChartFooterHeight)];
        footerView.padding = kJBBarChartViewControllerChartFooterPadding;
        
        self.footerViewLeftLabel = footerView.leftLabel;
        self.footerViewRightLabel = footerView.rightLabel;
        
        footerView.leftLabel.textColor = [UIColor whiteColor];
        footerView.rightLabel.textColor = [UIColor whiteColor];
        
        _barChartView.footerView = footerView;
        
        [self setFooterViewMonthLabels];
        
        [self.graphContainerView addSubview:self.barChartView];
    }
    
    return _barChartView;
}

- (NSFetchedResultsController *)overviewDataSource {

    if (!_overviewDataSource) {
        _overviewDataSource = [Event sortedFetchedResultsController:true];
    }
    
    return _overviewDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor = kJBColorLineChartBackground;
}

- (void)dealloc {
    _barChartView.delegate = nil;
    _barChartView.dataSource = nil;
}

- (void)loadOverviewData:(Overview *)overviewData {
    
    [self setFooterViewMonthLabels];
    
    self.refDateLabel.text = overviewData.title;
    self.weekDayCountLabel.text = [NSString stringWithFormat:@"%02d", [self.refDate businessDaysInMonth]];
    self.weekEndDayCountLabel.text = [NSString stringWithFormat:@"%02d", [self.refDate weekendDaysInMonth]];
    
    self.timeBalanceLabel.text = [NSString stringWithTimeInterval:overviewData.timeBalance];
    self.sessionCountLabel.text = [NSString stringWithFormat:@"%02d", overviewData.sessionCount];
    self.absentCountLabel.text = [NSString stringWithFormat:@"%02d", overviewData.absentCount];
    self.holidayCountLabel.text = [NSString stringWithFormat:@"%02d", overviewData.holidayCount];

}

- (void)setFooterViewMonthLabels {
    
    if ([[self.overviewDataSource fetchedObjects] count] > 0) {
        NSArray *shortMonthSymbols = [self.formatter shortMonthSymbols];
        
        Event *firstEvent = [[self.overviewDataSource fetchedObjects] firstObject];
        self.footerViewLeftLabel.text = [[shortMonthSymbols objectAtIndex:[firstEvent.estWorkStart month]-1] uppercaseString];
        
        Event *lastEvent = [[self.overviewDataSource fetchedObjects] lastObject];
        self.footerViewRightLabel.text = [[shortMonthSymbols objectAtIndex:[lastEvent.estWorkStart month]-1] uppercaseString];
    }

}

/*
- (void)initFakeData
{
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<kJBBarChartViewControllerNumBars; i++)
    {
        NSInteger delta = (kJBBarChartViewControllerNumBars - labs((kJBBarChartViewControllerNumBars - i) - i)) + 2;
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX((delta * kJBBarChartViewControllerMinBarHeight), arc4random() % (delta * kJBBarChartViewControllerMaxBarHeight))]];
        
    }
    _chartData = [NSArray arrayWithArray:mutableChartData];
    
}*/

#pragma mark - JBBarChartViewDataSource

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return [self.overviewDataSource.sections count];
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.overviewDataSource.sections[index];
    
    if ([sectionInfo numberOfObjects] > 0) {
        Overview *overview = [[Overview alloc] initWithTitle:[sectionInfo name] andEventArray:[sectionInfo objects]];
        
        [self setTooltipVisible:YES animated:YES atTouchPoint:touchPoint];
        [self.tooltipView setText:[NSString stringWithTimeInterval:overview.workTime]];
        
        [self loadOverviewData:overview];
    }
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    [self setTooltipVisible:NO animated:YES];
}


#pragma mark - JBBarChartViewDelegate

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.overviewDataSource.sections[index] ;

    if ([sectionInfo numberOfObjects] > 0) {
        Overview *overview = [[Overview alloc] initWithTitle:[sectionInfo name] andEventArray:[sectionInfo objects]];
        
        NSInteger ti = (NSInteger)ABS(overview.workTime);
        NSInteger hours = (ti / 3600);
        
        return hours;
    }
    else
        return 0;
    
}

- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return (index % 2 == 0) ? kJBColorBarChartBarBlue : kJBColorBarChartBarGreen;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}

- (CGFloat)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return kJBBarChartViewControllerBarPadding;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.overviewDataSource performFetch:nil];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = self.overviewDataSource.sections.lastObject;
    
    if ([sectionInfo numberOfObjects] > 0) {
        Overview *lastMonthOverview = [[Overview alloc] initWithTitle:[sectionInfo name] andEventArray:[sectionInfo objects]];
        
        [self loadOverviewData:lastMonthOverview];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    //Fix autolayout chart subview frame size,
    self.barChartView.frame = self.graphContainerView.bounds;
    [self.barChartView reloadData];
}



@end
