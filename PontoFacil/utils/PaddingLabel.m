//
//  PaddingLabel.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 17/12/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#define PADDING 5

#import "PaddingLabel.h"

@implementation PaddingLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, PADDING, 0, PADDING};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    return CGRectInset([self.attributedText boundingRectWithSize:CGSizeMake(999, 999)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                         context:nil], -PADDING, 0);
}

@end
