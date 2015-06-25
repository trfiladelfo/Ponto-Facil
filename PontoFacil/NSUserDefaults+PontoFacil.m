//
//  NSUserDefaults+PontoFacil.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "NSUserDefaults+PontoFacil.h"
#import "NSDate-Utilities.h"

@implementation NSUserDefaults (PontoFacil)

+ (void)initialize {
    
    NSString *defaultsPath = [[NSBundle mainBundle] pathForResource:@"UserDefaults"
                                                             ofType:@"plist"];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults registerDefaults:appDefaults];
    
    [defaults setIsLoaded:true];
    
}

- (BOOL)isLoaded {
    return [self objectForKey:@"isLoaded"] == nil ? false : [[self objectForKey:@"isLoaded"] boolValue];
}

- (void)setIsLoaded:(BOOL)isLoaded {
    [self setObject:[NSNumber numberWithBool:isLoaded] forKey:@"isLoaded"];
}

#pragma mark - Timetable

- (void)setWorkStartDate:(NSString *)workStartDate {
    [self setValue:workStartDate forKey:@"workStartDate"];
}

- (NSString *)workStartDate {
    return [self objectForKey:@"workStartDate"];
}

- (void)setWorkFinishDate:(NSString *)workFinishDate {
    [self setValue:workFinishDate forKey:@"workFinishDate"];
}

- (NSString *)workFinishDate {
    return [self stringForKey:@"workFinishDate"];
}

- (double)defaultWorkTime {
    if (self.isLoaded) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [formatter setDefaultDate:[NSDate date]];
        
        NSDate *workStartDate = [formatter dateFromString:[self workStartDate]];
        NSDate *workFinishDate = [formatter dateFromString:[self workFinishDate]];
        
        return [workFinishDate timeIntervalSinceDate:workStartDate] - self.defaultBreakTime;
    }
    else {
        return 0;
    };
}

- (void)setBreakStartDate:(NSString *)breakStartDate {
    [self setValue:breakStartDate forKey:@"breakStartDate"];
}

- (NSString *)breakStartDate {
    return [self objectForKey:@"breakStartDate"];
}

- (void)setBreakFinishDate:(NSString *)breakFinishDate {
    [self setValue:breakFinishDate forKey:@"breakFinishDate"];
}

- (NSString *)breakFinishDate {
    return [self valueForKey:@"breakFinishDate"];
}

- (double)defaultBreakTime {
    if (self.isLoaded) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        [formatter setDefaultDate:[NSDate date]];
        
        NSDate *breakStartDate = [formatter dateFromString:[self breakStartDate]];
        NSDate *breakFinishDate = [formatter dateFromString:[self breakFinishDate]];
        
        return [breakFinishDate timeIntervalSinceDate:breakStartDate];
    }
    else {
        return 0;
    };
}


#pragma mark - Notifications

- (BOOL)workFinishNotification {
    return [self boolForKey:@"workFinishNotification"];
}

- (void)setWorkFinishNotification:(BOOL)workFinishNotification {
    [self setBool:workFinishNotification forKey:@"workFinishNotification"];
}

- (BOOL)breakFinishNotification {
    return [self boolForKey:@"breakFinishNotification"];
}

- (void)setBreakFinishNotification:(BOOL)breakFinishNotification {
    [self setBool:breakFinishNotification forKey:@"breakFinishNotification"];
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

#pragma mark - active session in Clock View

- (NSData *)activeSessionID {
    return [self dataForKey:@"activeSessionID"];
}

- (void)setActiveSessionID:(NSData *)activeSessionID {
    [self setValue:activeSessionID forKey:@"activeSessionID"];
}

@end
