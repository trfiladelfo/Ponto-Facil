//
//  Event+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Event.h"

typedef enum {
    kEventTypeWork = 0,
    kEventTypeBreak = 1,
    kEventTypeOut = 2,
    kEventTypeTransit = 3
} EventType;

@interface Event (Management)

@property (nonatomic) EventType eventType;

+ (Event *)insertEventWithSession:(Session *)session andEventType:(EventType)eventType andStartDate:(NSDate *)startDate;
+ (Event *)insertEventWithSession:(Session *)session andEventType:(EventType)eventType andStartDate:(NSDate *)startDate andFinishDate:(NSDate *)finishDate;
- (NSTimeInterval)eventInterval;

@end
