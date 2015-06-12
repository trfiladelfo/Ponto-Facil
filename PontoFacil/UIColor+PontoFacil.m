//
//  UIColor+PontoFacil.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 19/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "UIColor+PontoFacil.h"

@implementation UIColor (PontoFacil)

+ (UIColor *)navigationHeaderColor {

    return [UIColor colorWithRed:22/255.0 green:98/255.0 blue:128/255.0 alpha:1.0f];
}

+ (UIColor *)navigationHeaderTitleColor {
    return [UIColor whiteColor];
}

+ (UIColor *)eventCellTitleColor {
    return [UIColor blueColor];
}

+ (UIColor *)weekDateViewColor {
    return [UIColor colorWithRed:22/255.0 green:98/255.0 blue:128/255.0 alpha:1.0f];
}

+ (UIColor *)clockViewPausedColor {
    return [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0f];
}

+ (UIColor *)clockViewInProgressColor {
    return [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
}

+ (UIColor *)clockViewStopedColor {
    return [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
}

+ (UIColor *)clockViewNotStartedColor {
    return [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
}

@end
