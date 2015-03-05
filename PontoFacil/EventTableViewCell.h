//
//  EventTableViewCell.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *eventTypeText;
@property (strong, nonatomic) IBOutlet UILabel *eventBalanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTimeLabel;

@end
