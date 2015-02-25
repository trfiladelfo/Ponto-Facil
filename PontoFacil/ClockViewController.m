//
//  ClockViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 07/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ClockViewController.h"
#import "CircleProgressView.h"
#import "Session+Management.h"
#import "Store.h"
#import "Event+Management.h"
#import "NSDate-Utilities.h"
#import "CircularButtonView.h"
#import "ActionButton.h"

@interface ClockViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) Session *session;
@property (nonatomic, assign) BOOL sendWorkTimeNotification;
@property (nonatomic, assign) BOOL sendBreakTimeNotification;
@property (nonatomic, assign) NSTimeInterval workTime;
@property (nonatomic, assign) NSTimeInterval minTimeOut;

@end

@implementation ClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load Default Values
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.sendWorkTimeNotification = [defaults boolForKey:@"workTimeNotification"];
    self.sendBreakTimeNotification = [defaults boolForKey:@"timeOutNotification"];
    self.workTime = [defaults doubleForKey:@"defaultWorkTime"];
    self.minTimeOut = [defaults doubleForKey:@"defaultMinTimeOut"];
    
    //Active Session
    NSData *sessionURIData = [defaults objectForKey:@"sessionID"];
    
    if (sessionURIData) {
        NSURL *sessionIDURI = [NSKeyedUnarchiver unarchiveObjectWithData:sessionURIData];
        
        if (sessionIDURI) {
            
            NSManagedObjectID *sessionID = [[[Store defaultManagedObjectContext] persistentStoreCoordinator] managedObjectIDForURIRepresentation:sessionIDURI];
            
            if (sessionID) {
                NSError *error = nil;
                self.session = (Session *)[[Store defaultManagedObjectContext]
                                           existingObjectWithID:sessionID
                                           error:&error];
            }
        }
    }
    
    [self refreshButtons];
    [self refreshStatusView];
    [self refreshClockView];
    [self startTimer];
    [self poolTimer];
}

#pragma mark - Private Functions

- (void)refreshButtons {

    if (self.session) {
        if (self.session.sessionState == kSessionStateStart) {
            [self.startBreakButton setSelected:true];
            [self.stopButton setEnabled:true];
        }
        else if (self.session.sessionState == kSessionStatePaused) {
            [self.startBreakButton setSelected:false];
            [self.stopButton setEnabled:true];
        }
        else if (self.session.sessionState == kSessionStateStop) {
            //Stopped
            [self.startBreakButton setSelected:false];
            [self.stopButton setEnabled:false];
        }
        
    }
    else {
        //Not Started
        [self.startBreakButton setSelected:false];
        [self.stopButton setEnabled:false];
    }
}

- (void)refreshStatusView {
    
    if (self.session) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        self.startDateLabel.text = [formatter stringFromDate:self.session.workStartDate == NULL ? self.session.estStartDate : self.session.workStartDate];
        self.breakTimeLabel.text = [self stringFromTimeInterval:[[self.session.workBreakTime doubleValue] == 0 ? self.session.estBreakTime : self.session.workBreakTime doubleValue]];
        self.finishDateLabel.text = [formatter stringFromDate:self.session.workFinishDate == NULL ? (self.session.workStartDate == NULL ? self.session.estFinishDate : [self.session calculateEstimatedFinishDate:true]) : self.session.workFinishDate];
    }
    else {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        self.startDateLabel.text = [defaults valueForKey:@"defaultStartDate"];
        self.finishDateLabel.text = [defaults valueForKey:@"defaultStopDate"];
        self.breakTimeLabel.text = [defaults valueForKey:@"defaultBreakTime"];
    }
}

- (void)refreshClockView {

    if (_session) {
        
        if (self.session.sessionState == kSessionStatePaused)
        {
            self.clockView.status = @"Intervalo";
            self.clockView.timeLimit = self.minTimeOut;
            self.clockView.elapsedTime = [self.session.workBreakTime doubleValue];
            [self.clockView setTintColor:[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0f]];
        }
        else
        {
            if (self.session.sessionState == kSessionStateStart) {
                self.clockView.status = @"Em andamento";
                [self.clockView setTintColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]];
            }
            else
            {
                self.clockView.status = @"Finalizada";
                [self.clockView setTintColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]];
            }
            
            self.clockView.timeLimit = self.workTime;
            self.clockView.elapsedTime = [self.session.workTime doubleValue];
        }
    }
    else {
    
        self.clockView.timeLimit = self.workTime;
        self.clockView.status = @"Não iniciada";
        self.clockView.elapsedTime = 0;
        
        [self.clockView setTintColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]];
    }

}

- (void)scheduleNotifications {
    
    if (_session) {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        if (_session.sessionState == kSessionStateStart) {
            NSDate *estFinishDate = [_session calculateEstimatedFinishDate:false];
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStateStart andMessage:@"Seu expediente irá terminar em 15 minutos" andDate:[estFinishDate dateByAddingMinutes:-15]];
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStateStart andMessage:@"Fim do expediente!" andDate:estFinishDate];
        }
        else if (_session.sessionState == kSessionStatePaused)
        {
            
            NSDate *estBreakFinishDate = [[NSDate date] dateByAddingTimeInterval:[_session.estBreakTime doubleValue]];
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStatePaused andMessage:@"Fim do intervalo!" andDate:estBreakFinishDate];
        }
    }
}

