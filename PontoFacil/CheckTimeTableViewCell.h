//
//  CheckTimeTableViewCell.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckTimeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *eventTypeImageView;
@property (strong, nonatomic) IBOutlet UILabel *eventDescription;

@end
