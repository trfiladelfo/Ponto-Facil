//
//  Event+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Event.h"

typedef enum {
    kEventTypeNormal = 0,
    kEventTypeHoliday = 1
} EventTypeCategory;

@interface Event (Management)

@property (nonatomic) EventTypeCategory eventTypeCategory;
@property (nonatomic, assign, readonly) NSNumber *estWorkTime;
@property (nonatomic, assign, readonly) NSNumber *estBreakTime;

+ (NSFetchedResultsController *)fetchedResultsController;

-(instancetype)init;

- (void)updateEventDate:(NSDate *)newDate;

@end
