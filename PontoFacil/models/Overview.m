//
//  Overview.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Overview.h"
#import "Event+Management.h"

@interface Overview ()

@property (nonatomic, strong) NSArray *eventArray;

@end

@implementation Overview

- (instancetype)initWithTitle:(NSString *)title andEventArray:(NSArray *)eventArray {
    self = [super init];
    if (self) {
        self.title = title;
        self.eventArray = eventArray;
        [self loadOverviewData];
    }
    return self;
}

- (void)loadOverviewData {
    
    if ([self.eventArray count] > 0) {
        
        NSPredicate *stopedEventsPredicate = [NSPredicate predicateWithFormat:@"session == nil || session.finishDate != nil"];
        
        NSArray *eventList = [self.eventArray filteredArrayUsingPredicate:stopedEventsPredicate];
        
        NSPredicate *sessionPredicate = [NSPredicate predicateWithFormat:@"eventType == 0 && session.finishDate != nil"];
        NSPredicate *holidayPredicate = [NSPredicate predicateWithFormat:@"eventType == 1"];
        NSPredicate *absencePredicate = [NSPredicate predicateWithFormat:@"isAbsence == %@", [NSNumber numberWithBool:true]];
        
        self.sessionCount = (int)[[eventList filteredArrayUsingPredicate:sessionPredicate] count];
        self.holidayCount = (int)[[eventList filteredArrayUsingPredicate:holidayPredicate] count];
        self.absentCount = (int)[[eventList filteredArrayUsingPredicate:absencePredicate] count];
        
        self.timeBalance = [[eventList valueForKeyPath:@"@sum.timeBalance"] doubleValue];
        self.workTime = [[[eventList filteredArrayUsingPredicate:sessionPredicate] valueForKeyPath:@"@sum.session.workTime"] doubleValue];
    }
}

@end
