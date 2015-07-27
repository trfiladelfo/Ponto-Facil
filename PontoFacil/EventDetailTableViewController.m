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
static NSInteger kDynamicSectionIndex = 2;
static CGFloat kDynamicSectionHeight = 50.0;
static NSString *intervalCellIdentifier = @"intervalCell";

typedef NS_ENUM(NSInteger, EventTypeControllerCategory) {
    kEventTypeCategorySession = 0,
    kEventTypeCategoryAbsence = 1,
    kEventTypeCategoryHoliday = 2
};

@interface EventDetailTableViewController ()

@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, assign) NSUserDefaults *userDefaults;
@property (nonatomic, strong) NSArray *intervalArray;
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

- (NSArray *)intervalArray {

    if (self.event.session) {
        _intervalArray = self.event.session.ascendingIntervalList;
    }
    else {
        _intervalArray = [[NSArray alloc] init];
    }
    return _intervalArray;
}

- (Event *)event {

    if (!_event) {
        
        switch (self.eventCategory) {
            case kEventTypeCategorySession:
            default:
                _event = [[Event alloc] initSessionEvent];
                break;
            case kEventTypeCategoryAbsence:
                _event = [[Event alloc] initAbsenceEvent];
                break;
            case kEventTypeCategoryHoliday:
                _event = [[Event alloc] initHolidayEvent];
                break;
        }
        
    }
    
    return _event;
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
    else {
        self.eventDateLabel.text = [self.formatter stringFromDate:self.event.estWorkStart];
        [self.eventDatePicker setDate:self.event.estWorkStart];
        self.eventEstWorkTime.text = [NSString stringWithTimeInterval:[self.event.estWorkTime doubleValue]];
        self.eventDescriptionTextField.text = self.event.eventDescription;
        
        if (self.eventCategory == kEventTypeCategorySession) {
            [self loadSessionData];
        }
    }
}

#pragma mark - Private Functions


- (void)loadSessionData {
    if (!self.event.session) {
        self.event.session = [[Session alloc] initWithEvent:self.event];
        self.event.session.intervalList = [self loadDefaultIntervalList];
    }
}

- (NSSet *)loadDefaultIntervalList {

    [self.formatter setDateFormat:@"HH:mm"];
    NSDate *workStartDate = [self.formatter dateFromString:[self.userDefaults workStartDate]];
    NSDate *workFinishDate = [self.formatter dateFromString:[self.userDefaults workFinishDate]];
    NSDate *breakStartDate = [self.formatter dateFromString:[self.userDefaults breakStartDate]];
    NSDate *breakFinishDate = [self.formatter dateFromString:[self.userDefaults breakFinishDate]];
    [self.formatter setDateStyle:NSDateFormatterLongStyle];
    [self.formatter setTimeStyle:NSDateFormatterNoStyle];
    
    Interval *interval1 = [Interval insertIntervalWithStartDate:workStartDate andfinishDate:breakStartDate andIntervalCategoryType:kIntervalTypeWork andPreviousInterval:nil];
    Interval *interval2 = [Interval insertIntervalWithStartDate:breakStartDate andfinishDate:breakFinishDate andIntervalCategoryType:kIntervalTypeBreak andPreviousInterval:interval1];
    Interval *interval3 = [Interval insertIntervalWithStartDate:breakFinishDate andfinishDate:workFinishDate andIntervalCategoryType:kIntervalTypeWork andPreviousInterval:nil];
    
    NSSet *defaultIntervalList = [[NSSet alloc] initWithObjects:interval1, interval2, interval3, nil];
    
    return defaultIntervalList;
}


#pragma mark - User Interface

- (IBAction)eventTypeSegmentedControlerChanged:(id)sender {

    self.eventCategory = [self.eventTypeSegmentedControl selectedSegmentIndex];
    
    switch (self.eventCategory) {
        case kEventTypeCategorySession:
        default:
            [self loadSessionData];
            break;
        case kEventTypeCategoryAbsence:
            self.event.session = nil;
            self.event.isAbsence = [NSNumber numberWithBool:true];
            break;
        case kEventTypeCategoryHoliday:
            //
            break;
    }
    
    [self.tableView reloadData];
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
    
    [self.event updateEventDate:self.eventDatePicker.date];
    
    self.event.eventDescription = self.eventDescriptionTextField.text;
    
    if (self.event.session) {
        NSDate *minStartDate = [self.event.session.intervalList valueForKeyPath:@"@min.intervalStart"];
        NSDate *maxFinishDate = [self.event.session.intervalList valueForKeyPath:@"@max.intervalFinish"];
        
        self.event.session.startDate = minStartDate;
        self.event.session.finishDate = maxFinishDate;
    }

    NSError *error;
    [self.event.managedObjectContext save:&error];
    
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
        [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return kTableViewSectionCount;
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


#pragma mark - User Interface

- (IBAction)eventDatePickerChanged:(id)sender
{
    NSString *pickerDate = [self.formatter stringFromDate:[self.eventDatePicker date]];
    self.eventDateLabel.text = pickerDate;

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
