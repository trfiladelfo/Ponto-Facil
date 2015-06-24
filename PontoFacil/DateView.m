//
//  DateView.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 15/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "DateView.h"

@interface DateView ()

@property (nonatomic, assign) IBOutlet UILabel *weekDayLabel;
@property (nonatomic, assign) IBOutlet UILabel *dayLabel;
@property (nonatomic, assign) IBOutlet UILabel *monthLabel;

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *weekDay;

@end

@implementation DateView

- (void)awakeFromNib {

    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"EEE"];
    self.weekDay = [dateFormatter stringFromDate:today];
    
    [dateFormatter setDateFormat:@"dd"];
    self.day = [dateFormatter stringFromDate:today];
    
    [dateFormatter setDateFormat:@"MMMM"];
    self.month = [[dateFormatter stringFromDate:today] uppercaseString];
    
}


- (void)setWeekDay:(NSString *)weekDay {

    _weekDay = weekDay;
    
    [self setText:weekDay withExistingAttributesInLabel:_weekDayLabel];
}

- (void)setDay:(NSString *)day {
    
    _day = day;
    
    [self setText:day withExistingAttributesInLabel:_dayLabel];
}

- (void)setMonth:(NSString *)month {
    
    _month = month;
    
    [self setText:month withExistingAttributesInLabel:_monthLabel];
}

- (void)setText:(NSString *)text withExistingAttributesInLabel:(UILabel *)label {
    
    // Check label has existing text
    if ([label.attributedText length]) {
        
        // Extract attributes
        NSDictionary *attributes = [(NSAttributedString *)label.attributedText attributesAtIndex:0 effectiveRange:NULL];
        
        // Set new text with extracted attributes
        label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
        
    }
    
}

@end
