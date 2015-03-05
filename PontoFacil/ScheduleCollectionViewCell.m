//
//  ScheduleCollectionViewCell.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ScheduleCollectionViewCell.h"

@interface ScheduleCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UIView *indicatorView;

@end

@implementation ScheduleCollectionViewCell

- (void)awakeFromNib {

    self.dayLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
    [self.dayLabel.layer setMasksToBounds:YES];
    self.dayLabel.layer.cornerRadius = 15.0f;
    
    self.indicatorView.backgroundColor = [UIColor lightGrayColor];
    [self.indicatorView.layer setMasksToBounds:YES];
    self.indicatorView.layer.cornerRadius = 2.5f;
}

- (void)setDay:(NSInteger)day {
    _day = day;
    self.dayLabel.text = [NSString stringWithFormat:@"%2i", day];
}

- (void)setIsHighlighted:(BOOL)isHighlighted {
    _isHighlighted = isHighlighted;
    
    if (isHighlighted) {
        self.dayLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
    }
    else
    {
        self.dayLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setHasEvents:(BOOL)hasEvents {
    _hasEvents = hasEvents;
    
    if (hasEvents) {
        self.indicatorView.backgroundColor = [UIColor grayColor];
    }
    else
    {
        self.indicatorView.backgroundColor = [UIColor whiteColor];
    }
}

@end
