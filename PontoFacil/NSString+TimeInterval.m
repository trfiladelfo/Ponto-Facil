//
//  NSString+TimeInterval.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/04/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "NSString+TimeInterval.h"

@implementation NSString (TimeInterval)

+ (instancetype)stringWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSString *signal = @"";
    if (timeInterval < 0) {
        signal = @"-";
    }
    
    NSInteger ti = (NSInteger)ABS(timeInterval);
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    if (timeInterval >= 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
    }
    else
        return [NSString stringWithFormat:@"(%02ld:%02ld)", (long)hours, (long)minutes];
    
    
}

@end
