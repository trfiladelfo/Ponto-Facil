//
//  EventTableViewCell.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 23/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Event+Management.h"
#import "Session+Management.h"
#import "MSWeekDateView.h"
#import "NSString+TimeInterval.h"

@interface EventTableViewCell ()

@property (nonatomic, retain) NSDateFormatter *formatter;

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"HH:mm"];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}

- (void)setEditing:(BOOL)editing {

    NSLog(@"cell editing");
}

- (void)configureForEvent:(Event *)event {
    
    self.weekDateView.backgroundColor = kPFColorWeekDateView;
    self.weekDateView.layer.cornerRadius = 5.0f;
    
    [self.formatter setDateFormat:@"EEE"];
    self.weekEstStartDateLabel.text = [self.formatter stringFromDate:event.estWorkStart];
    
    [self.formatter setDateFormat:@"dd"];
    self.dayEstStartDateLabel.text = [self.formatter stringFromDate:event.estWorkStart];
    
    [self.formatter setDateFormat:@"HH:mm"];
    
    if ([event.isAbsence boolValue])
        self.eventTypeLabel.text = @"Ausência";
    else {
        
        if ([event isHoliday]) {
            self.eventTypeLabel.text = @"Feriado";
        }
        else {
            self.eventTypeLabel.text = @"Sessão Normal";
        }
        
        Session *session = event.session;
        
        if (session) {
            self.startDateLabel.text = [self.formatter stringFromDate:session.startDate];
            self.finishDateLabel.text = [self.formatter stringFromDate:session.finishDate];
            self.intervalTimeLabel.text = [NSString stringWithTimeInterval:[session.breakTime doubleValue]];
            self.timeBalanceLabel.text = [NSString stringWithTimeInterval:session.timeBalance];
        }
    }
}

@end
