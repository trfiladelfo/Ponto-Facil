//
//  Store.m
//  DailyTaskManager
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "Store.h"

@implementation Store

+ (NSManagedObjectContext *)defaultManagedObjectContext {
    
    NSManagedObjectContext *moc = nil;
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(managedObjectContext)]) {
        moc = [appDelegate managedObjectContext];
    }
    
    return moc;
}

@end
