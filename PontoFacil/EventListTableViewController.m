//
//  EventListTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventListTableViewController.h"
#import "Event+Management.h"
#import "Session+Management.h"
#import "EventTableViewCell.h"

@interface EventListTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation EventListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    return [sectionInfo name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSInteger count = [sectionInfo numberOfObjects];
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"eventCell";
    EventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (event.eventCategoryType == kEventTypeSession) {
        if ([event isMemberOfClass:[Session class]]) {
            Session *session = (Session *)event;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            
            if (!session.finishDate) {
                eventCell.eventTimeLabel.text = [dateFormatter stringFromDate:session.startDate];
            }
            else {
                eventCell.eventTimeLabel.text = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:session.startDate], [dateFormatter stringFromDate:session.finishDate]];
            }
            
            NSString *balanceSignal;
            
            if ([session.estWorkTime doubleValue] > [session.workTime doubleValue]) {
                balanceSignal = @"-";
            }
            else {
                balanceSignal = @"+";
            }
            
            eventCell.eventBalanceLabel.text = [NSString stringWithFormat:@"%@ %@",balanceSignal, [self stringFromTimeInterval:ABS(session.timeBalance)]];
            
            eventCell.eventTypeText = @"Sessão Normal";
        }
    }
    else {
        eventCell.eventTimeLabel.text = @"Dia Inteiro";
        
        if (event.eventCategoryType == kEventTypeHoliday) {
            eventCell.eventTypeText = @"Dispensa";
        }
        else if (event.eventCategoryType == kEventTypeAbsence) {
            eventCell.eventTypeText = @"Falta";
        }
    }
    
    return eventCell;
}


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    _fetchedResultsController = [Event fetchedResultsController];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
