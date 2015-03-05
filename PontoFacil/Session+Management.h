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
} SessionStateType;

@interface Session (Management)

@property (nonatomic) SessionStateType sessionStateType;
@property (nonatomic, assign, readonly) NSNumber *workTime;
@property (nonatomic, assign, readonly) NSNumber *breakTime;

- (NSTimeInterval)timeBalance;
//- (NSTimeInterval)adjustedTimeBalance;
//- (NSTimeInterval)calculateAdjustedWorkTime;
//- (NSTimeInterval)calculateAdjustedWorkTime: (NSTimeInterval)workTime andBreakTime:(NSTimeInterval)breakTime;

- (NSDate *)calculateEstimatedFinishDate:(BOOL)adjustBreakTime;

+ (instancetype)insertSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakTime:(NSNumber *)estBreakTime andIsManual:(BOOL)isManual andSessionState:(SessionStateType)sessionStateType andStartDate:(NSDate *)startDate;

+ (Session *)sessionFromURI:(NSData *)URIData;

//+ (Session *)insertSessionWithEstStartDate:(NSDate *)estStartDate andEstFinishDate:(NSDate *)estFinishDate andEstBreakTime:(NSNumber *)estBreakTime andEstWorkTimeDescription:(NSString *)estWorkTimeDescription andIsManual:(BOOL)isManual andSessionState:(SessionStateType)sessionStateType andWorkStartDate:(NSDate *)workStartDate;

- (Interval *)activeInterval;

@end
