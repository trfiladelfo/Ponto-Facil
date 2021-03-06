//
//  Event+Management.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Event.h"

@interface Event (Management)

@property (nonatomic, assign, readonly) NSNumber *estWorkTime;
@property (nonatomic, assign, readonly) NSNumber *estBreakTime;
@property (nonatomic, assign, readonly) double timeBalance;

+ (NSFetchedResultsController *)fetchedResultsController;
+ (NSFetchedResultsController*)sortedFetchedResultsController:(BOOL)ascending;
+ (NSFetchedResultsController*)sortedFetchedResultsController:(BOOL)ascending fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSArray *)sortedEventListFromDate:(NSDate *)fromDate ToDate:(NSDate *)toDate;

- (instancetype)initEventWithDate:(NSDate *)date;
- (instancetype)initHolidayEventWithDate:(NSDate *)date;

- (BOOL)isHoliday;

- (void)updateEventDate:(NSDate *)newDate;

@end
