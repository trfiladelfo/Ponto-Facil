//
//  IntervalTableViewCell.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "IntervalTableViewCell.h"
#import "Interval+Management.h"

@implementation IntervalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForInterval:(Interval *)interval {

    NSString *intervalType;
    switch (interval.intervalCategoryType) {
        case kIntervalTypeWork:
        default:
            intervalType = @"Trabalho";
            break;
        case kIntervalTypeBreak:
            intervalType = @"Intervalo";
            break;
        case kIntervalTransit:
            intervalType = @"Trânsito";
            break;
    }
    
    self.intervalTypeLabel.text = intervalType;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    self.intervalStartLabel.text = [dateFormatter stringFromDate:interval.startDate];
    
    if (interval.finishDate == nil) {
        self.intervalFinishLabel.text = @"in progress";
    }
    else
    {
        self.intervalFinishLabel.text = [dateFormatter stringFromDate:interval.finishDate];
    }
}

@end
