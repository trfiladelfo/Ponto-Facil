//
//  AppDelegate.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 06/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "AppDelegate.h"
#import "PersistentStack.h"
#import "Store.h"

@interface AppDelegate ()

@property (nonatomic, strong) PersistentStack *persistentStack;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.persistentStack = [[PersistentStack alloc] initWithStoreURL:self.storeURL modelURL:self.modelURL];
    self.managedObjectContext = self.persistentStack.managedObjectContext;

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self.persistentStack.managedObjectContext save:nil];
}

#pragma mark - Core Data stack


- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)storeURL
{
    return [self.applicationDocumentsDirectory URLByAppendingPathComponent:@"PontoFacil.sqlite"];
}

- (NSURL*)modelURL
{
    return [[NSBundle mainBundle] URLForResource:@"PontoFacil" withExtension:@"momd"];
}

@end
