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
#import "IntervalTableViewCell.h"

static NSString * const cellIdentifier = @"intervalCell";

@interface IntervalListTableViewController ()

@property (nonatomic, strong) ArrayDataSource *dataSource;

@end

@implementation IntervalListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    //self.addButton.enabled = !editing;
}

#pragma mark - FetchResultsController Delegate

- (void)setupTableView
{
    TableViewCellConfigureBlock configureCell = ^(IntervalTableViewCell *cell, Interval *interval) {
        [cell configureForInterval:interval];
    };
    
    if (self.session) {
    
        NSArray *intervalArray = [self.session dateSortedIntervalList];
        
        self.dataSource = [[ArrayDataSource alloc] initWithItems:intervalArray
                                                  cellIdentifier:cellIdentifier
                                              configureCellBlock:configureCell];
        
        self.tableView.dataSource = self.dataSource;
    }
}
@end
