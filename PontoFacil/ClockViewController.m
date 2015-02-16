//
//  ClockViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ClockViewController.h"
#import "CircleProgressView.h"

@interface ClockViewController ()

@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setup Clock
    self.clockView.status = @"Não iniciado";
    self.clockView.timeLimit = 60*8;
    self.clockView.elapsedTime = 10;
    [self.clockView setTintColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
