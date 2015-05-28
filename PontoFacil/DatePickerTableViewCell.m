//
//  DatePickerTableViewCell.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "DatePickerTableViewCell.h"
#import <UIKit/UIKit.h>

@interface DatePickerTableViewCell()

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.datePicker.datePickerMode = self.mode;
    self.date = [NSDate date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDate:(NSDate *)date {

    [self.datePicker setDate:date];
}

- (IBAction)datePickerChanged:(id)sender {
    [self.delegate pickerNewDate:self.datePicker.date];
}

@end
