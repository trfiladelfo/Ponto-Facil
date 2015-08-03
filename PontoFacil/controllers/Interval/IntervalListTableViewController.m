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
#import "IntervalDetailTableViewController.h"
#import "LocalNotificationManager.h"

static NSString * const cellIdentifier = @"intervalCell";

@interface IntervalListTableViewController ()

@property (nonatomic, strong) ArrayDataSource *dataSource;
@property (nonatomic, strong) IntervalTableViewHeaderView *headerViewSummary;
@property (nonatomic, retain) LocalNotificationManager *notificationManager;

@end

@implementation IntervalListTableViewController

- (LocalNotificationManager *)notificationManager {
    if (!_notificationManager) {
        _notificationManager = [[LocalNotificationManager alloc] init];
    }
    
    return _notificationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    
    [super viewWillAppear:animated]; // clears selection
    
    if (selectedRowIndexPath) {
        [self.tableView reloadData];
    }
    
    [self refreshTimeSummary];
}

- (IBAction)cancelButtonClick:(id)sender {
    
    if (self.session) {
        [self.session.managedObjectContext rollback];
    }
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)saveButtonClick:(id)sender {
    
    if (self.session) {
        
        [self.session update];
        
        if ([self.session isStarted]) {
            if ([self.session haveTimeUntilEstimatedWorkFinish]) {
                [self.notificationManager scheduleNotificationsFromType:kLocalNotificationTypeWork withFireDate:[self.session currentEstWorkFinishDate]];
            }
        }
        else if ([self.session isPaused]) {
            if ([self.session haveTimeUntilEstimatedBreakFinish]) {
                [self.notificationManager scheduleNotificationsFromType:kLocalNotificationTypeBreak withFireDate:[self.session currentEstBreakFinishDate]];
            }
        }
        
        NSError *error;
        [self.session.managedObjectContext save:&error];
    }
    
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    //self.addButton.enabled = !editing;
}

#pragma mark - Private Functions

- (void)refreshTimeSummary {
    
    self.headerViewSummary.esrtimatedWorkTimeLabel.text = [NSString  stringWithTimeInterval:[_session.event.estWorkTime doubleValue] * -1];
    self.headerViewSummary.workTimeLabel.text = [NSString stringWithTimeInterval:[_session.workTime doubleValue]];
    self.headerViewSummary.timeOutLabel.text = [NSString stringWithTimeInterval:[_session.breakTimeInProgress doubleValue]];
    self.headerViewSummary.timeBalanceLabel.text = [NSString stringWithTimeInterval:_session.event.timeBalance];
}

#pragma mark - FetchResultsController Delegate

- (void)setupTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:@"IntervalTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    
    if (!_headerViewSummary) {
        _headerViewSummary = [[IntervalTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, 400, 65)];
        self.tableView.tableHeaderView = _headerViewSummary;
    }
    
    TableViewCellConfigureBlock configureCell = ^(IntervalTableViewCell *cell, Interval *interval) {
        [cell configureForInterval:interval];
    };
    
    if (self.session) {
    
        NSArray *intervalArray = self.session.descendingIntervalList;
        
        self.dataSource = [[ArrayDataSource alloc] initWithItems:intervalArray
                                                  cellIdentifier:cellIdentifier
                                              configureCellBlock:configureCell];
        
        self.tableView.dataSource = self.dataSource;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.session.descendingIntervalList) {
        [self performSegueWithIdentifier:@"intervalListToIntervalDetailSegue" sender:indexPath];
    }
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"intervalListToIntervalDetailSegue"])
    {
        IntervalDetailTableViewController *intervalDetailTableViewController = segue.destinationViewController;
        
        if ([sender isKindOfClass:([NSIndexPath class])]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            Interval *interval = [self.session.descendingIntervalList objectAtIndex:indexPath.row];
            intervalDetailTableViewController.interval = interval;
        }
    }
}
@end
