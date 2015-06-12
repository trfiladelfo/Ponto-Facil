//
//  Session.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 09/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Interval;

@interface Session : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSDate * currentEstWorkFinishDate;
@property (nonatomic, retain) NSDate * currentEstBreakFinishDate;
@property (nonatomic, retain) NSNumber * isChecked;
@property (nonatomic, retain) NSString * sessionDescription;
@property (nonatomic, retain) NSNumber * sessionState;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSSet *intervalList;
@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addIntervalListObject:(Interval *)value;
- (void)removeIntervalListObject:(Interval *)value;
- (void)addIntervalList:(NSSet *)values;
- (void)removeIntervalList:(NSSet *)values;

@end
