//
//  IntervalListTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "IntervalListTableViewController.h"
#import "ArrayDataSource.h"
#import "Session+Management.h"
#import "Event+Management.h"
#import "IntervalTableViewCell.h"
#import "NSString+TimeInterval.h"
#import "IntervalTableViewHeaderView.h"

static NSString * const cellIdentifier = @"intervalCell";

@interface IntervalListTableViewController ()

@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) IntervalTableViewHeaderView *headerViewSummary;

@end

@implementation IntervalListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {

    [self refreshTimeSummary];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    //self.addButton.enabled = !editing;
}

#pragma mark - Private Functions

- (void)refreshTimeSummary {
    
    self.headerViewSummary.workTimeLabel.text = [NSString stringWithTimeInterval:[_session.workTime doubleValue]];
    self.headerViewSummary.breakTimeLabel.text = [NSString stringWithTimeInterval:[_session.breakTimeInProgress doubleValue]];
    self.headerViewSummary.timeBalanceLabel.text = [NSString stringWithTimeInterval:_session.timeBalance];
}

#pragma mark - FetchResultsController Delegate

- (void)setupTableView
{
    
    if (!_headerViewSummary) {
        _headerViewSummary = [[IntervalTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, 400, 65)];
        self.tableView.tableHeaderView = _headerViewSummary;
    }
    
    TableViewCellConfigureBlock configureCell = ^(IntervalTableViewCell *cell, Interval *interval) {
        [cell configureForInterval:interval];
    };
    
    if (self.session) {
    
        NSArray *intervalArray = self.session.orderedIntervalList;
        
        self.dataSource = [[ArrayDataSource alloc] initWithItems:intervalArray
                                                  cellIdentifier:cellIdentifier
                                              configureCellBlock:configureCell];
        
        self.tableView.dataSource = self.dataSource;
    }
}
@end
