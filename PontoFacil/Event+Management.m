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


- (EventTypeCategory)eventTypeCategory {
    return (EventTypeCategory)[[self eventType] intValue];
}

- (void)setEventTypeCategory:(EventTypeCategory)eventTypeCategory {
    [self setEventType:[NSNumber numberWithInt:eventTypeCategory]];
}

- (NSString *)shortEstWorkStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate: self.estWorkStart];
}

- (NSString *)monthYearEstWorkStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate: self.estWorkStart];
}

- (NSNumber *)estWorkTime {

    NSTimeInterval estWorkTime = [self.estWorkFinish timeIntervalSinceDate:self.estWorkStart] - [self.estBreakTime doubleValue];
    
    return [NSNumber numberWithDouble:estWorkTime];
}

- (NSNumber *)estBreakTime {
    return [NSNumber numberWithDouble:[self.estBreakFinish timeIntervalSinceDate:self.estBreakStart]];
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estWorkStart" ascending:NO]];
    
    [request setFetchLimit:20];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"monthYearEstWorkStartDate" cacheName:nil];
}

+ (instancetype)insertEventWithEstWorkStart:(NSDate *)estWorkStart andEstWorkFinish:(NSDate *)estWorkFinish andEstBreakStart:(NSDate *)estBreakStart andEstBreakFinish:(NSDate *)estBreakFinish andIsManual:(BOOL)isManual andEventTypeCategory:(EventTypeCategory)eventTypeCategory andEventDescription:(NSString *)eventDescription {

    Event *event = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                     inManagedObjectContext:Store.defaultManagedObjectContext];
    
    event.estWorkStart = estWorkStart;
    event.estWorkFinish = estWorkFinish;
    event.estBreakStart = estBreakStart;
    event.estBreakFinish = estBreakFinish;
    event.eventTypeCategory = eventTypeCategory;
    event.isManual = [NSNumber numberWithBool:isManual];
    event.eventDescription = eventDescription;
    
    return event;
}

@end
