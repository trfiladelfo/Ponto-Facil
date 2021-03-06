//
//  IntervalTableViewHeaderView.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/04/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "IntervalTableViewHeaderView.h"

@interface IntervalTableViewHeaderView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation IntervalTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}


- (void) setupViews {

    //Note That You Must Change @”BNYSharedView’ With Whatever Your Nib Is Named
    [[NSBundle mainBundle] loadNibNamed:@"IntervalTableViewHeaderView" owner:self options:nil];
    
    [self addSubview: self.contentView];
    
    [self.estimatedWorkView setBackgroundColor:kPFColorStatusLabelShadow];
    [self.workView setBackgroundColor:kPFColorStatusLabelShadow];
    [self.timeOutView setBackgroundColor:kPFColorStatusLabelShadow];
    [self.balanceView setBackgroundColor:kPFColorStatusLabelShadow];
    
    [self.estimatedWorkView.layer setCornerRadius:5.0f];
    [self.workView.layer setCornerRadius:5.0f];
    [self.timeOutView.layer setCornerRadius:5.0f];
    [self.balanceView.layer setCornerRadius:5.0f];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
}

@end
