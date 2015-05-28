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
#import "NSUserDefaults+PontoFacil.h"

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
    
    [self loadDefaultUserData];

    return YES;
}

- (void)loadDefaultUserData {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!defaults.isLoaded) {
        defaults.workStartDate = @"09:00";
        defaults.workFinishDate = @"18:00";
        defaults.defaultWorkTime = 3600 * 8;
        
        defaults.breakStartDate = @"12:00";
        defaults.breakFinishDate = @"13:00";
        defaults.defaultBreakTime = 3600;
        
        defaults.breakTimeRequired = false;
        defaults.toleranceTime = 0;
        defaults.workFinishNotification = true;
        defaults.breakFinishNotification = true;
        
        [defaults synchronize];
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //
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
