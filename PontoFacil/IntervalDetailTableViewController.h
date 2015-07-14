//
//  IntervalDetailTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Interval;

@interface IntervalDetailTableViewController : UITableViewController

@property (nonatomic, strong) Interval *interval;

@end
