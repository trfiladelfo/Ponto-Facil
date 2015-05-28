//
//  ConfigTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ConfigTableViewController.h"
#import "NSDate-Utilities.h"
#import "RangeSlider.h"

#define KPICKERHEIGHT 160;

@interface ConfigTableViewController ()

@property (nonatomic, assign) BOOL showToleranceDatePicker;
@property (strong, nonatomic) NSMutableArray *minutes;
@property (nonatomic, assign) int selTolerance;

@end

@implementation ConfigTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadIntervalDatePicker];
    [self loadDefaultSessionData];
    [self initRangeSlider];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self saveDefaultSessionData];
}

#pragma mark - Private Functions

- (void)loadIntervalDatePicker {
    
    if (!_minutes) {
        _minutes = [NSMutableArray arrayWithCapacity:59];
    }
    
    for (int i = 0; i < 60; i++) {
        [_minutes insertObject:[NSString stringWithFormat:@"%.2i", i] atIndex:i];
    }
}

- (void)loadDefaultSessionData {

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    if ([defaults stringForKey:@"defaultStartDate"]) {
        self.startDateLabel.text = [defaults stringForKey:@"defaultStartDate"];
        self.finishDateLabel.text = [defaults stringForKey:@"defaultStopDate"];
        
        NSDate *startDate = [dateFormatter dateFromString:self.startDateLabel.text];
        NSDate *finishDate = [dateFormatter dateFromString:self.finishDateLabel.text];
        
        [_startDatePicker setDate:startDate];
        [_finishDatePicker setDate:finishDate];
    }
    
    if ([defaults stringForKey:@"defaultBreakTime"]) {
        self.breakTimeLabel.text = [defaults stringForKey:@"defaultBreakTime"];
        
        //int hour = [[self.breakTimeLabel.text substringToIndex:2] intValue];
        //int minute = [[self.breakTimeLabel.text substringFromIndex:3] intValue];
        //self.selHour = [NSString stringWithFormat:@"%2i", hour];
        //self.selMinute = [NSString stringWithFormat:@"%2i", minute];
        
        //[_timeOutPicker selectRow:hour inComponent:0 animated:false];
        //[_timeOutPicker selectRow:minute inComponent:1 animated:false];
    }
    
    
    [self.breakTimeAdjustSwitch setOn:[defaults boolForKey:@"adjustMinTimeOut"]];
    
    _selTolerance = (int)[defaults integerForKey:@"toleranceTime"];
    self.toleranceTimeLabel.text = [NSString stringWithFormat:@"%2i", _selTolerance];
    
    [self.regularTimeNotificationSwitch setOn:[defaults boolForKey:@"workTimeNotification"]];
    [self.breakTimeNotificationSwitch setOn:[defaults boolForKey:@"timeOutNotification"]];
    
    _showToleranceDatePicker = false;
}

- (void)initRangeSlider {


    // Configure the cell.
    RangeSlider *slider=  [[RangeSlider alloc] initWithFrame:self.intervalCellView.bounds];
    slider.minimumValue = 1;
    slider.selectedMinimumValue = 180;
    slider.maximumValue = 24*60;
    slider.selectedMaximumValue = 240;
    slider.minimumRange = 0;
    [slider addTarget:self action:@selector(updateIntervalRangeLabel:) forControlEvents:UIControlEventValueChanged];
    
    [self.intervalCellView addSubview:slider];
}

- (void)updateIntervalRangeLabel:(id)sender {

    //
}

- (void)saveDefaultSessionData {
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"HH:mm"];
    
    NSDate *startDate = [dateFormater dateFromString:self.startDateLabel.text];
    NSDate *finishDate = [dateFormater dateFromString:self.finishDateLabel.text];
    NSDate *breakRefDate = [[[[NSDate date] dateAtStartOfDay] dateByAddingHours:[[_breakTimeLabel.text substringToIndex:2] intValue]] dateByAddingMinutes:[[_breakTimeLabel.text substringFromIndex:3] intValue]];
    NSTimeInterval breakTimeCount = [breakRefDate timeIntervalSinceDate:[[NSDate date] dateAtStartOfDay]];
    
    NSTimeInterval workTime = [finishDate timeIntervalSinceDate:startDate] - breakTimeCount;
    
    //Grava as configurações
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setValue:self.startDateLabel.text forKey:@"defaultStartDate"];
    [defaults setValue:self.breakTimeLabel.text forKey:@"defaultBreakTime"];
    [defaults setValue:self.finishDateLabel.text forKey:@"defaultStopDate"];
    [defaults setDouble:breakTimeCount forKey:@"defaultMinTimeOut"];
    [defaults setDouble:workTime forKey:@"defaultWorkTime"];
    
    [defaults setBool:self.breakTimeAdjustSwitch.isOn forKey:@"adjustMinTimeOut"];
    [defaults setInteger:_selTolerance forKey:@"toleranceTime"];
    
    [defaults setBool:self.regularTimeNotificationSwitch.isOn forKey:@"workTimeNotification"];
    [defaults setBool:self.breakTimeNotificationSwitch.isOn forKey:@"timeOutNotification"];
    [defaults synchronize];
}

#pragma mark - User Interface

- (IBAction)startDatePickerChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *pickerDate = [dateFormatter stringFromDate:[_startDatePicker date]];
    _startDateLabel.text = pickerDate;
    
    if ([[_startDatePicker date] isLaterThanDate:[_finishDatePicker date]]) {
        [_finishDatePicker setDate:[_startDatePicker date]];
        
        NSString *finishPickerDate = [dateFormatter stringFromDate:[_finishDatePicker date]];
        _finishDateLabel.text = finishPickerDate;
    }
    
}

- (IBAction)finishDatePickerChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *pickerDate = [dateFormatter stringFromDate:[_finishDatePicker date]];
    _finishDateLabel.text = pickerDate;
    
    if ([[_finishDatePicker date] isEarlierThanDate:[_startDatePicker date]]) {
        [_startDatePicker setDate:[_finishDatePicker date]];
        
        NSString *startPickerDate = [dateFormatter stringFromDate:[_startDatePicker date]];
        _startDateLabel.text = startPickerDate;
    }
}

#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        _showToleranceDatePicker = !_showToleranceDatePicker;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
        //Move o scroll até a posição da linha que foi selecionada
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        // Tolerance Date Picker
        if (_showToleranceDatePicker) {
            return KPICKERHEIGHT;
        } else {
            return 0;
        }
    }
    else {
        return self.tableView.rowHeight;
    }
}


#pragma mark - Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    if (pickerView.tag == 1) {
        return 2;
    }
    else
        return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
        return [_minutes count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [_minutes objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    _selTolerance = [[_minutes objectAtIndex:row] intValue];
    _toleranceTimeLabel.text = [[NSString alloc] initWithFormat:
                        @"%2i minutos", _selTolerance];
}

@end
