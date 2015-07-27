//
//  Session+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Session.h"
#import "Interval+Management.h"

@interface Session (Management)

@property (nonatomic, assign, readonly) NSNumber *workTime;
@property (nonatomic, assign, readonly) NSNumber *breakTime;
@property (nonatomic, assign, readonly) NSNumber *breakTimeInProgress;
@property (nonatomic, assign, readonly) double timeBalance;
@property (nonatomic, strong, readonly) NSArray *ascendingIntervalList;
@property (nonatomic, strong, readonly) NSArray *descendingIntervalList;

- (instancetype)init;
- (instancetype)initWithEvent:(Event *)event;
- (instancetype)initSessionFromUri:(NSData *)URIData;

//Clock Operations
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)update;

- (BOOL)isStarted;
- (BOOL)isPaused;
- (BOOL)isStoped;

@end
