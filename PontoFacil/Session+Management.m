//
//  Session+Management.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Session+Management.h"
#import "Event+Management.h"
#import "Interval+Management.h"
#import "Store.h"
#import "NSDate-Utilities.h"

static NSString *entityName = @"Session";

@implementation Session (Management)


- (SessionStateCategory)sessionStateCategory {
    return (SessionStateCategory)[[self sessionState] intValue];
}

- (void)setSessionStateCategory:(SessionStateCategory)sessionStateCategory {
    [self setSessionState:[NSNumber numberWithInt:sessionStateCategory]];
}


- (NSDate *)calculateEstimatedFinishDate: (BOOL)adjustBreakTime {
    
    //Calcula a data prevista de saída
    NSDate *estFinishDateTime = [self.startDate dateByAddingTimeInterval:[self.event.estWorkTime doubleValue]];
    
    if  ([self.breakTime doubleValue] > 0) {
        estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.breakTime doubleValue]];
    }
    else {
        if (adjustBreakTime) {
            estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.event.estBreakTime doubleValue]];
        }
    }
    
    return estFinishDateTime;
}

- (NSNumber *)calculateBreakTime: (BOOL)inProgress {

    if ([self.intervalList count] > 0) {
        
        NSPredicate *intervalTypePredicate = [NSPredicate predicateWithFormat:@"intervalType == %@", [NSNumber numberWithInt:kIntervalTypeBreak]];
        
        NSPredicate *finishDatePredicate = [NSPredicate predicateWithFormat:@"intervalFinish != nil"];
        
        NSArray *predicateArray;
        
        if (!inProgress) {
            predicateArray = [NSArray arrayWithObjects:intervalTypePredicate, finishDatePredicate, nil];
        }
        else
            predicateArray = [NSArray arrayWithObjects:intervalTypePredicate, nil];
        
        
        NSCompoundPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
        
        NSSet *breakIntervals = [self.intervalList filteredSetUsingPredicate:compoundPredicate];
        
        if ([breakIntervals count] > 0) {
            return [breakIntervals valueForKeyPath:@"@sum.intervalTime"];
        }
        else
            return 0;
    }
    else
        return 0;
}

#pragma mark - Core Data Methods

+ (instancetype)startSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakStartDate:(NSDate *)estBreakStartDate andEstBreakFinishDate:(NSDate *)estBreakFinishDate {

    Event *event = [Event insertEventWithEstWorkStart:estStartDate andEstWorkFinish:estFinishDate andEstBreakStart:estBreakStartDate andEstBreakFinish:estBreakFinishDate andIsManual:false andEventTypeCategory:kEventTypeNormal andEventDescription:nil];
    
    NSDate *now = [NSDate date];
    
    Session *session = [self insertSessionWithEvent:event andStartDate:now];
    
    [session addIntervalListObject:[Interval insertIntervalWithStartDate:now andfinishDate:nil andIntervalCategoryType:kIntervalTypeWork]];
    
    return session;
}

+ (instancetype)insertSessionWithEvent:(Event *)event andStartDate:(NSDate *)startDate {

    return [self insertSessionWithEvent:event andSessionCategory:kSessionStateStart andStartDate:startDate andSessionDescription:@""];
}


+ (instancetype)insertSessionWithEvent:(Event *)event andStartDate:(NSDate *)startDate andFinishDate:(NSDate *)finishDate andSessionDescription:(NSString *)sessionDescription {
    
    Session *session = [self insertSessionWithEvent:event andSessionCategory:kSessionStateStop andStartDate:startDate andSessionDescription:sessionDescription];
    session.finishDate = finishDate;
    
    return session;
}

+ (instancetype)insertSessionWithEvent:(Event *)event andSessionCategory:(SessionStateCategory)sessionCategory andStartDate:(NSDate *)startDate andSessionDescription:(NSString *)sessionDescription {

    Session *session = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    session.event = event;
    session.sessionStateCategory = sessionCategory;
    session.startDate = startDate;
    session.isChecked = [NSNumber numberWithBool:false];
    session.sessionDescription = sessionDescription;
    
    return session;
}

+ (Session *)sessionFromURI:(NSData *)URIData {

    if (URIData) {
        NSURL *sessionIDURI = [NSKeyedUnarchiver unarchiveObjectWithData:URIData];
        
        if (sessionIDURI) {
            
            NSManagedObjectID *sessionID = [[[Store defaultManagedObjectContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:sessionIDURI];
            
            if (sessionID) {
                NSError *error = nil;
                return (Session *)[[Store defaultManagedObjectContext]
                                           existingObjectWithID:sessionID
                                           error:&error];
            }
        }
    }
    
    return nil;
}

- (Interval *)activeInterval {
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"intervalStart" ascending:NO]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"intervalFinish = nil"];
    
    return [[[self.intervalList filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors] firstObject];
}

- (void)startInterval:(IntervalCategoryType)intervalType {

    if (!self.activeInterval) {
        
        NSDate *now = [NSDate date];
        
        [self addIntervalListObject:[Interval insertIntervalWithStartDate:now andfinishDate:nil andIntervalCategoryType:intervalType]];
    }
}

- (void)finishActiveInterval {
    
    if (self.activeInterval) {
        
        NSDate *now = [NSDate date];
        self.activeInterval.intervalFinish = now;
    }
}

#pragma mark - Session Attributes

- (NSNumber *)workTime {
    
    if ([self.intervalList count] > 0) {
        
        NSSet *workIntervals = [self.intervalList filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"intervalType == %@", [NSNumber numberWithInt:kIntervalTypeWork]]];
        
        if ([workIntervals count] > 0) {
            return [workIntervals valueForKeyPath:@"@sum.intervalTime"];
        }
        else
            return 0;
    }
    else
        return 0;
}

- (NSNumber *)breakTimeInProgress {
    return [self calculateBreakTime:true];
}

- (NSNumber *)breakTime {
    return [self calculateBreakTime:false];
}

- (NSTimeInterval)timeBalance {
    
    NSTimeInterval _balance = 0;
    
    _balance = [self.workTime doubleValue] - [self.event.estWorkTime doubleValue];
    
    return _balance;
}

- (NSString *)timeBalanceToString {


    NSString *balanceSignal;
    
    if ([self.event.estWorkTime doubleValue] > [self.workTime doubleValue]) {
        balanceSignal = @"-";
    }
    else {
        balanceSignal = @"+";
    }
    
    NSInteger ti = (NSInteger) ABS(self.timeBalance);
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%@ %02ld:%02ld", balanceSignal, (long)hours, (long)minutes];
}

/*
- (NSTimeInterval)adjustedTimeBalance {
    
    NSTimeInterval _balance = 0;
    
    _balance = [self.workAdjustedTime doubleValue] - [self.estWorkTime doubleValue];
    
    return _balance;
}
*/

- (CGFloat)progress {
    
    if ([self.event.estWorkTime doubleValue] > 0) {
        
        if ([self.workTime doubleValue] > 0) {
            return ([self.workTime doubleValue] / [self.event.estWorkTime doubleValue]);
        }
        else
            return 0;
    }
    else
        return 0;
}

- (NSArray *)dateSortedIntervalList {

    NSArray *intervalListArray = [self.intervalList allObjects];
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"intervalStart" ascending:NO];
    NSArray *descriptors=[NSArray arrayWithObject: descriptor];
    NSArray *sortedArray =[intervalListArray sortedArrayUsingDescriptors:descriptors];
    
    return sortedArray;
}

@end
