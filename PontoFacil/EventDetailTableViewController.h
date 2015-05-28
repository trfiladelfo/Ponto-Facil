//
//  EventDetailTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface EventDetailTableViewController : UITableViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) Session *session;

@property (strong, nonatomic) IBOutlet UILabel *sessionDateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *sessionDatePicker;

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *breakTimeLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *breakTimePicker;

@property (strong, nonatomic) IBOutlet UILabel *finishDateLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *finishDatePicker;


@end
