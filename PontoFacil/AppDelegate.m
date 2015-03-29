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
#import "UIColor+PontoFacil.h"
#import "UIFont+PontoFacil.h"

@interface AppDelegate ()

@property (nonatomic, strong) PersistentStack *persistentStack;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBarTintColor:[UIColor navigationHeaderColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor navigationHeaderTitleColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor navigationHeaderTitleColor], NSForegroundColorAttributeName,
                                                           [UIFont headerTitleFont], NSFontAttributeName, nil]];
    
    
    [[UINavigationBar appearance] setTranslucent:NO];
    
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
    
    if (![defaults boolForKey:@"adjustMinTimeOut"]) {
        [defaults setBool:false forKey:@"adjustMinTimeOut"];
    };
    
    if (![defaults integerForKey:@"toleranceTime"]) {
        [defaults setInteger:0 forKey:@"toleranceTime"];
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

    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"Notification Settings: %u", notificationSettings.types);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    
    if ([identifier isEqualToString:@"AdjustAction"]) {
        NSLog(@"Ajustar.");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"eventListNotification" object:nil];
    }
    else if ([identifier isEqualToString:@"SnoozeAction"]) {
        
        NSLog(@"Dormir.");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scheduleNewNotification" object:nil];
    }
    
    if (completionHandler) {
        
        completionHandler();
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Lembrete"
                                                        message:notification.alertBody
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
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
