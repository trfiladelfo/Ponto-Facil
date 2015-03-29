//
//  Event.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * estBreakTime;
@property (nonatomic, retain) NSDate * estFinishDate;
@property (nonatomic, retain) NSDate * estStartDate;
@property (nonatomic, retain) NSNumber * eventType;

@end
