//
//  Event+Management.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Event+Management.h"
#import "Store.h"

static NSString *entityName = @"Event";

@implementation Event (Management)

-(EventType)eventType {
    return (EventType)[[self type] intValue];
}

-(void)setEventType:(EventType)eventType {
    [self setType:[NSNumber numberWithInt:eventType]];
}

- (NSTimeInterval)eventInterval {
    
    if (self.stopDate) {
        return [self.stopDate timeIntervalSinceDate: self.startDate];
    }
    else
        return [[NSDate date] timeIntervalSinceDate:self.startDate];
    
}

+ (Event *)insertEventWithSession:(Session *)session andEventType:(EventType)eventType andStartDate:(NSDate *)startDate {
    
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    event.session = session;
    event.eventType = eventType;
    event.startDate = startDate;
    
    return event;
}

+ (Event *)insertEventWithSession:(Session *)session andEventType:(EventType)eventType andStartDate:(NSDate *)startDate andFinishDate:(NSDate *)finishDate {
    
    Event *event = [self insertEventWithSession:session andEventType:eventType andStartDate:startDate];
    event.stopDate = finishDate;
    return event;
}

@end
