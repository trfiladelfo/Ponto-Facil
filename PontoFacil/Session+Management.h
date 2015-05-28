//
//  Session+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Session.h"
#import "Interval+Management.h"

typedef enum {
    kSessionStateStart = 0,
    kSessionStateStop = 1,
    kSessionStatePaused = 2
} SessionStateCategory;

@interface Session (Management)

@property (nonatomic) SessionStateCategory sessionStateCategory;
@property (nonatomic, assign, readonly) NSNumber *workTime;
@property (nonatomic, assign, readonly) NSNumber *breakTime;
@property (nonatomic, assign, readonly) NSNumber *breakTimeInProgress;

- (NSTimeInterval)timeBalance;
//- (NSTimeInterval)adjustedTimeBalance;
//- (NSTimeInterval)calculateAdjustedWorkTime;
//- (NSTimeInterval)calculateAdjustedWorkTime: (NSTimeInterval)workTime andBreakTime:(NSTimeInterval)breakTime;

- (NSDate *)calculateEstimatedFinishDate:(BOOL)adjustBreakTime;

+ (instancetype)startSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakStartDate:(NSDate *)estBreakStartDate andEstBreakFinishDate:(NSDate *)estBreakFinishDate;

+ (Session *)sessionFromURI:(NSData *)URIData;

//- (Interval *)activeInterval;

- (void)startInterval:(IntervalCategoryType)intervalType;
- (void)finishActiveInterval;

- (NSArray *)dateSortedIntervalList;

- (NSString *)timeBalanceToString;

@end
