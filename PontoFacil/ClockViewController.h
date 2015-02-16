//
//  ClockViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleProgressView;

@interface ClockViewController : UIViewController

@property (strong, nonatomic) IBOutlet CircleProgressView *clockView;

@property NSUInteger pageIndex;
@property NSString *titleText;

@end
