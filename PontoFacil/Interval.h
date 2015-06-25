//
//  Interval.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 04/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Interval : NSManagedObject

@property (nonatomic, retain) NSDate * intervalFinish;
@property (nonatomic, retain) NSDate * intervalStart;
@property (nonatomic, retain) NSNumber * intervalType;
@property (nonatomic, retain) Session *session;

@end
