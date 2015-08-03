//
//  EventDetailTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import "Event+Management.h"
#import "Session+Management.h"
#import "ScheduleTableViewController.h"
#import "NSString+TimeInterval.h"
#import "IntervalDetailTableViewController.h"
#import "IntervalTableViewCell.h"
#import "NSUserDefaults+PontoFacil.h"
#import "NSDate-Utilities.h"

static NSInteger kTableViewSectionCount = 5;
static NSInteger kDynamicSectionIndex = 4;
static CGFloat kDynamicSectionHeight = 50.0;
static NSString *intervalCellIdentifier = @"intervalCell";

typedef NS_ENUM(NSInteger, EventTypeControllerCategory) {
    kEventTypeCategorySession = 0,
    kEventTypeCategoryAbsence = 1
};

@interface EventDetailTableViewController ()

@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, assign) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSArray *intervalArray;
@property (nonatomic) EventTypeControllerCategory eventCategory;

@end

@implementation EventDetailTableViewController

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateStyle:NSDateFormatterLongStyle];
        [_formatter setTimeStyle:NSDateFormatterNoStyle];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (Event *)event {

    if (!_event) {
        _event = [[Event alloc] initEventWithDate:[NSDate today]];
    }
    
    return _event;
}

- (NSArray *)intervalArray {

    if (!_intervalArray) {
        if (self.event.session) {
            _intervalArray = self.event.session.ascendingIntervalList;
        }
        else {
            _intervalArray = [Interval defaultIntervalListArray];
        }
    }
    
    return _intervalArray;
}

- (EventTypeControllerCategory)eventCategory {
    if (!_eventCategory) {
        _eventCategory = kEventTypeCategorySession;
    }
    
    return _eventCategory;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"IntervalTableViewCell" bundle:nil] forCellReuseIdentifier:intervalCellIdentifier];
    
    //Habilita o botão de cancelar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
}

- (void)viewWillAppear:(BOOL)animated {

    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    
    [super viewWillAppear:animated]; // clears selection
    
    if (selectedRowIndexPath) {
        [self.tableView reloadData];
    }
    
    [self showEventData];
}

#pragma mark - Private Functions

- (void)showEventData {
    if (self.event) {
        
        if ([self.event.eventType intValue] == 0) {
            if ([self.event.isAbsence boolValue]) {
                self.eventCategory = kEventTypeCategoryAbsence;
            }
            else
                self.eventCategory = kEventTypeCategorySession;
        }
        //else
        //    self.eventCategory = kEventTypeCategoryHoliday;
        
        
        [self.eventTypeSegmentedControl setSelectedSegmentIndex:self.eventCategory];
        self.eventDateLabel.text = [self.formatter stringFromDate:self.event.estWorkStart];
        [self.eventDatePicker setDate:self.event.estWorkStart];
        self.eventEstWorkTime.text = [NSString stringWithTimeInterval:[self.event.estWorkTime doubleValue]];
        self.eventDescriptionTextField.text = self.event.eventDescription;
    }
}

#pragma mark - User Interface

- (IBAction)eventTypeSegmentedControlerChanged:(id)sender {

    self.eventCategory = [self.eventTypeSegmentedControl selectedSegmentIndex];
    
    [self.tableView reloadData];
}

- (IBAction)eventDatePickerChanged:(id)sender
{
    NSString *pickerDate = [self.formatter stringFromDate:[self.eventDatePicker date]];
    self.eventDateLabel.text = pickerDate;
    
}

- (IBAction)cancelButtonPressed:(id)sender
{
    if (self.event) {
        [self.event.managedObjectContext rollback];
    }

    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:TRUE completion:nil];
    }
}

- (IBAction)saveButtonPressed:(id)sender
{
    if (self.event) {
        
        //Alteração
        [self.event updateEventDate:self.eventDatePicker.date];
        
        if (self.eventCategory == kEventTypeCategorySession) {
            if (!self.event.session) {
                self.event.session = [[Session alloc] initWithEvent:self.event];
            }
            
            if (self.intervalArray) {
                [self.event.session setIntervalList:[NSSet setWithArray:self.intervalArray]];
                
                NSDate *minStartDate = [self.event.session.intervalList valueForKeyPath:@"@min.intervalStart"];
                NSDate *maxFinishDate = [self.event.session.intervalList valueForKeyPath:@"@max.intervalFinish"];
                self.event.session.startDate = minStartDate;
                self.event.session.finishDate = maxFinishDate;
            }
            
            [self.event setEventType:[NSNumber numberWithInt:0]];
            [self.event setIsAbsence:[NSNumber numberWithBool:false]];
        }
        else if (self.eventCategory == kEventTypeCategoryAbsence) {
            if (self.event.session) {
                [self.event.managedObjectContext deleteObject:self.event.session];
            }
            
            if (self.intervalArray) {
                for (Interval *interval in self.intervalArray) {
                    [self.event.managedObjectContext deleteObject:interval];
                }
            }
            
            [self.event setEventType:[NSNumber numberWithInt:0]];
            [self.event setIsAbsence:[NSNumber numberWithBool:true]];
        }
        
        self.event.eventDescription = self.eventDescriptionTextField.text;

        NSError *error;
        [self.event.managedObjectContext save:&error];
    }

    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
        [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark UITableViewDataSource - Dynamic Section

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger sectionCount = kTableViewSectionCount;
    
    if (self.eventCategory == kEventTypeCategoryAbsence) {
        sectionCount--;
    }
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kDynamicSectionIndex) {
        return [self.intervalArray count];
    }
    else
        return [super tableView:self.tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kDynamicSectionIndex) {
        IntervalTableViewCell *intervalCell = [tableView dequeueReusableCellWithIdentifier:intervalCellIdentifier];
        
        Interval *interval = [self.intervalArray objectAtIndex:indexPath.row];
        
        [intervalCell configureForInterval:interval];
        
        return intervalCell;
    }
    else {
        return [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [super tableView:self.tableView titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kDynamicSectionIndex) {
        return kDynamicSectionHeight;
    }
    else
        return [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kDynamicSectionIndex) {
        IntervalTableViewCell *intervalCell = [tableView dequeueReusableCellWithIdentifier:intervalCellIdentifier];
        return intervalCell.indentationLevel;
    }
    else
        return [super tableView:self.tableView indentationLevelForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == kDynamicSectionIndex) {
        [self performSegueWithIdentifier:@"eventDetailToIntervalDetailSegue" sender:indexPath];
    }
    
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"eventDetailToScheduleSegue"])
    {
        ScheduleTableViewController *scheduleTableViewController = segue.destinationViewController;
        
        scheduleTableViewController.event = self.event;
    }
    else if ([segue.identifier isEqualToString:@"eventDetailToIntervalDetailSegue"])
    {
        IntervalDetailTableViewController *intervalDetailTableViewController = segue.destinationViewController;
        
        if ([sender isKindOfClass:([NSIndexPath class])]) {
            NSIndexPath *indexPath = (NSIndexPath *)sender;
            Interval *interval = [self.intervalArray objectAtIndex:indexPath.row];
            intervalDetailTableViewController.interval = interval;
        }
    }
}

@end
