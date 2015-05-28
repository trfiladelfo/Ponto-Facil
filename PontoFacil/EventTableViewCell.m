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

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureForEvent:(Event *)event {
    
    self.weekDateView.date = event.estWorkStart;
    
    if (event.eventTypeCategory == kEventTypeNormal) {
        
        self.eventTypeLabel.text = @"Sessão Normal";
        Session *session = event.session;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        
        self.startDateLabel.text = [dateFormatter stringFromDate:session.startDate];
        self.finishDateLabel.text = [dateFormatter stringFromDate:session.finishDate];
        self.intervalTimeLabel.text = @"01:00";
        self.timeBalanceLabel.text = session.timeBalanceToString;
    }
    else if (event.eventTypeCategory == kEventTypeHoliday)
        self.eventTypeLabel.text = @"Feriado";
    else
        self.eventTypeLabel.text = @"Outros";
}

@end
