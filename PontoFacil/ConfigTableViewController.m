//
//  ConfigTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ConfigTableViewController.h"
#import "NSDate-Utilities.h"

@interface ConfigTableViewController ()

@property (nonatomic, assign) BOOL showSessionDatePicker;
@property (nonatomic, assign) BOOL showStartDatePicker;
@property (nonatomic, assign) BOOL showFinishDatePicker;
@property (nonatomic, assign) BOOL showIntervalDatePicker;
@property (nonatomic, assign) BOOL showWorkNotification;
@property (nonatomic, assign) BOOL showBreakNotification;

@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSMutableArray *minutes;

@property (nonatomic, assign) NSString *selHour;
@property (nonatomic, assign) NSString *selMinute;

@end

@implementation ConfigTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadIntervalDatePicker];
    [self loadDefaultSessionData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self saveDefaultSessionData];
}

#pragma mark - Private Functions

- (void)loadIntervalDatePicker {

    if (!_hours) {
        _hours = [NSMutableArray arrayWithCapacity:7];
    }
    
    if (!_minutes) {
        _minutes = [NSMutableArray arrayWithCapacity:59];
    }
    
    for (int i = 0; i < 8; i++) {
        [_hours insertObject:[NSString stringWithFormat:@"%.2i", i] atIndex:i];
    }
    
    for (int i = 0; i < 60; i++) {
        [_minutes insertObject:[NSString stringWithFormat:@"%.2i", i] atIndex:i];
    }
}

- (void)loadDefaultSessionData {

    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    if ([defaults valueForKey:@"defaultStartDate"]) {
        self.startDateLabel.text = [defaults valueForKey:@"defaultStartDate"];
        self.finishDateLabel.text = [defaults valueForKey:@"defaultStopDate"];
        
        NSDate *startDate = [dateFormatter dateFromString:self.startDateLabel.text];
        NSDate *finishDate = [dateFormatter dateFromString:self.finishDateLabel.text];
        
        [_startDatePicker setDate:startDate];
        [_finishDatePicker setDate:finishDate];
    }
    
    if ([defaults valueForKey:@"defaultBreakTimer"]) {
        self.breakTimeLabel.text = [defaults valueForKey:@"defaultBreakTimer"];
        
        int hour = [[self.breakTimeLabel.text substringToIndex:2] intValue];
        int minute = [[self.breakTimeLabel.text substringFromIndex:3] intValue];
        _selHour = [NSString stringWithFormat:@"%2i", hour];
        _selMinute = [NSString stringWithFormat:@"%2i", minute];
        
        [_timeOutPicker selectRow:hour inComponent:0 animated:false];
        [_timeOutPicker selectRow:minute inComponent:1 animated:false];
    }
    else
    {
        _selHour = @"00";
        _selMinute = @"00";
    }
    
    [self.regularTimeNotificationSwitch setOn:[defaults boolForKey:@"workTimeNotification"]];
    [self.breakTimeNotificationSwitch setOn:[defaults boolForKey:@"timeOutNotification"]];
    
    _showStartDatePicker = false;
    _showFinishDatePicker = false;
    _showIntervalDatePicker = false;
    _showWorkNotification = false;
    _showBreakNotification = false;
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
    [defaults setValue:self.breakTimeLabel.text forKey:@"defaultBreakTimer"];
    [defaults setValue:self.finishDateLabel.text forKey:@"defaultStopDate"];
    
    [defaults setDouble:breakTimeCount forKey:@"defaultMinTimeOut"];
    [defaults setDouble:workTime forKey:@"defaultWorkTime"];
    [defaults setBool:self.regularTimeNotificationSwitch.isOn forKey:@"workTimeNotification"];
    [defaults setBool:self.breakTimeNotificationSwitch.isOn forKey:@"timeOutNotification"];
    [defaults setBool:self.breakTimeAdjustSwitch.isOn forKey:@"adjustMinTimeOut"];
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
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        _showStartDatePicker = !_showStartDatePicker;
        _showFinishDatePicker = false;
        _showIntervalDatePicker = false;
        
    }
    else if (indexPath.section == 0 && indexPath.row == 2) {
        _showIntervalDatePicker = !_showIntervalDatePicker;
        _showStartDatePicker = false;
        _showFinishDatePicker = false;
    }
    else if (indexPath.section == 0 && indexPath.row == 4) {
        _showFinishDatePicker = !_showFinishDatePicker;
        _showStartDatePicker = false;
        _showIntervalDatePicker = false;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0],[NSIndexPath indexPathForItem:3 inSection:0], [NSIndexPath indexPathForItem:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
        //Move o scroll até a posição da linha que foi selecionada
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        if (_showStartDatePicker) {
            return 150;
        } else {
            return 0;
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        // Start Date Picker
        if (_showIntervalDatePicker) {
            return 150;
        } else {
            return 0;
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 5) {
        
        // Finish Date Picker
        if (_showFinishDatePicker) {
            return 150;
        } else {
            return 0;
        }
    }
    else if ((indexPath.section == 2) && ((indexPath.row == 1) || (indexPath.row == 2))) {
        
        // Finish Date Picker
        if (_showWorkNotification) {
            return 150;
        } else {
            return 0;
        }
    }
    else if (indexPath.section == 2 && indexPath.row == 4) {
        
        // Finish Date Picker
        if (_showBreakNotification) {
            return 150;
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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        //Horas
        return [_hours count];
    }
    else if (component == 1) {
        //Minutos
        return [_minutes count];
    }
    else
        return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (component == 0) {
        //Horas
        return [_hours objectAtIndex:row];
    }
    else if (component == 1) {
        //Minutos
        return [_minutes objectAtIndex:row];
    }
    else
        return @"";
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    
    if (component == 0) {
        _selHour = [_hours objectAtIndex:row];
    } else if (component == 1) {
        _selMinute = [_minutes objectAtIndex:row];
    }
    
    NSString *resultString = [[NSString alloc] initWithFormat:
                              @"%@:%@ ", _selHour, _selMinute];
    
    _breakTimeLabel.text = resultString;
}

@end
