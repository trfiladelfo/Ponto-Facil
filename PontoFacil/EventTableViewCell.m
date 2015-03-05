//
//  EventTableViewCell.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventTableViewCell.h"

@interface EventTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *eventTypeLabel;

@end

@implementation EventTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setEventTypeText:(NSString *)eventTypeText {

    _eventTypeText = eventTypeText;
    
    NSMutableAttributedString *messageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", eventTypeText]];
        
    [messageString addAttributes:@{
            NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14],
            NSForegroundColorAttributeName: [UIColor blueColor]
    }
    range:NSMakeRange(0, eventTypeText.length)];
        
    [self.eventTypeLabel setAttributedText:messageString];
}

@end
