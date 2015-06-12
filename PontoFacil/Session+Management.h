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
@property (nonatomic, assign, readonly) double timeBalance;
@property (nonatomic, strong) NSArray *orderedIntervalList;

- (instancetype)init;
- (instancetype)initSessionFromUri:(NSData *)URIData;

//Clock Operations
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;


@end
