//
//  IntervalTableViewHeaderView.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/04/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntervalTableViewHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *esrtimatedWorkTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeOutLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeBalanceLabel;

@property (weak, nonatomic) IBOutlet UIView *estimatedWorkView;
@property (weak, nonatomic) IBOutlet UIView *workView;
@property (weak, nonatomic) IBOutlet UIView *timeOutView;
@property (weak, nonatomic) IBOutlet UIView *balanceView;


@end
