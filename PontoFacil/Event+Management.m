//
//  Event+Management.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Event+Management.h"
#import "Store.h"
#import "NSUserDefaults+PontoFacil.h"
#import "NSDate-Utilities.h"

static NSString *entityName = @"Event";

@implementation Event (Management)

- (instancetype)init {

    Event *_event = [self initWithEntity:[self entity] insertIntoManagedObjectContext:[Store defaultManagedObjectContext]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _event.estWorkStart = [NSDate todayAtTimeFromStringHHMM:[defaults workStartDate]];
    _event.estWorkFinish = [NSDate todayAtTimeFromStringHHMM:[defaults workFinishDate]];
    _event.estBreakStart = [NSDate todayAtTimeFromStringHHMM:[defaults breakStartDate]];
    _event.estBreakFinish = [NSDate todayAtTimeFromStringHHMM:[defaults breakFinishDate]];
    _event.eventTypeCategory = kEventTypeNormal;
    _event.isManual = [NSNumber numberWithBool:false];
    _event.isAbsence = [NSNumber numberWithBool:false];
    
    return _event;
}

- (NSEntityDescription *)entity {

    return [NSEntityDescription entityForName:entityName inManagedObjectContext:[Store defaultManagedObjectContext]];
}


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

- (void)updateEventDate:(NSDate *)newDate {
    
    self.estWorkStart = [self.estWorkStart dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
    self.estWorkFinish = [self.estWorkFinish dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
    self.estBreakStart = [self.estBreakStart dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
    self.estBreakFinish = [self.estBreakFinish dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estWorkStart" ascending:NO]];
    
    [request setFetchLimit:20];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"monthYearEstWorkStartDate" cacheName:nil];
}

@end
