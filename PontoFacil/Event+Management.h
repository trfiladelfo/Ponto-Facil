//
//  Event+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Event.h"

typedef enum {
    kEventTypeSession = 0,
    kEventTypeHoliday = 1,
    kEventTypeAbsence = 2
} EventCategoryType;

@interface Event (Management)

@property (nonatomic) EventCategoryType eventCategoryType;
@property (nonatomic, assign, readonly) NSNumber *estWorkTime;

+ (NSFetchedResultsController *)fetchedResultsController;

@end
