//
//  OverviewViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 17/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "JBBaseChartViewController.h"

@interface OverviewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *weekDayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekEndDayCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *refDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *sessionCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *absentCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *holidayCountLabel;

@end
