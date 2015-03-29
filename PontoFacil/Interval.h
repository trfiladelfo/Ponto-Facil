//
//  Interval.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Interval : NSManagedObject

@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSNumber * intervalType;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) Session *session;

@end
