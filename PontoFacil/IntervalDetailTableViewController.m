//
//  IntervalDetailTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "IntervalDetailTableViewController.h"
#import "DatePickerTableViewCell.h"
#import "Session+Management.h"
#import "Interval+Management.h"

static CGFloat kDatePickerRowHeight = 120;
static NSString * const cellIdentifier = @"eventCell";
static NSString * const pickerCellIdentifier = @"datePickerCell";

@interface IntervalDetailTableViewController () <DatePickerTableViewCellDelegate>

@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (nonatomic, retain) NSDateFormatter *formatter;
//@property (nonatomic, strong) NSMutableArray *intervalList;

@end

@implementation IntervalDetailTableViewController

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"HH:mm"];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}

/*
- (NSMutableArray *)intervalList {

    if (!_intervalList) {
        _intervalList = [[NSMutableArray alloc] init];
        
        if (self.interval.previousInterval != nil) {
            [_intervalList addObject:self.interval.previousInterval];
        }
        
        [_intervalList addObject:self.interval];
        
        if (self.interval.nextInterval != nil) {
            [_intervalList addObject:self.interval.nextInterval];
        }
    }
    
    return _intervalList;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:pickerCellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    //Interval *interval = [self.intervalList objectAtIndex:section];
    
    if (self.interval.intervalCategoryType == kIntervalTypeWork) {
        return @"Trabalho";
    }
    else if (self.interval.intervalCategoryType == kIntervalTypeBreak) {
        return @"Intervalo";
    }
    else
        return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger rowCount = self.interval.intervalFinish == nil ? 1 : 2;
    
    if ([self datePickerIsShown]) {
        rowCount++;
    }
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Interval *interval = [self.intervalList objectAtIndex:indexPath.section];
    
    if ([self datePickerIsShown] && ([indexPath compare:self.datePickerIndexPath] == NSOrderedSame)) {
        DatePickerTableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier];
        
        pickerCell.delegate = self;
        
        pickerCell.date = (indexPath.row == 1 ? self.interval.intervalStart : self.interval.intervalFinish);
        
        return pickerCell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        NSString *labelText;
        NSString *detailText;
        if (indexPath.row == 0) {
            labelText = @"Início";
            detailText = [self.formatter stringFromDate:self.interval.intervalStart];
        }
        else {
            labelText = @"Fim";
            detailText = [self.formatter stringFromDate:self.interval.intervalFinish];
        }
        
        cell.textLabel.text = labelText;
        cell.detailTextLabel.text = detailText;
        
        return cell;
    }
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
    NSInteger rowCount = 2;
    
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
    
    //Interval *interval = [self.intervalList objectAtIndex:cellIndexPath.section];
    
    if (cellIndexPath.row == 0) {
        self.interval.intervalStart = date;
    }
    else {
        self.interval.intervalFinish = date;
    }
    
    //[self.tableView reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadData];
}

@end
