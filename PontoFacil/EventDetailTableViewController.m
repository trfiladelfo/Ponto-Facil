//
//  EventDetailTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventDetailTableViewController.h"
#import "Session+Management.h"
#import "NSString+TimeInterval.h"
#import "NSDate-Utilities.h"
#import "NSUserDefaults+PontoFacil.h"

#define ROW_HEIGHT 150.0

@interface EventDetailTableViewController ()

@property (nonatomic, assign) BOOL showSessionDatePicker;
@property (nonatomic, assign) BOOL showStartDatePicker;
@property (nonatomic, assign) BOOL showFinishDatePicker;
@property (nonatomic, assign) BOOL showIntervalDatePicker;

@property (strong, nonatomic) NSMutableArray *hours;
@property (strong, nonatomic) NSMutableArray *minutes;
@property (nonatomic, strong) NSString *selHour;
@property (nonatomic, strong) NSString *selMinute;

@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadIntervalDatePicker];

    //Alteração
    if (_session) {
        
        [self loadSessionData];
    }
    else {
        //Valores Padrão das configurações
        [self loadDefaultSessionData];
        
        //Habilita o botão de cancelar
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    }
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

- (void)loadSessionData {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMyyyy" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatString];
    
    self.sessionDateLabel.text = [dateFormatter stringFromDate:self.session.startDate];
    [_sessionDatePicker setDate:self.session.startDate];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    self.startDateLabel.text = [dateFormatter stringFromDate:self.session.startDate];
    [_startDatePicker setDate:self.session.startDate];
    self.finishDateLabel.text = [dateFormatter stringFromDate:self.session.finishDate];
    [_finishDatePicker setDate:self.session.finishDate];
    self.breakTimeLabel.text = [NSString stringWithTimeInterval:[self.session.breakTime doubleValue]];
    //[_breakTimePicker selectRow:hour inComponent:0 animated:false];
    //[_breakTimePicker selectRow:minute inComponent:1 animated:false];
    
}

- (void)loadDefaultSessionData {
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMyyyy" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatString];
    
    NSDate *now = [NSDate date];
    self.sessionDateLabel.text = [dateFormatter stringFromDate:now];
    [_sessionDatePicker setDate:now];
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    if (defaults.isLoaded) {
        self.startDateLabel.text = [defaults workStartDate];
        self.finishDateLabel.text = [defaults workFinishDate];
        
        NSDate *startDate = [dateFormatter dateFromString:self.startDateLabel.text];
        NSDate *finishDate = [dateFormatter dateFromString:self.finishDateLabel.text];
        
        [_startDatePicker setDate:startDate];
        [_finishDatePicker setDate:finishDate];
    
        self.breakTimeLabel.text = [NSString stringWithTimeInterval:[defaults defaultBreakTime]];
        
        int hour = [[self.breakTimeLabel.text substringToIndex:2] intValue];
        int minute = [[self.breakTimeLabel.text substringFromIndex:3] intValue];
        self.selHour = [NSString stringWithFormat:@"%2i", hour];
        self.selMinute = [NSString stringWithFormat:@"%2i", minute];
        
        [_breakTimePicker selectRow:hour inComponent:0 animated:false];
        [_breakTimePicker selectRow:minute inComponent:1 animated:false];
    }
    else
    {
        _selHour = @"00";
        _selMinute = @"00";
    }
    
    _showSessionDatePicker = false;
    _showStartDatePicker = false;
    _showFinishDatePicker = false;
    _showIntervalDatePicker = false;

}

#pragma mark - User Interface

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{

}

#pragma mark - User Interface

- (IBAction)sessionDatePickerChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMyyyy" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatString];
    
    NSString *pickerDate = [dateFormatter stringFromDate:[_sessionDatePicker date]];
    _sessionDateLabel.text = pickerDate;

}


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

