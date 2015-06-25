//
//  ClockViewController_Spec.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ClockViewController.h"

@class BDKNotifyHUD;
@class Session;

@interface ClockViewController ()

@property (nonatomic, assign) NSUserDefaults *userDefaults;
@property (strong, nonatomic) BDKNotifyHUD *alertViewProvider;
@property (strong, nonatomic) UIActionSheet *actionSheetProvider;
@property (strong, nonatomic) Session *session;

- (IBAction)startStopButtonClick:(id)sender;
- (IBAction)breakButtonClick:(id)sender;
- (IBAction)reviewButtonClick:(id)sender;

@end
