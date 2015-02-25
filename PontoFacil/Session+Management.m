//
//  Session+Management.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Session+Management.h"
#import "Event+Management.h"
#import "Store.h"


@implementation Session (Management)

#pragma mark - Private Methods

+ (NSString*)entityName
{
    return @"Session";
}

- (SessionState)sessionState {
    return (SessionState)[[self state] intValue];
}

- (void)setSessionState:(SessionState)sessionState {
    [self setState:[NSNumber numberWithInt:sessionState]];
}

- (NSString *)monthYearSessionDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:formatString];
    
    return [dateFormatter stringFromDate: self.workStartDate];
}


- (NSTimeInterval)calculateWorkTime {
    NSTimeInterval _calculatedWorkTime = [self calculateEventSummary:kEventTypeWork];
    self.workTime = [NSNumber numberWithDouble:_calculatedWorkTime];
    return _calculatedWorkTime;
}

- (NSTimeInterval)calculateBreakTime {
    NSTimeInterval _calculatedBreakTime = [self calculateEventSummary:kEventTypeBreak];
    self.workBreakTime = [NSNumber numberWithDouble:_calculatedBreakTime];
    return _calculatedBreakTime;
}

- (NSTimeInterval)calculateEventSummary: (EventType)eventType {
    NSTimeInterval eventTime = 0;
    
    //Calcula o tempo total trabalhado sem descontos
    for (Event *event in self.eventList) {
        if (event.eventType == eventType) {
            eventTime += event.eventInterval;
        }
    }
    
    return eventTime;
}

- (NSDate *)calculateEstimatedFinishDate: (BOOL)adjustBreakTime {
    
    //Calcula a data prevista de saída
    NSDate *estFinishDateTime = [self.workStartDate dateByAddingTimeInterval:[self.estWorkTime doubleValue]];
    
    if  ([self.workBreakTime doubleValue] > 0) {
        estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.workBreakTime doubleValue]];
    }
    else {
        if (adjustBreakTime) {
            estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.estBreakTime doubleValue]];
        }
    }
    
    return estFinishDateTime;
}

#pragma mark - Core Data Methods

+ (instancetype)insertSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakTime:(NSNumber *)estBreakTime andIsManual:(BOOL)isManual andSessionState:(SessionState)sessionState andWorkStartDate:(NSDate *)workStartDate
{
    Session *session = [NSEntityDescription insertNewObjectForEntityForName:self.entityName
                                               inManagedObjectContext:Store.defaultManagedObjectContext];
    
    session.estStartDate = estStartDate;
    session.estFinishDate = estFinishDate;
    session.estBreakTime = estBreakTime;
    session.isAbsence = [NSNumber numberWithBool:false];
    session.isManual = [NSNumber numberWithBool:isManual];
    session.sessionState = sessionState;
    session.workStartDate = workStartDate;


    return session;
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:[self.class entityName]];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"isFinished" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
    
    [request setFetchLimit:50];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"monthYearSessionDate" cacheName:nil];
}

#pragma mark - Session Attributes

- (NSNumber *)estWorkTime {
    
    NSTimeInterval _estWorkTime = [self.estFinishDate timeIntervalSinceDate:self.estStartDate] - [self.estBreakTime doubleValue];
    
    return [NSNumber numberWithDouble:_estWorkTime];
}

- (NSNumber *)workTime {
    
    NSNumber *_workTime = [self primitiveValueForKey:@"workTime"];
    
    if ((self.sessionState == kSessionStateStop) && ([_workTime doubleValue] > 0)) {
        return _workTime;
    }
    else
    {
        NSTimeInterval workTime = [self calculateWorkTime];
        
        return [NSNumber numberWithDouble:workTime];
    }
}

- (NSNumber *)breakTime {
    
    NSNumber *_breakTime = [self primitiveValueForKey:@"breakTime"];
    
    if ((self.sessionState == kSessionStateStop) && ([_breakTime doubleValue] > 0)) {
        return _breakTime;
    }
    else
    {
        NSTimeInterval breakTime = [self calculateBreakTime];
        
        return [NSNumber numberWithDouble:breakTime];
    }
}

- (NSTimeInterval)timeBalance {
    
    NSTimeInterval _balance = 0;
    
    _balance = [self.workTime doubleValue] - [self.estWorkTime doubleValue];
    
    return _balance;
}

- (NSTimeInterval)adjustedTimeBalance {
    
    NSTimeInterval _balance = 0;
    
    _balance = [self.workAdjustedTime doubleValue] - [self.estWorkTime doubleValue];
    
    return _balance;
}


- (CGFloat)progress {
    
    if ([self.estWorkTime doubleValue] > 0) {
        
        if ([self.workTime doubleValue] > 0) {
            return ([self.workTime doubleValue] / [self.estWorkTime doubleValue]);
        }
        else
            return 0;
    }
    else
        return 0;
}

- (Event *)activeEvent {
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stopDate = nil"];
    
    return [[[self.eventList filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors] firstObject];
}

@end
