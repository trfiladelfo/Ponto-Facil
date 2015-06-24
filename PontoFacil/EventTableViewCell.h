//
//  EventTableViewCell.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 23/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSWeekDateView;
@class Event;

@interface EventTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (strong, nonatomic) IBOutlet MSWeekDateView *weekDateView;

@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *intervalTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *finishDateLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeBalanceLabel;


- (void)configureForEvent:(Event *)event;

@end
