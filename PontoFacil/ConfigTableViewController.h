//
//  ConfigTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigTableViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *breakTimeLabel;

@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (strong, nonatomic) IBOutlet UIDatePicker *finishDatePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *timeOutPicker;

@property (strong, nonatomic) IBOutlet UISwitch *regularTimeNotificationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *breakTimeNotificationSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *breakTimeAdjustSwitch;
@property (strong, nonatomic) IBOutlet UILabel *toleranceTimeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *tolerancePicker;

@end
