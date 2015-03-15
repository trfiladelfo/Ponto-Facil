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


- (SessionStateType)sessionStateType {
    return (SessionStateType)[[self sessionType] intValue];
}

- (void)setSessionStateType:(SessionStateType)sessionStateType {
    [self setSessionType:[NSNumber numberWithInt:sessionStateType]];
}


- (NSDate *)calculateEstimatedFinishDate: (BOOL)adjustBreakTime {
    
    //Calcula a data prevista de saída
    NSDate *estFinishDateTime = [self.startDate dateByAddingTimeInterval:[self.estWorkTime doubleValue]];
    
    if  ([self.breakTime doubleValue] > 0) {
        estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.breakTime doubleValue]];
    }
    else {
        if (adjustBreakTime) {
            estFinishDateTime = [estFinishDateTime dateByAddingTimeInterval:[self.estBreakTime doubleValue]];
        }
    }
    
    return estFinishDateTime;
}

- (NSNumber *)calculateBreakTime: (BOOL)inProgress {

    if ([self.intervalList count] > 0) {
        
        NSPredicate *intervalTypePredicate = [NSPredicate predicateWithFormat:@"intervalType == %@", [NSNumber numberWithInt:kIntervalTypeBreak]];
        
        NSPredicate *finishDatePredicate = [NSPredicate predicateWithFormat:@"finishDate != nil"];
        
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

+ (instancetype)insertSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakTime:(NSNumber *)estBreakTime andIsManual:(BOOL)isManual andSessionState:(SessionStateType)sessionStateType andStartDate:(NSDate *)startDate
{
    Session *session = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    
    session.estStartDate = estStartDate;
    session.estFinishDate = estFinishDate;
    session.estBreakTime = estBreakTime;
    session.isManual = [NSNumber numberWithBool:isManual];
    session.sessionStateType = sessionStateType;
    session.startDate = startDate;
    
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
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"finishDate = nil"];
    
    return [[[self.intervalList filteredSetUsingPredicate:predicate] sortedArrayUsingDescriptors:sortDescriptors] firstObject];
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
    
    _balance = [self.workTime doubleValue] - [self.estWorkTime doubleValue];
    
    return _balance;
}

/*
- (NSTimeInterval)adjustedTimeBalance {
    
    NSTimeInterval _balance = 0;
    
    _balance = [self.workAdjustedTime doubleValue] - [self.estWorkTime doubleValue];
    
    return _balance;
}
*/

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

@end
