//
//  ScheduleTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 02/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "DatePickerTableViewCell.h"
#import "NSUserDefaults+PontoFacil.h"
#import "Event+Management.h"

static CGFloat kDatePickerRowHeight = 120;
static NSString * const cellIdentifier = @"timeLabelCell";
static NSString * const pickerCellIdentifier = @"datePickerCell";

@interface ScheduleTableViewController () <DatePickerTableViewCellDelegate>

@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) NSArray *sections;
@property (strong, nonatomic) NSArray *staticRows;
@property (strong, nonatomic) NSMutableArray *defaultData;
@property (nonatomic, assign) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSDateFormatter *formatter;

@end

@implementation ScheduleTableViewController

- (NSArray *)sections {
    
    if (!_sections) {
        _sections = [NSArray arrayWithObjects:kPFStringScheduleTableViewSectionTitleWork, kPFStringScheduleTableViewSectionTitleBreak, nil];
    }
    
    return _sections;
}

- (NSArray *)staticRows {

    if (!_staticRows) {
        _staticRows = [NSArray arrayWithObjects:[NSArray arrayWithObjects:kPFStringScheduleTableViewCellLabelEntrance, kPFStringScheduleTableViewCellLabelExit, nil], [NSArray arrayWithObjects:kPFStringScheduleTableViewCellLabelStart, kPFStringScheduleTableViewCellLabelFinish, nil], nil];
    }
    
    return _staticRows;
}


- (NSMutableArray *)defaultData {
    
    if (!_defaultData) {
        if (self.event) {
            NSString *estWorkStart = [self.formatter stringFromDate:_event.estWorkStart];
            NSString *estWorkFinish = [self.formatter stringFromDate:_event.estWorkFinish];
            NSString *estBreakStart = [self.formatter stringFromDate:_event.estBreakStart];
            NSString *estBreakFinish = [self.formatter stringFromDate:_event.estBreakFinish];
            
            _defaultData = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:estWorkStart, estWorkFinish, nil], [NSMutableArray arrayWithObjects:estBreakStart, estBreakFinish, nil], nil];
        }
        else
        {
            _defaultData = [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:self.userDefaults.workStartDate , self.userDefaults.workFinishDate, nil], [NSMutableArray arrayWithObjects:self.userDefaults.breakStartDate, self.userDefaults.breakFinishDate, nil], nil];
        }
    }
    
    return _defaultData;
}

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"HH:mm"];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:pickerCellIdentifier];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self saveData];
}

- (void)saveData {
    
    NSString *workStartDate = [self.defaultData[0] objectAtIndex:0];
    NSString *workFinishDate = [self.defaultData[0] objectAtIndex:1];
    NSString *breakStartDate = [self.defaultData[1] objectAtIndex:0];
    NSString *breakFinishDate = [self.defaultData[1] objectAtIndex:1];
    
    if (self.event) {
        //Return Changed Event
        self.event.estWorkStart = [self.formatter dateFromString:workStartDate];
        self.event.estWorkFinish = [self.formatter dateFromString:workFinishDate];
        self.event.estBreakStart = [self.formatter dateFromString:breakStartDate];
        self.event.estBreakFinish = [self.formatter dateFromString:breakFinishDate];
    }
    else {
        [self.userDefaults setWorkStartDate:workStartDate];
        [self.userDefaults setWorkFinishDate:workFinishDate];
        [self.userDefaults setBreakStartDate:breakStartDate];
        [self.userDefaults setBreakFinishDate:breakFinishDate];
        [self.userDefaults synchronize];
    }
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.staticRows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionItens = [self.staticRows objectAtIndex:section];
    NSInteger rowCount = [sectionItens count];
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.section == section)) {
        rowCount++;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self datePickerIsShown] && ([indexPath compare:self.datePickerIndexPath] == NSOrderedSame)) {
        DatePickerTableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier];
        
        pickerCell.delegate = self;
        
        pickerCell.date = [self.formatter dateFromString:[[self.defaultData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1]];
        
        return pickerCell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.textLabel.text = [[self.staticRows objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[self.defaultData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [self.sections objectAtIndex:section];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self datePickerIsShown] && ([indexPath compare:self.datePickerIndexPath] == NSOrderedSame)) {
        return kDatePickerRowHeight;
    }
    else
        return [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    if ([self datePickerIsShown]){
        [self hideExistingPicker];
    }
    
    [self showNewPickerAtIndex:indexPath];

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
}

#pragma mark Picker

- (BOOL)datePickerIsShown {
    return self.datePickerIndexPath != nil;
}

- (void)hideExistingPicker {
    [self.tableView deleteRowsAtIndexPaths:@[_datePickerIndexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = nil;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;
    NSInteger rowCount = [[self.staticRows objectAtIndex:indexPath.section] count];
    
    if (row < rowCount) {
        row++;
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:row inSection:indexPath.section];
    
     [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = newIndexPath;
}

#pragma mark DatePickerTableViewCellDelegate

- (void)pickerNewDate:(NSDate *)date {
    
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:self.datePickerIndexPath.item-1 inSection:self.datePickerIndexPath.section];
    
    NSMutableArray *sectionArray = self.defaultData[cellIndexPath.section];
    sectionArray[cellIndexPath.row] = [self.formatter stringFromDate:date];
    self.defaultData[cellIndexPath.section] = sectionArray;
    
    [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
