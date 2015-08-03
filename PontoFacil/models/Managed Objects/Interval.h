//
//  Interval.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 11/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Interval, Session;

@interface Interval : NSManagedObject

@property (nonatomic, retain) NSDate * intervalFinish;
@property (nonatomic, retain) NSDate * intervalStart;
@property (nonatomic, retain) NSNumber * intervalType;
@property (nonatomic, retain) Interval *nextInterval;
@property (nonatomic, retain) Interval *previousInterval;
@property (nonatomic, retain) Session *session;

@end
