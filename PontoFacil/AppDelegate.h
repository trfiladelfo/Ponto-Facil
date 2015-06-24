//
//  AppDelegate.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 06/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSURL *)applicationDocumentsDirectory;


@end

