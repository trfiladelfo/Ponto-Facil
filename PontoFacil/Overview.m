//
//  Overview.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "Overview.h"
#import "Event+Management.h"

@interface Overview ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation Overview

- (instancetype)initWithStartDate:(NSDate *)startDate andFinishDate:(NSDate *)finishDate
{
    self = [super init];
    if (self) {
        self.fetchedResultsController = [Event sortedFetchedResultsController:false fromDate:startDate toDate:finishDate];
        [self loadOverviewData];
    }
    return self;

}

- (void)loadOverviewData {
    
    NSError *fetchError;
    [self.fetchedResultsController performFetch:&fetchError];
    
    if (!fetchError) {
        
        NSPredicate *stopedEventsPredicate = [NSPredicate predicateWithFormat:@"session == nil || session.finishDate != nil"];
        
        NSArray *eventList = [[self.fetchedResultsController fetchedObjects] filteredArrayUsingPredicate:stopedEventsPredicate];
        
        NSPredicate *sessionPredicate = [NSPredicate predicateWithFormat:@"eventType == 0 && session.finishDate != nil"];
        NSPredicate *holidayPredicate = [NSPredicate predicateWithFormat:@"eventType == 1"];
        NSPredicate *absencePredicate = [NSPredicate predicateWithFormat:@"isAbsence == %@", [NSNumber numberWithBool:true]];
        
        self.sessionCount = (int)[[eventList filteredArrayUsingPredicate:sessionPredicate] count];
        self.holidayCount = (int)[[eventList filteredArrayUsingPredicate:holidayPredicate] count];
        self.absentCount = (int)[[eventList filteredArrayUsingPredicate:absencePredicate] count];
        self.timeBalance = [[eventList valueForKeyPath:@"@sum.session.timeBalance"] doubleValue];
    }
}

@end
