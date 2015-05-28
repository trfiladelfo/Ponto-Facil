//
//  NSUserDefaults+PontoFacil.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "NSUserDefaults+PontoFacil.h"

@implementation NSUserDefaults (PontoFacil)

- (BOOL)isLoaded {
    return [self objectForKey:@"isLoaded"] == nil ? false : [[self objectForKey:@"isLoaded"] boolValue];
}

- (void)setIsLoaded:(BOOL)isLoaded {
    [self setObject:[NSNumber numberWithBool:isLoaded] forKey:@"isLoaded"];
}

#pragma mark - Timetable

- (void)setWorkStartDate:(NSString *)workStartDate {
    [self setValue:workStartDate forKey:@"defaultStartDate"];
}

- (NSString *)workStartDate {
    return [self objectForKey:@"defaultStartDate"];
}

- (void)setWorkFinishDate:(NSString *)workFinishDate {
    [self setValue:workFinishDate forKey:@"defaultStopDate"];
}

- (NSString *)workFinishDate {
    return [self objectForKey:@"defaultStopDate"];
}

- (double)defaultWorkTime {
    return [self doubleForKey:@"defaultWorkTime"];
}

- (void)setDefaultWorkTime:(double)defaultWorkTime {
    [self setDouble:defaultWorkTime forKey:@"defaultWorkTime"];
}

- (void)setBreakStartDate:(NSString *)breakStartDate {
    [self setValue:breakStartDate forKey:@"defaultBreakStartDate"];
}

- (NSString *)breakStartDate {
    return [self objectForKey:@"defaultBreakStartDate"];
}

- (void)setBreakFinishDate:(NSString *)breakFinishDate {
    [self setValue:breakFinishDate forKey:@"defaultBreakStopDate"];
}

- (NSString *)breakFinishDate {
    return [self valueForKey:@"defaultBreakStopDate"];
}

- (double)defaultBreakTime {
    return [self doubleForKey:@"defaultBreakTime"];
}

- (void)setDefaultBreakTime:(double)defaultBreakTime {
    [self setDouble:defaultBreakTime forKey:@"defaultBreakTime"];
}

#pragma mark - Notifications

- (BOOL)workFinishNotification {
    return [self boolForKey:@"workTimeNotification"];
}

- (void)setWorkFinishNotification:(BOOL)workFinishNotification {
    [self setBool:workFinishNotification forKey:@"workTimeNotification"];
}

- (BOOL)breakFinishNotification {
    return [self boolForKey:@"breakTimeNotification"];
}

- (void)setBreakFinishNotification:(BOOL)breakFinishNotification {
    [self setBool:breakFinishNotification forKey:@"breakTimeNotification"];
}


#pragma mark - Time Balance Settings

- (BOOL)breakTimeRequired {
    return [self boolForKey:@"breakTimeRequired"];
}

- (void)setBreakTimeRequired:(BOOL)breakTimeRequired {
    [self setBool:breakTimeRequired forKey:@"breakTimeRequired"];
}

- (NSInteger)toleranceTime {
    return [self integerForKey:@"toleranceTime"];
}

- (void)setToleranceTime:(NSInteger)toleranceTime {
    [self setInteger:toleranceTime forKey:@"toleranceTime"];
}

@end
