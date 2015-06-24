//
//  EventListTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventListTableViewController.h"
#import "FetchedResultsControllerDataSource.h"
#import "Event+Management.h"
#import "Session+Management.h"
#import "EventTableViewCell.h"
#import "EventDetailTableViewController.h"

static NSString * const cellIdentifier = @"eventCell";

@interface EventListTableViewController () <FetchedResultsControllerDataSourceDelegate, UITableViewDelegate>

@property (nonatomic, strong) FetchedResultsControllerDataSource *dataSource;

@end

@implementation EventListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupFetchedResultsController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //Perform Fetch and reload data
    self.dataSource.paused = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.dataSource.paused = YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
    
    [self.tableView setEditing:editing animated:animated];
    
    //self.addButton.enabled = !editing;
}

#pragma mark - FetchResultsController Delegate

- (void)setupFetchedResultsController
{
    self.dataSource = [[FetchedResultsControllerDataSource alloc] initWithTableView:self.tableView];
    
    self.dataSource.fetchedResultsController = [Event fetchedResultsController];
    self.dataSource.delegate = self;
    self.dataSource.reuseIdentifier = cellIdentifier;
    //self.dataSource.sortField = @"displayOrder";
}

- (void)configureCell:(id)theCell withObject:(id)object
{
    EventTableViewCell *cell = theCell;
    Event *event = object;
    [cell configureForEvent:event];
}

- (void)deleteObject:(id)object
{
    Event *event = object;
    
    NSString* actionName = [NSString stringWithFormat:@"Excluir evento do dia %@", event.estWorkStart];
    
    // Save Changes
    NSError *error = nil;
    [self.managedObjectContext deleteObject:object];
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error %@ with user info %@.", error, error.userInfo);
    }
    else {
        [self.undoManager setActionName:actionName];
        //[self showPopOverActionText:[NSString stringWithFormat:@"Clique aqui para desfazer a ação %@", actionName]];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return true;
}

#pragma mark Undo Manager

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager*)undoManager
{
    return [self managedObjectContext].undoManager;
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.dataSource.fetchedResultsController.managedObjectContext;
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

     if ([segue.identifier isEqualToString:@"eventDetailSegue"])
     {
         EventDetailTableViewController *eventDetailViewController = segue.destinationViewController;
         
         NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
     
         eventDetailViewController.session = [self.dataSource.fetchedResultsController objectAtIndexPath:indexPath];
     }
}

@end
