//
//  LocalNotificationManager.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 15/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kLocalNotificationTypeWork = 0,
    kLocalNotificationTypeBreak = 1
} LocalNotificationType;

@interface LocalNotificationManager : NSObject

+ (LocalNotificationManager *)sharedInstance;

- (void)scheduleNotificationsFromType:(LocalNotificationType)notificationType withFireDate:(NSDate *)fireDate;
- (void)clearNotifications;

@end
