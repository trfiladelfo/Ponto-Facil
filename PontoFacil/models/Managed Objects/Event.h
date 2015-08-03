//
//  Event.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 04/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Session;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * estBreakFinish;
@property (nonatomic, retain) NSDate * estBreakStart;
@property (nonatomic, retain) NSDate * estWorkFinish;
@property (nonatomic, retain) NSDate * estWorkStart;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSNumber * isAbsence;
@property (nonatomic, retain) NSNumber * isManual;
@property (nonatomic, retain) Session *session;

@end