- (void)scheduleNotificationWithID:(NSManagedObjectID *)uuid andState:(SessionState)state andMessage:(NSString *)message andDate:(NSDate *)fireDate {
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = fireDate;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    // Notification details
    localNotif.alertBody = message;
    // Set the action button
    localNotif.alertAction = @"OK";
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    //NSURL *url = uuid.URIRepresentation;
    
    // Specify custom data for the notification
    //localNotif.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
    //                       [url lastPathComponent], @"objectID", state, @"objectState", nil];
    
    // Schedule the notification
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];

}

#pragma mark - User Interface

- (IBAction)startBreakButtonClick:(id)sender {
    
    if (self.session) {
        
        if (self.session.sessionState == kSessionStatePaused) {
            
            //Resume
            [self resumeCounter];
        }
        else if (self.session.sessionState == kSessionStateStart) {
            //Pause
            [self pauseCounter];
        }
    }
    else
    {
        //Start
        [self startCounter];
    }
    
    [self refreshButtons];
    [self refreshStatusView];
    [self refreshClockView];
    [self scheduleNotifications];
}

- (IBAction)stopButtonClick:(id)sender {

    if (self.session) {
    
        [self stopCounter];
    }

    [self refreshButtons];
    [self refreshStatusView];
    [self refreshClockView];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark - Timer Operations

- (void)startTimer {
    if ((!self.timer) || (![self.timer isValid])) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.00
                                                      target:self
                                                    selector:@selector(poolTimer)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)poolTimer
{
    if (_session) {
        
        if (_session.sessionState == kSessionStatePaused) {
            
            self.clockView.elapsedTime = _session.calculateBreakTime;
        }
        else if (_session.sessionState == kSessionStateStart)
        {
            self.clockView.elapsedTime = _session.calculateWorkTime;
        }
    }
}

- (void)startCounter
{
    if (!_session)
    {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *defaultStartDate = [defaults valueForKey:@"defaultStartDate"];
        NSString *defaultFinishDate = [defaults valueForKey:@"defaultStopDate"];
        NSDate *startDate = [NSDate date];
        
        NSDate *estStartDate = [[[startDate dateAtStartOfDay] dateByAddingHours:[[defaultStartDate substringToIndex:2] intValue]] dateByAddingMinutes:[[defaultStartDate substringFromIndex:3] intValue]];
        
        NSDate *estFinishDate = [[[startDate dateAtStartOfDay] dateByAddingHours:[[defaultFinishDate substringToIndex:2] intValue]] dateByAddingMinutes:[[defaultFinishDate substringFromIndex:3] intValue]];
        
        _session = [Session insertSessionWithEstStartDate:estStartDate andEstFinishDate:estFinishDate andEstBreakTime:[NSNumber numberWithDouble:self.minTimeOut] andIsManual:false andSessionState:kSessionStateStart andWorkStartDate:startDate];
        
        //Inicío o período de trabalho
        [Event insertEventWithSession:_session andEventType:kEventTypeWork andStartDate:startDate];
        
        NSError *error;
        [self.session.managedObjectContext save:&error];
        
        //Salva o ID da sessão ativa
        NSData *sessionURIData = [NSKeyedArchiver archivedDataWithRootObject:self.session.objectID.URIRepresentation];
        [[NSUserDefaults standardUserDefaults] setObject:sessionURIData forKey:@"sessionID"];
    }
    
}

- (void)pauseCounter {
    
    if ((_session) && (_session.sessionState == kSessionStateStart)) {

        NSDate *now = [[NSDate alloc] init];
        
        if (self.session.activeEvent) {
            _session.activeEvent.stopDate = now;
        }
        
        _session.sessionState = kSessionStatePaused;
        
        [Event insertEventWithSession:_session andEventType:kEventTypeBreak andStartDate:now];
        
        [self.session.managedObjectContext save:nil];
    }
}

- (void)resumeCounter {
    
    if ((_session) && (_session.sessionState == kSessionStatePaused)) {
        
        NSDate *now = [[NSDate alloc] init];
        
        if (_session.activeEvent) {
            _session.activeEvent.stopDate = now;
        }
        
        _session.workBreakTime = [NSNumber numberWithDouble:[_session calculateBreakTime]];
        
        _session.sessionState = kSessionStateStart;
        
        [Event insertEventWithSession:_session andEventType:kEventTypeWork andStartDate:now];
        
        [self.session.managedObjectContext save:nil];
    }
}

- (void)stopCounter
{
    
    NSDate *now = [NSDate date];
    
    if (_session) {
        
        if (_session.activeEvent) {
            _session.activeEvent.stopDate = now;
        }
        
        //Finaliza a Sessão
        _session.workFinishDate = now;
        _session.workTime = [NSNumber numberWithDouble:_session.calculateWorkTime];
        _session.workBreakTime = [NSNumber numberWithDouble:[_session calculateBreakTime]];
        //_session.workAdjustedTime = [NSNumber numberWithDouble:_session.calculateAdjustedWorkTime];
        _session.sessionState = kSessionStateStop;
        
        [self.session.managedObjectContext save:nil];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionID"];
    }
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
}


@end
