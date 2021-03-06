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
#import "NSUserDefaults+PontoFacil.h"

static NSString *entityName = @"Session";

typedef enum {
    kSessionStateStart = 0,
    kSessionStateStop = 1,
    kSessionStatePaused = 2
} SessionStateCategory;

@interface Session()

@property (nonatomic) SessionStateCategory sessionStateCategory;

@end

@implementation Session (Management)

- (instancetype)init {
    
    return [self initWithEvent:[[Event alloc] initEventWithDate:[NSDate date]]];
}

- (instancetype)initWithEvent:(Event *)event {
    
    Session *_session = [self initWithEntity:[self entity] insertIntoManagedObjectContext:[Store defaultManagedObjectContext]];
    _session.event = event;
    
    return _session;
}

- (instancetype)initSessionFromUri:(NSData *)URIData {

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

- (NSEntityDescription *)entity {
    
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:[Store defaultManagedObjectContext]];
}

#pragma mark - Session Attributes

- (SessionStateCategory)sessionStateCategory {
    return (SessionStateCategory)[[self sessionState] intValue];
}

- (void)setSessionStateCategory:(SessionStateCategory)sessionStateCategory {
    [self setSessionState:[NSNumber numberWithInt:sessionStateCategory]];
}

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

- (NSArray *)ascendingIntervalList {
    return [self orderedIntervalList:true];
}

- (NSArray *)descendingIntervalList {
    return [self orderedIntervalList:false];
}

- (NSArray *)orderedIntervalList:(BOOL)ascending {
    
    if (self.intervalList) {
        NSArray *intervalListArray = [self.intervalList allObjects];
        
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"intervalStart" ascending:ascending];
        NSArray *descriptors=[NSArray arrayWithObject: descriptor];
        NSArray *sortedArray =[intervalListArray sortedArrayUsingDescriptors:descriptors];
        
        return sortedArray;
    }
    else
        return nil;
}

#pragma mark - Private Methods

- (NSDate *)calculateEstimatedWorkFinishDate: (BOOL)adjustBreakTime {
    
    //Calcula a data prevista de saída
    NSDate *estFinishDateTime = [self.startDate dateByAddingTimeInterval:[self.event.estWorkTime doubleValue]];
    
    if (adjustBreakTime) {
        if  ([self.breakTimeInProgress doubleValue] > [self.event.estBreakTime doubleValue]) {
            estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.breakTimeInProgress doubleValue]];
        }
        else {
            estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.event.estBreakTime doubleValue]];
        }
    }
    else {
        estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.breakTimeInProgress doubleValue]];
    }
    
    return estFinishDateTime;
}

- (NSDate *)calculateEstimatedBreakFinishDate {
    
    NSDate *estFinishDate = [NSDate date];
    
    if ([self.event.estBreakTime doubleValue] > [self.breakTimeInProgress doubleValue]) {
        return [[estFinishDate dateByAddingTimeInterval:[self.event.estBreakTime doubleValue]] dateByAddingTimeInterval:-[self.breakTimeInProgress doubleValue]];
    }
    else
        return estFinishDate;
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

- (Interval *)activeInterval {
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"intervalStart" ascending:NO]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"intervalFinish = nil"];
    
    return [[[self.intervalList filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors] firstObject];
}

- (void)startInterval:(IntervalCategoryType)intervalType {
    
    Interval *previousInterval = nil;
    
    if (self.activeInterval) {
        previousInterval = self.activeInterval;
        [self.activeInterval finish];
    }
    
    NSDate *now = [NSDate date];
        
    [self addIntervalListObject:[Interval insertIntervalWithStartDate:now andfinishDate:nil andIntervalCategoryType:intervalType andPreviousInterval:previousInterval]];
}

#pragma mark - Clock Operations

- (void)start {
    self.startDate = [NSDate date];
    self.currentEstWorkFinishDate = [self calculateEstimatedWorkFinishDate:[[NSUserDefaults standardUserDefaults] breakTimeRequired]];
    [self startInterval:kIntervalTypeWork];
    [self setSessionStateCategory:kSessionStateStart];
}

- (void)pause {
    self.currentEstBreakFinishDate = [self calculateEstimatedBreakFinishDate];
    [self startInterval:kIntervalTypeBreak];
    [self setSessionStateCategory:kSessionStatePaused];
}

- (void)resume {
    self.currentEstWorkFinishDate = [self calculateEstimatedWorkFinishDate:[[NSUserDefaults standardUserDefaults] breakTimeRequired]];
    [self startInterval:kIntervalTypeWork];
    [self setSessionStateCategory:kSessionStateStart];
}

- (void)stop {
    [self.activeInterval finish];
    self.finishDate = [NSDate date];
    [self setSessionStateCategory:kSessionStateStop];
}

- (void)update {

    self.startDate = [self.intervalList valueForKeyPath:@"@min.intervalStart"];
    
    if ([self isStarted])
    {
        self.currentEstWorkFinishDate = [self calculateEstimatedWorkFinishDate:true];
    }
    else if ([self isPaused])
    {
        self.currentEstBreakFinishDate = [self calculateEstimatedBreakFinishDate];
    }
    if ([self isStoped]) {
        self.finishDate = [self.intervalList valueForKeyPath:@"@max.intervalFinish"];
    }
}

#pragma mark - Helpers

- (BOOL)isStarted {
    return self.sessionStateCategory == kSessionStateStart;
}

- (BOOL)isPaused {
    return self.sessionStateCategory == kSessionStatePaused;
}

- (BOOL)isStoped {
    return self.sessionStateCategory == kSessionStateStop;
}

- (BOOL)haveTimeUntilEstimatedWorkFinish {
    if (self.isStarted) {
        return [self.workTime doubleValue] < [self.event.estWorkTime doubleValue];
    }
    
    return false;
}

- (BOOL)haveTimeUntilEstimatedBreakFinish {
    if (self.isPaused) {
        return [self.breakTimeInProgress doubleValue] < [self.event.estBreakTime doubleValue];
    }
    
    return false;
}

@end
