//
//  ConfigTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigTableViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;

@property (strong, nonatomic) IBOutlet UISwitch *regularTimeNotificationSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *breakTimeNotificationSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *breakTimeAdjustSwitch;
@property (strong, nonatomic) IBOutlet UILabel *toleranceTimeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *tolerancePicker;

@end
