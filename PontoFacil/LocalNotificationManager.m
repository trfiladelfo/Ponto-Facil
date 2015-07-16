//
//  LocalNotificationManager.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 15/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "LocalNotificationManager.h"
#import <UIKit/UIKit.h>
#import "NSUserDefaults+PontoFacil.h"
#import "NSDate-Utilities.h"

@interface LocalNotificationManager()

@property (nonatomic, retain) NSDateFormatter *formatter;

@property (nonatomic, assign) BOOL allowNotifications;
@property (nonatomic, assign) BOOL allowNotificationsSound;
@property (nonatomic, assign) BOOL allowNotificationsBadge;
@property (nonatomic, assign) BOOL allowNotificationsAlert;
@property (nonatomic, assign) BOOL sendWorkTimeNotification;
@property (nonatomic, assign) BOOL sendBreakTimeNotification;
@property (nonatomic, assign) int advanceTimeForWorkNotification;
@property (nonatomic, assign) int advanceTimeForBreakNotification;

@end

@implementation LocalNotificationManager

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";

+ (LocalNotificationManager *)sharedInstance {

    static LocalNotificationManager *_sharedInstance;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LocalNotificationManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {

    self = [super init];
    
    if (self) {
        [self registerForNotification];
        [self setNotificationTypesAllowed];
        [self loadNotificationPreferences];
    }
    
    return self;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"MM-dd-yyy hh:mm"];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}

- (void)loadNotificationPreferences {

    //Load Default Values
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.sendWorkTimeNotification = [userDefaults workFinishNotification];
    self.sendBreakTimeNotification = [userDefaults breakFinishNotification];
    self.advanceTimeForWorkNotification = (int)[userDefaults advanceTimeForWorkNotification];
    self.advanceTimeForBreakNotification = (int)[userDefaults advanceTimeForBreakNotification];
}

- (void) setNotificationTypesAllowed
{
    NSLog(@"%s:", __PRETTY_FUNCTION__);
    // get the current notification settings
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    self.allowNotifications = (currentSettings.types != UIUserNotificationTypeNone);
    self.allowNotificationsSound = (currentSettings.types & UIUserNotificationTypeSound) != 0;
    self.allowNotificationsBadge = (currentSettings.types & UIUserNotificationTypeBadge) != 0;
    self.allowNotificationsAlert = (currentSettings.types & UIUserNotificationTypeAlert) != 0;
}

- (void)registerForNotification {
    
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (settings.types == UIUserNotificationTypeNone) {
        
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"Action 1"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"Action 2"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        UIUserNotificationSettings *newSettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        
        
        // Register the notification settings.
        [[UIApplication sharedApplication] registerUserNotificationSettings:newSettings];
        
    }
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventListNotification) name:@"eventListNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScheduleNewNotification) name:@"scheduleNewNotification" object:nil];
}

- (void)scheduleNotificationsFromType:(LocalNotificationType)notificationType withFireDate:(NSDate *)fireDate {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    if (notificationType == kLocalNotificationTypeWork) {
        if (self.sendWorkTimeNotification) {
            //Todo: Notificação de 15 minutos só deve ser reeschedulada se ainda não tiver sido disparada
            
            if (self.advanceTimeForWorkNotification > 0) {
                [self scheduleNotificationWithMessage:[NSString stringWithFormat:@"Seu expediente irá terminar em %i minutos",self.advanceTimeForWorkNotification] andFireDate:[fireDate dateBySubtractingMinutes:self.advanceTimeForWorkNotification]];
            }
            
            [self scheduleNotificationWithMessage:@"Fim do expediente!" andFireDate:fireDate];
        }
    }
    else if (notificationType == kLocalNotificationTypeBreak) {
        if (self.sendBreakTimeNotification) {
            
            if (self.advanceTimeForBreakNotification > 0) {
                [self scheduleNotificationWithMessage:[NSString stringWithFormat:@"O intervalo irá terminar em %i minutos", self.advanceTimeForBreakNotification] andFireDate:[fireDate dateBySubtractingMinutes:self.advanceTimeForBreakNotification]];
            }
            
            [self scheduleNotificationWithMessage:@"Fim do intervalo!" andFireDate:fireDate];
        }
    }
}

- (void)scheduleNotificationWithMessage:(NSString *)message andFireDate:(NSDate *)fireDate {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (notification)
    {
        if (self.allowNotifications) {
            
            notification.fireDate = fireDate;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.category = @"timerActionsReminder";
            
            if (self.allowNotificationsAlert) {
                notification.alertBody = message;
                notification.alertAction = @"OK";
            }
            if (self.allowNotificationsBadge) {
                notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            }
            if (self.allowNotificationsSound) {
                notification.soundName = UILocalNotificationDefaultSoundName;
            }
        }
        
        NSString *notifDate = [self.formatter stringFromDate:fireDate];
        NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
        
        // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
}

- (void)clearNotifications {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
