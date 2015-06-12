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

static NSString *entityName = @"Event";

@implementation Event (Management)

- (instancetype)init {

    Event *_event = [self initWithEntity:[self entity] insertIntoManagedObjectContext:[Store defaultManagedObjectContext]];
    
    //Default Values
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setDefaultDate:[NSDate date]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _event.estWorkStart = [formatter dateFromString:defaults.workStartDate];
    _event.estWorkFinish = [formatter dateFromString:defaults.workFinishDate];
    _event.estBreakStart = [formatter dateFromString:defaults.breakStartDate];
    _event.estBreakFinish = [formatter dateFromString:defaults.breakFinishDate];
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

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estWorkStart" ascending:NO]];
    
    [request setFetchLimit:20];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"monthYearEstWorkStartDate" cacheName:nil];
}

@end
