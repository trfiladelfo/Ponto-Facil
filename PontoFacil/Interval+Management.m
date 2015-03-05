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
    
    if (self.finishDate) {
        return [self.finishDate timeIntervalSinceDate: self.startDate];
    }
    else
        return [[NSDate date] timeIntervalSinceDate:self.startDate];
    
}


+ (instancetype)insertIntervalWithStartDate:(NSDate *)startDate andfinishDate:(NSDate *)finishDate andIntervalCategoryType:(IntervalCategoryType)intervalCategoryType
{
    Interval *interval = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    
    interval.startDate = startDate;
    interval.finishDate = finishDate;
    interval.intervalCategoryType = intervalCategoryType;
    
    return interval;
}

@end
