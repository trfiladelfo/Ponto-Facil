//
//  IntervalListTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface IntervalListTableViewController : UITableViewController

@property (nonatomic, strong) Session *session;

@property (strong, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *breakTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeBalanceLabel;

@end
