//
//  Interval+Management.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Interval+Management.h"
#import "Store.h"
#import "NSUserDefaults+PontoFacil.h"

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


- (void)setIntervalStart:(NSDate *)intervalStart {
    
    //Atualiza intervalo anterior se a data
    if (self.previousInterval) {
        if ([self.previousInterval.intervalFinish compare:intervalStart] == NSOrderedDescending) {
            self.previousInterval.intervalFinish = intervalStart;
        }
    }
    
    if ([self.intervalFinish compare:intervalStart] == NSOrderedAscending) {
        self.intervalFinish = intervalStart;
    }
    
    [self willChangeValueForKey:@"intervalStart"];
    [self setPrimitiveValue:intervalStart forKey:@"intervalStart"];
    [self didChangeValueForKey:@"intervalStart"];
}

- (void)setIntervalFinish:(NSDate *)intervalFinish {

    
    if (self.nextInterval) {
        if ([self.nextInterval.intervalStart compare:intervalFinish] == NSOrderedAscending) {
            self.nextInterval.intervalStart = intervalFinish;
        }
    }
    
    if ([self.intervalStart compare:intervalFinish] == NSOrderedDescending) {
        self.intervalStart = intervalFinish;
    }
    
    [self willChangeValueForKey:@"intervalFinish"];
    [self setPrimitiveValue:intervalFinish forKey:@"intervalFinish"];
    [self didChangeValueForKey:@"intervalFinish"];
}

- (void)finish {
    NSDate *now = [NSDate date];
    self.intervalFinish = now;
}

+ (instancetype)insertIntervalWithStartDate:(NSDate *)startDate andfinishDate:(NSDate *)finishDate andIntervalCategoryType:(IntervalCategoryType)intervalCategoryType andPreviousInterval:(Interval *)previousInterval;
{
    Interval *interval = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    
    interval.intervalStart = startDate;
    interval.intervalFinish = finishDate;
    interval.intervalCategoryType = intervalCategoryType;
    interval.previousInterval = previousInterval;
    
    return interval;
}

+ (NSArray *)defaultIntervalListArray {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDefaultDate:[NSDate date]];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [formatter setDateFormat:@"HH:mm"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *workStartDate = [formatter dateFromString:[defaults workStartDate]];
    NSDate *workFinishDate = [formatter dateFromString:[defaults workFinishDate]];
    NSDate *breakStartDate = [formatter dateFromString:[defaults breakStartDate]];
    NSDate *breakFinishDate = [formatter dateFromString:[defaults breakFinishDate]];
    
    Interval *interval1 = [Interval insertIntervalWithStartDate:workStartDate andfinishDate:breakStartDate andIntervalCategoryType:kIntervalTypeWork andPreviousInterval:nil];
    Interval *interval2 = [Interval insertIntervalWithStartDate:breakStartDate andfinishDate:breakFinishDate andIntervalCategoryType:kIntervalTypeBreak andPreviousInterval:interval1];
    Interval *interval3 = [Interval insertIntervalWithStartDate:breakFinishDate andfinishDate:workFinishDate andIntervalCategoryType:kIntervalTypeWork andPreviousInterval:nil];
    
    NSArray *intervalList = [NSArray arrayWithObjects:interval1, interval2, interval3, nil];
    
    return intervalList;
}

@end
