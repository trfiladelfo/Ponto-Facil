//
//  CircularButtonView.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "CircularButtonView.h"

@interface CircularButtonView ()

@property (strong, nonatomic) IBOutlet UIControl *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation CircularButtonView

-(void)awakeFromNib {
    //Note That You Must Change @”BNYSharedView’ With Whatever Your Nib Is Named
    [[NSBundle mainBundle] loadNibNamed:@"CircularButtonView" owner:self options:nil];
    self.backgroundColor = [UIColor clearColor];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
    [self.contentView.layer setMasksToBounds:YES];
    self.contentView.layer.cornerRadius = 35.0f;
    
    [self.contentView addTarget:self action:@selector(animateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview: self.contentView];
    
}

- (IBAction)animateButton:(id)sender {

    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse
                     animations:^{
                         
                         CGAffineTransform scaleTrans =
                         CGAffineTransformMakeScale(1.2, 1.2);
                         self.transform = scaleTrans;
                     } completion:^(BOOL finished) {
                         //
                         CGAffineTransform inverse = CGAffineTransformInvert(CGAffineTransformMakeTranslation(2.0, 2.0));
                         self.transform = inverse;
                     }];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
}


@end
