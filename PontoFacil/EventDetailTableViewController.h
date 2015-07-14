//
//  EventDetailTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Event;

@interface EventDetailTableViewController : UITableViewController

@property (strong, nonatomic) Event *event;

@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *eventDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *eventDescriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *eventEstWorkTime;

@end
