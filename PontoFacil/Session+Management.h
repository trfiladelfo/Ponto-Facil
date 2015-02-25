//
//  Session+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Session.h"

typedef enum {
    kSessionStateStart = 0,
    kSessionStateStop = 1,
    kSessionStatePaused = 2
} SessionState;

@interface Session (Management)

@property (nonatomic) SessionState sessionState;
//@property (nonatomic, retain, readonly) NSNumber * estWorkTime;

+ (instancetype)insertSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakTime:(NSNumber *)estBreakTime andIsManual:(BOOL)isManual andSessionState:(SessionState)sessionState andWorkStartDate:(NSDate *)workStartDate;

//+ (Session *)sessionWithDate:(NSDate *)sessionDate;

+ (NSFetchedResultsController *)fetchedResultsController;

- (NSTimeInterval)timeBalance;

- (NSTimeInterval)adjustedTimeBalance;

- (NSTimeInterval)calculateWorkTime;

- (NSTimeInterval)calculateBreakTime;

- (NSDate *)calculateEstimatedFinishDate:(BOOL)adjustBreakTime;

- (Event *)activeEvent;

@end
