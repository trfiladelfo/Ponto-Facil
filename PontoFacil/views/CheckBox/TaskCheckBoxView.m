//
//  TaskCheckBoxView.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "TaskCheckBoxView.h"

@interface TaskCheckBoxView ()

@property (nonatomic, strong) UIImageView *checkImageView;
@property (nonatomic, strong) CALayer *circleLayer;

@end

@implementation TaskCheckBoxView

//static const NSInteger DEFAULT_MARGIN = 2;

- (UIImageView *)checkImageView {

    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [_checkImageView setImage:[UIImage imageNamed:@"check_icon"]];
        [self addSubview:_checkImageView];
    }
    
    return _checkImageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupViews];
    
    return self;
}

- (void)awakeFromNib {
    [self setupViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.circleLayer.frame = self.bounds;
    self.checkImageView.frame = self.bounds;
}   

- (void)setupViews
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    [self addTarget:self action:@selector(checkBoxViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.circleLayer = [CALayer layer];
    self.circleLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.circleLayer.cornerRadius = 5.0f;
    self.circleLayer.borderColor = [UIColor lightGrayColor].CGColor;
    self.circleLayer.borderWidth = 0.7f;
    self.circleLayer.frame = self.bounds;
    [self.layer addSublayer:self.circleLayer];
    
    [self updateViewState];
    
}

- (void)checkBoxViewClick:(id)sender {
    _isChecked = !_isChecked;

    [self updateViewState];
}

- (void)setIsChecked:(BOOL)isChecked {
    _isChecked = isChecked;
    
    [self updateViewState];
}

- (void)updateViewState {
    if (_isChecked) {
        [self.checkImageView setAlpha:1.0];
    }
    else
        [self.checkImageView setAlpha:0];
}

@end
