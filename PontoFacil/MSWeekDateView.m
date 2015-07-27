//
//  MSWeekDateView.m
//  TimeKeeper
//
//  Created by Carlos Eduardo Arantes Ferreira on 6/8/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "MSWeekDateView.h"

@interface MSWeekDateView ()

@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation MSWeekDateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupViews];
    
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.dateLabel sizeToFit];
    self.dateLabel.center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y- self.frame.origin.y);
}

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = kPFColorWeekDateView;
    self.layer.cornerRadius = 5.0f;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.numberOfLines = 2;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_dateLabel];
    }
    
    return _dateLabel;
}

- (void)setDate:(NSDate *)date
{
    _date = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayFormattedString = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"EEE"];
    NSString *dayInWeekFormattedString = [dateFormatter stringFromDate:date];
    
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", dayFormattedString, [dayInWeekFormattedString uppercaseString]]];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:20],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(0, dayFormattedString.length)];
    
    [dateString addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:9],
                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                }
                        range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];

    
    if ([self isWeekday:date]) {
        [dateString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"HelveticaNeue-Medium" size:8]
                           range:NSMakeRange(dayFormattedString.length + 1, dayInWeekFormattedString.length)];
    }
    
    self.dateLabel.attributedText = dateString;
}

#pragma mark Other methods

- (BOOL)isWeekday:(NSDate *)date
{
    NSInteger day = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    
    const NSInteger kSunday = 1;
    const NSInteger kSaturday = 7;
    
    BOOL isWeekdayResult = day == kSunday || day == kSaturday;
    
    return isWeekdayResult;
}

@end
