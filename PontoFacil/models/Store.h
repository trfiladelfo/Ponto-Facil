//
//  Store.h
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSFetchedResultsController;

@interface Store : NSObject

+ (NSManagedObjectContext *) defaultManagedObjectContext;

@end
