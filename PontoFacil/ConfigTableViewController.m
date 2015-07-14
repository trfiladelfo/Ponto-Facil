//
//  ConfigTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ConfigTableViewController.h"
#import "NSUserDefaults+PontoFacil.h"
#import "NSString+TimeInterval.h"

#define KPICKERHEIGHT 160;

@interface ConfigTableViewController ()

@property (nonatomic, assign) NSUserDefaults *userDefaults;

@end

@implementation ConfigTableViewController

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (void)viewDidAppear:(BOOL)animated {

    [self loadDefaultData];
}

- (void)viewDidDisappear:(BOOL)animated {

    [self saveDefaultData];
}

#pragma mark - Private Functions


- (void)loadDefaultData {
    
    self.workTimeLabel.text = [NSString stringWithTimeInterval:[self.userDefaults defaultWorkTime]];
    [self.regularTimeNotificationSwitch setOn:[self.userDefaults workFinishNotification]];
    [self.breakTimeNotificationSwitch setOn:[self.userDefaults breakFinishNotification]];
    [self.breakTimeAdjustSwitch setOn:[self.userDefaults breakTimeRequired]];
    self.toleranceTimeLabel.text = [self.userDefaults toleranceTime] == 0 ? @"Nenhuma" : [NSString stringWithFormat:@"%2li minutos", [self.userDefaults toleranceTime]];
}

- (void)saveDefaultData {
    
    //Grava as configurações
    [self.userDefaults setBreakTimeRequired:self.breakTimeAdjustSwitch.isOn];
    [self.userDefaults setToleranceTime:0];
    [self.userDefaults setWorkFinishNotification:self.regularTimeNotificationSwitch.isOn];
    [self.userDefaults setBreakFinishNotification:self.breakTimeNotificationSwitch.isOn];
    [self.userDefaults synchronize];
}

#pragma mark - User Interface


#pragma mark - TableView
/*
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
*/

#pragma mark - Delegate Methods

/*
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
*/
@end
