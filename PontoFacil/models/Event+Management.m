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
#import "Session+Management.h"

static NSString *entityName = @"Event";

typedef enum {
    kEventTypeNormal = 0,
    kEventTypeHoliday = 1
} EventTypeCategory;

@interface Event()

@property (nonatomic) EventTypeCategory eventTypeCategory;

@end

@implementation Event (Management)

- (instancetype)init {

    Event *_event = [self initWithEntity:[self entity] insertIntoManagedObjectContext:[Store defaultManagedObjectContext]];
    
    return _event;
}

- (instancetype)initEventWithDate:(NSDate *)date {
    Event *_event = [self init];
    _event.eventTypeCategory = kEventTypeNormal;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDefaultDate:date];
    [formatter setDateFormat:@"HH:mm"];
    [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    _event.estWorkStart = [formatter dateFromString:[defaults workStartDate]];
    _event.estWorkFinish = [formatter dateFromString:[defaults workFinishDate]];
    _event.estBreakStart = [formatter dateFromString:[defaults breakStartDate]];
    _event.estBreakFinish = [formatter dateFromString:[defaults breakFinishDate]];
    _event.isManual = [NSNumber numberWithBool:false];
    _event.isAbsence = [NSNumber numberWithBool:false];
    
    return _event;
}

- (instancetype)initHolidayEventWithDate:(NSDate *)date {
    Event *_event = [self init];
    _event.eventTypeCategory = kEventTypeHoliday;
    
    _event.estWorkStart = [date dateAtStartOfDay];
    _event.estWorkFinish = [date dateAtStartOfDay];
    _event.estBreakStart = [date dateAtStartOfDay];
    _event.estBreakFinish = [date dateAtStartOfDay];
    _event.isManual = [NSNumber numberWithBool:true];
    _event.isAbsence = [NSNumber numberWithBool:false];
    
    return _event;
}

- (NSEntityDescription *)entity {

    return [NSEntityDescription entityForName:entityName inManagedObjectContext:[Store defaultManagedObjectContext]];
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

- (void)setEventTypeCategory:(EventTypeCategory)eventTypeCategory {
    [self setEventType:[NSNumber numberWithInt:eventTypeCategory]];
}

- (EventTypeCategory)eventTypeCategory {
    return (EventTypeCategory)[[self eventType] intValue];
}

- (BOOL)isHoliday {
    return self.eventTypeCategory == kEventTypeHoliday;
}

- (NSTimeInterval)timeBalance {
    
    NSTimeInterval _balance = 0;
    NSTimeInterval _workTime = 0;
    
    if (self.session) {
        _workTime = [self.session.workTime doubleValue];
    }
    
    _balance = _workTime - [self.estWorkTime doubleValue];
    
    return _balance;
}

- (void)updateEventDate:(NSDate *)newDate {
    
    self.estWorkStart = [self.estWorkStart dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
    self.estWorkFinish = [self.estWorkFinish dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
    self.estBreakStart = [self.estBreakStart dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
    self.estBreakFinish = [self.estBreakFinish dateByUpdateYear:newDate.year andMonth:newDate.month andDay:newDate.day];
}

+ (NSFetchedResultsController *)initSortedFetchedResultsController:(NSSortDescriptor *)sortDescriptor withPredicateArray:(NSArray *)predicateArray {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [request setFetchLimit:20];
    
    request.sortDescriptors = @[sortDescriptor];
    
    if (predicateArray) {
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
        request.predicate = predicate;
    }
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"monthYearEstWorkStartDate" cacheName:nil];
}

+ (NSFetchedResultsController*)sortedFetchedResultsController:(BOOL)ascending fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"estWorkStart" ascending:ascending];
    
    NSMutableArray *predicateArray = [NSMutableArray array];
    
    if (fromDate) {
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"estWorkStart >= %@", fromDate]];
    }
    
    if (toDate) {
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"estWorkStart <= %@",  toDate]];
    }
    
    return [Event initSortedFetchedResultsController:sortDescriptor withPredicateArray:predicateArray];
}

+ (NSFetchedResultsController*)sortedFetchedResultsController:(BOOL)ascending
{
    return [Event sortedFetchedResultsController:ascending fromDate:nil toDate:nil];
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    return [Event sortedFetchedResultsController:false];
}

+ (NSArray *)sortedEventListFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate {

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"estWorkStart" ascending:true];
    
    request.sortDescriptors = @[sortDescriptor];
    
    NSMutableArray *predicateArray = [NSMutableArray array];
    
    //Apenas sessões finalizadas
    //[predicateArray addObject:[NSPredicate predicateWithFormat:@"session.sessionState = %i", [NSNumber numberWithInt:kSessionStateStop]]];
    
    //Filtrar data de início
    [predicateArray addObject:[NSPredicate predicateWithFormat:@"estWorkStart >= %@ and estWorkStart <= %@", fromDate, toDate]];
    
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    
    request.predicate = predicate;
    
    NSError *error;
    NSArray *fetchResults = [[Store defaultManagedObjectContext] executeFetchRequest:request error:&error];
    
    if (fetchResults == nil) {
        // Handle the error.
        NSLog(@"executeFetchRequest failed with error: %@", [error localizedDescription]);
    }
    
    return fetchResults;
}

@end
