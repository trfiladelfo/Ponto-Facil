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


- (EventCategoryType)eventCategoryType {
    return (EventCategoryType)[[self eventType] intValue];
}

- (void)setEventCategoryType:(EventCategoryType)eventCategoryType {
    [self setEventType:[NSNumber numberWithInt:eventCategoryType]];
}

- (NSString *)shortEstStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    return [dateFormatter stringFromDate: self.estStartDate];
}

- (NSString *)monthYearEstStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate: self.estStartDate];
}

- (NSNumber *)estWorkTime {

    NSTimeInterval estWorkTime = [self.estFinishDate timeIntervalSinceDate:self.estStartDate] - [self.estBreakTime doubleValue];
    
    return [NSNumber numberWithDouble:estWorkTime];
}

+ (NSFetchedResultsController*)fetchedResultsController
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"parent = %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"estStartDate" ascending:NO]];
    
    [request setFetchLimit:20];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:Store.defaultManagedObjectContext sectionNameKeyPath:@"monthYearEstStartDate" cacheName:nil];
}

@end
