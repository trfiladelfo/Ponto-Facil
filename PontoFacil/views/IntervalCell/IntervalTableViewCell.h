//
//  IntervalTableViewCell.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Interval;

@interface IntervalTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *intervalStartLabel;
@property (strong, nonatomic) IBOutlet UILabel *intervalFinishLabel;
@property (strong, nonatomic) IBOutlet UILabel *intervalTypeLabel;


- (void)configureForInterval:(Interval *)interval;

@end
