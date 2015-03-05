//
//  Session.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"

@class Interval;

@interface Session : Event

@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSNumber * isChecked;
@property (nonatomic, retain) NSNumber * isManual;
@property (nonatomic, retain) NSNumber * sessionType;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSSet *intervalList;
@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addIntervalListObject:(Interval *)value;
- (void)removeIntervalListObject:(Interval *)value;
- (void)addIntervalList:(NSSet *)values;
- (void)removeIntervalList:(NSSet *)values;

@end
