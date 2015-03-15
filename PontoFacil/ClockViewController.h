//
//  ClockViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleProgressView;
@class ActionButton;

@interface ClockViewController : UIViewController

@property (strong, nonatomic) IBOutlet CircleProgressView *clockView;

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *breakTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishDateLabel;

@property (strong, nonatomic) IBOutlet ActionButton *startStopButton;

@property (strong, nonatomic) IBOutlet UIButton *pauseResumeButton;

@end
