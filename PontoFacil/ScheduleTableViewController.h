//
//  ScheduleTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 02/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface ScheduleTableViewController : UITableViewController

@property (nonatomic, strong) Session *session;

@end
