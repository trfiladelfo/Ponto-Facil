//
//  Interval+Management.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Interval+Management.h"
#import "Store.h"

static NSString *entityName = @"Interval";

@implementation Interval (Management)

-(IntervalCategoryType)intervalCategoryType {
    return (IntervalCategoryType)[[self intervalType] intValue];
}

-(void)setIntervalCategoryType:(IntervalCategoryType)intervalCategoryType {
    [self setIntervalType:[NSNumber numberWithInt:intervalCategoryType]];
}

- (NSTimeInterval)intervalTime {
    
    if (self.intervalFinish) {
        return [self.intervalFinish timeIntervalSinceDate: self.intervalStart];
    }
    else
        return [[NSDate date] timeIntervalSinceDate:self.intervalStart];
    
}


+ (instancetype)insertIntervalWithStartDate:(NSDate *)startDate andfinishDate:(NSDate *)finishDate andIntervalCategoryType:(IntervalCategoryType)intervalCategoryType
{
    Interval *interval = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    
    interval.intervalStart = startDate;
    interval.intervalFinish = finishDate;
    interval.intervalCategoryType = intervalCategoryType;
    
    return interval;
}

@end
