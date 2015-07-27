//
//  AcessoryCircularButtonView.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 13/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "AcessoryCircularButtonView.h"

@interface AcessoryCircularButtonView ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@end

@implementation AcessoryCircularButtonView

-(void)awakeFromNib {
    //Note That You Must Change @”BNYSharedView’ With Whatever Your Nib Is Named
    [[NSBundle mainBundle] loadNibNamed:@"AcessoryCircularButtonView" owner:self options:nil];
    self.backgroundColor = [UIColor clearColor];
    
    //Add Bezier Path to View
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.path = [self drawPathWithArcCenter];
    self.circleLayer.fillColor = [UIColor whiteColor].CGColor;
    self.circleLayer.strokeColor = [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f].CGColor;
    self.circleLayer.lineWidth = 2;
    [self.contentView.layer addSublayer:self.circleLayer];
    
    [self addSubview: self.contentView]; 
}

- (CGPathRef)drawPathWithArcCenter {
    
    CGFloat position_y = self.contentView.frame.size.height/2;
    CGFloat position_x = self.contentView.frame.size.width/2; // Assuming that width == height
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y
                                      startAngle:(-M_PI/2)
                                        endAngle:(3*M_PI/2)
                                       clockwise:YES].CGPath;
}

/*
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.contentView.frame = self.bounds;
    self.circleLayer.path = [self drawPathWithArcCenter];
    
    [self.contentView.layer layoutSublayers];
}*/

@end
