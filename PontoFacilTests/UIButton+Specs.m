//
//  UIButton+Specs.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 06/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "UIButton+Specs.h"

@implementation UIButton (Specs)

- (void)specsSimulateTap {
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
