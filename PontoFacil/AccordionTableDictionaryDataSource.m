//
//  AccordionTableDictionaryDataSource.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "AccordionTableDictionaryDataSource.h"
#import "DatePickerTableViewCell.h"

static CGFloat kDatePickerRowHeight = 120;
static NSString * const pickerCellIdentifier = @"datePickerCell";

@interface AccordionTableDictionaryDataSource()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSDictionary *items;
@property (nonatomic, copy) NSString *cellIdentifier;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;
@property (strong, nonatomic) NSIndexPath *datePickerParentIndexPath;

@end

@implementation AccordionTableDictionaryDataSource

- (id)initWithTableView:(UITableView *)tableView {

    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate = self;
        //self.items = items;
    }
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:section];
    
    if ([self datePickerIsShown]){
        numberOfRows++;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
        [tableView registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:pickerCellIdentifier];
        
        DatePickerTableViewCell *pickerCell = [tableView dequeueReusableCellWithIdentifier:pickerCellIdentifier                                               forIndexPath:indexPath];
        
        pickerCell.delegate = self;
        
        return pickerCell;
        
    } else {
        return [self.tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView beginUpdates];
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row - 1 == indexPath.row)){
        
        [self hideExistingPicker];
        
    }else {
        
        NSIndexPath *newPickerIndexPath = [self calculateIndexPathForNewPicker:indexPath];
        
        if ([self datePickerIsShown]){
            
            [self hideExistingPicker];
            
        }
        
        [self showNewPickerAtIndex:newPickerIndexPath];
        
        self.datePickerParentIndexPath = newPickerIndexPath;
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:newPickerIndexPath.row + 1 inSection:newPickerIndexPath.section];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = self.tableView.rowHeight;
    
    if ([self datePickerIsShown] && (self.datePickerIndexPath.row == indexPath.row)){
        
        rowHeight = kDatePickerRowHeight;
        
    }
    
    return rowHeight;
}

#pragma mark Picker

- (BOOL)datePickerIsShown {
    
    return self.datePickerIndexPath != nil;
}

- (void)hideExistingPicker {
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    
    self.datePickerIndexPath = nil;
    self.datePickerParentIndexPath = nil;
}

- (NSIndexPath *)calculateIndexPathForNewPicker:(NSIndexPath *)selectedIndexPath {
    
    NSIndexPath *newIndexPath;
    
    if (([self datePickerIsShown]) && (self.datePickerIndexPath.row < selectedIndexPath.row)){
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row - 1 inSection:0];
        
    }else {
        
        newIndexPath = [NSIndexPath indexPathForRow:selectedIndexPath.row  inSection:0];
        
    }
    
    return newIndexPath;
}

- (void)showNewPickerAtIndex:(NSIndexPath *)indexPath {
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark DatePickerCell delegate

- (void)pickerNewDate:(NSDate *)date {
    
    if ([self datePickerIsShown]) {
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.datePickerParentIndexPath];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        cell.detailTextLabel.text = [formatter stringFromDate:date];
    }
    
}

@end