/*
- (IBAction)saveButtonPressed:(id)sender
{
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMMyyyy" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormater setDateFormat:formatString];
    
    NSDate *sessionDate = [[dateFormater dateFromString:_sessionDateLabel.text] dateAtStartOfDay];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:sessionDate.day];
    [comps setMonth:sessionDate.month];
    [comps setYear:sessionDate.year];
    
    [comps setHour:9];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *estStartDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    [comps setHour:18];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *estFinishDate = [[NSCalendar currentCalendar] dateFromComponents:comps];

    [comps setHour:1];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *estbreakDateTime = [[NSCalendar currentCalendar] dateFromComponents:comps];
    NSTimeInterval estBreakTime = [estbreakDateTime timeIntervalSinceDate:[sessionDate dateAtStartOfDay]];
    
    //Inclusão
    if (!_session) {
            
        _session = [Session insertSessionWithEstStartDate:estStartDate andEstFinishDate:estFinishDate andEstBreakTime:estBreakTime andIsManual:true andSessionState:kSessionStateStop andStartDate:<#(NSDate *)#>];
    }
    else {
            
        [comps setHour:[[_startDateLabel.text substringToIndex:2] intValue]];
        [comps setMinute:[[_startDateLabel.text substringFromIndex:3] intValue]];
        [comps setSecond:0];
        NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
        
        [comps setHour:[[_finishDateLabel.text substringToIndex:2] intValue]];
        [comps setMinute:[[_finishDateLabel.text substringFromIndex:3] intValue]];
        [comps setSecond:0];
        NSDate *finishDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
            
        [comps setHour:[[_breakTimeLabel.text substringToIndex:2] intValue]];
        [comps setMinute:[[_breakTimeLabel.text substringFromIndex:3] intValue]];
        [comps setSecond:0];
        NSDate *breakDateTime = [[NSCalendar currentCalendar] dateFromComponents:comps];
        NSTimeInterval breakTime = [breakDateTime timeIntervalSinceDate:[sessionDate dateAtStartOfDay]];
        
        double workTime = [finishDate timeIntervalSinceDate:startDate] - breakTime;
        
        _session.startDate = startDate;
        _session.finishDate = finishDate;
        //_session.workTime = [NSNumber numberWithDouble:workTime];
        //_session.workAdjustedTime = [NSNumber numberWithDouble:[_session calculateAdjustedWorkTime:workTime andBreakTime:breakTime]];
        //_session.workBreakTime = [NSNumber numberWithDouble:breakTime];
    }
        
    _session.sessionStateCategory = kSessionStateStop;
    _session.isManual = [NSNumber numberWithBool:true];
    
    NSError *error;
    [self.session.managedObjectContext save:&error];
    
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:TRUE];
    }
    
}
*/


#pragma mark - TableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        _showSessionDatePicker = !_showSessionDatePicker;
        _showStartDatePicker = false;
        _showFinishDatePicker = false;
        _showIntervalDatePicker = false;
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0) {
        _showStartDatePicker = !_showStartDatePicker;
        _showSessionDatePicker = false;
        _showFinishDatePicker = false;
        _showIntervalDatePicker = false;
    }
    else if (indexPath.section == 1 && indexPath.row == 2) {
        _showIntervalDatePicker = !_showIntervalDatePicker;
        _showSessionDatePicker = false;
        _showStartDatePicker = false;
        _showFinishDatePicker = false;
    }
    else if (indexPath.section == 1 && indexPath.row == 4) {
        _showFinishDatePicker = !_showFinishDatePicker;
        _showSessionDatePicker = false;
        _showStartDatePicker = false;
        _showIntervalDatePicker = false;
    }
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0],[NSIndexPath indexPathForItem:1 inSection:1], [NSIndexPath indexPathForItem:3 inSection:1], [NSIndexPath indexPathForItem:5 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
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
        if (_showSessionDatePicker) {
            return ROW_HEIGHT;
        } else {
            return 0;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        // Start Date Picker
        if (_showStartDatePicker) {
            return ROW_HEIGHT;
        } else {
            return 0;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 3) {
        
        // Finish Date Picker
        if (_showIntervalDatePicker) {
            return ROW_HEIGHT;
        } else {
            return 0;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 5) {
        
        // Interal Date Picker
        if (_showFinishDatePicker) {
            return 150;
        } else {
            return 0;
        }
    }
    else {
        return self.tableView.rowHeight;
    }
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    if (pickerView.tag == 1) {
        return 2;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        if (component == 0) {
            //Horas
            return [_hours count];
        }
        else if (component == 1) {
            //Minutos
            return [_minutes count];
        }
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        if (component == 0) {
            //Horas
            return [_hours objectAtIndex:row];
        }
        else if (component == 1) {
            //Minutos
            return [_minutes objectAtIndex:row];
        }
    }
    
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        if (component == 0) {
            _selHour = [_hours objectAtIndex:row];
        } else if (component == 1) {
            _selMinute = [_minutes objectAtIndex:row];
        }
        
        _breakTimeLabel.text = [[NSString alloc] initWithFormat:
                                @"%@:%@ ", _selHour, _selMinute];
    }
}


@end
