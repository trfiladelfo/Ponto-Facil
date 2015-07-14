//
//  Interval+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Interval.h"

typedef enum {
    kIntervalTypeWork = 0,
    kIntervalTypeBreak = 1,
    kIntervalTransit = 2
} IntervalCategoryType;

@interface Interval (Management)

@property (nonatomic) IntervalCategoryType intervalCategoryType;

+ (instancetype)insertIntervalWithStartDate:(NSDate *)startDate andfinishDate:(NSDate *)finishDate andIntervalCategoryType:(IntervalCategoryType)intervalCategoryType andPreviousInterval:(Interval *)previousInterval;

- (void)finish;


@end
