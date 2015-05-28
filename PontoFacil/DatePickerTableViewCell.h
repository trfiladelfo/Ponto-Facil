//
//  DatePickerTableViewCell.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerTableViewCellDelegate

- (void)pickerNewDate:(NSDate *)date;

@end

@interface DatePickerTableViewCell : UITableViewCell

@property (nonatomic, assign) NSDate *date;
@property (nonatomic, assign) UIDatePickerMode mode;
@property (nonatomic, weak) id<DatePickerTableViewCellDelegate> delegate;

@end
