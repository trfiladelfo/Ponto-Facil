//
//  Absence.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 01/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Event.h"


@interface Absence : Event

@property (nonatomic, retain) NSNumber * absenceType;
@property (nonatomic, retain) NSNumber * isScheduled;
@property (nonatomic, retain) NSString * reason;

@end
