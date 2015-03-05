//
//  Holiday.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Holiday : Event

@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSNumber * holidayType;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;

@end
