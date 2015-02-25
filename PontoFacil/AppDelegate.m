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
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    if (! [defaults doubleForKey:@"defaultWorkTime"]) {
        [defaults setValue:@"09:00" forKey:@"defaultStartDate"];
        [defaults setValue:@"18:00" forKey:@"defaultStopDate"];
        
        NSTimeInterval workTime = 3600 * 8;
        [defaults setDouble:workTime forKey:@"defaultWorkTime"];
    }
    
    if (! [defaults valueForKey:@"defaultBreakTime"]) {
        [defaults setValue:@"01:00" forKey:@"defaultBreakTime"];
        
        NSTimeInterval minTimeOut = 3600;
        [defaults setDouble:minTimeOut forKey:@"defaultMinTimeOut"];
    }
    
    if (! [defaults objectForKey:@"workTimeNotification"] ) {
        [defaults setBool:true forKey:@"workTimeNotification"];
    }
    
    if (! [defaults objectForKey:@"timeOutNotification"]) {
        [defaults setBool:true forKey:@"timeOutNotification"];
    }
    
    if (! [defaults doubleForKey:@"minWorkToTimeOut"]) {
        
        NSTimeInterval minWorkToTimeOut = 3600 * 6;
        [defaults setDouble:minWorkToTimeOut forKey:@"minWorkToTimeOut"];
    }
    
    [defaults synchronize];
    
    application.applicationIconBadgeNumber = 0;

    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lembrete"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
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
