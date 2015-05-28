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
#import "Event+Management.h"
#import "NSDate-Utilities.h"
#import "CircularButtonView.h"
#import "ActionButton.h"
#import <BDKNotifyHUD.h>
#import "IntervalListTableViewController.h"
#import "NSString+TimeInterval.h"
#import "NSUserDefaults+PontoFacil.h"

@interface ClockViewController () <UIActionSheetDelegate>

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) Session *session;
@property (nonatomic, assign) BOOL sendWorkTimeNotification;
@property (nonatomic, assign) BOOL sendBreakTimeNotification;
@property (nonatomic, assign) NSTimeInterval workTime;
@property (nonatomic, assign) NSTimeInterval minTimeOut;

@property (nonatomic, assign) BOOL allowNotifications;
@property (nonatomic, assign) BOOL allowNotificationsSound;
@property (nonatomic, assign) BOOL allowNotificationsBadge;
@property (nonatomic, assign) BOOL allowNotificationsAlert;

@end

@implementation ClockViewController

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventListNotification) name:@"eventListNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScheduleNewNotification) name:@"scheduleNewNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    //Load Default Values
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    self.sendWorkTimeNotification = [defaults workFinishNotification];
    self.sendBreakTimeNotification = [defaults breakFinishNotification];
    self.workTime = [defaults defaultWorkTime];
    self.minTimeOut = [defaults defaultBreakTime];
    
    [self loadActiveSession];
    [self setNotificationTypesAllowed];
    [self refreshButtons];
    [self refreshStatusView];
    [self refreshClockView];
    [self startTimer];
    [self poolTimer];
}

#pragma mark - Private Functions

- (void)loadActiveSession {

    //Active Session
    NSData *sessionURIData = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionID"];
    self.session = [Session sessionFromURI:sessionURIData];
    
    //Se a sessão gravada no User Default não for de hoje e não
    if ((self.session.sessionStateCategory == kSessionStateStop) && (![self.session.event.estWorkStart isToday])) {
        self.session = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)refreshButtons {

    if (self.session) {
        if (self.session.sessionStateCategory == kSessionStateStart) {
            [self.startStopButton setEnabled:true];
            [self.pauseResumeButton setEnabled:true];
            [self.startStopButton setSelected:true];
            [self.pauseResumeButton setSelected:false];
        }
        else if (self.session.sessionStateCategory == kSessionStatePaused) {
            [self.startStopButton setEnabled:true];
            [self.pauseResumeButton setEnabled:true];
            [self.startStopButton setSelected:true];
            [self.pauseResumeButton setSelected:true];
        }
        else if (self.session.sessionStateCategory == kSessionStateStop) {
            //Stopped
            [self.startStopButton setEnabled:false];
            [self.pauseResumeButton setEnabled:false];
            [self.startStopButton setSelected:false];
            [self.pauseResumeButton setSelected:false];
        }
        
        [self.reviewButton setEnabled:true];
        
    }
    else {
        //Not Started
        [self.startStopButton setEnabled:true];
        [self.pauseResumeButton setEnabled:false];
        [self.startStopButton setSelected:false];
        [self.pauseResumeButton setSelected:false];
        [self.reviewButton setEnabled:false];
    }
}

- (void)refreshStatusView {
    
    if (self.session) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        self.startDateLabel.text = [formatter stringFromDate:self.session.startDate == NULL ? self.session.event.estWorkStart : self.session.startDate];
        
        self.breakTimeLabel.text = [NSString stringWithTimeInterval:[[self.session.breakTime doubleValue] == 0 ? self.session.event.estBreakTime : self.session.breakTime doubleValue]];
        
        self.finishDateLabel.text = [formatter stringFromDate:self.session.finishDate == NULL ? (self.session.startDate == NULL ? self.session.event.estWorkFinish : [self.session calculateEstimatedFinishDate:true]) : self.session.finishDate];
    }
    else {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        self.startDateLabel.text = [defaults workStartDate];
        self.finishDateLabel.text = [defaults workFinishDate];
        self.breakTimeLabel.text = [NSString stringWithTimeInterval:[defaults defaultBreakTime]];
    }
}

- (void)refreshClockView {

    if (_session) {
        
        if (self.session.sessionStateCategory == kSessionStatePaused)
        {
            self.clockView.status = @"Intervalo";
            self.clockView.timeLimit = self.minTimeOut;
            self.clockView.elapsedTime = [self.session.breakTimeInProgress doubleValue];
            [self.clockView setTintColor:[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0f]];
        }
        else
        {
            if (self.session.sessionStateCategory == kSessionStateStart) {
                self.clockView.status = @"Em andamento";
                [self.clockView setTintColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]];
            }
            else
            {
                /*
                NSString *balanceSignal;
                
                if ([_session.estWorkTime doubleValue] > [_session.workTime doubleValue]) {
                    balanceSignal = @"-";
                } else {
                    balanceSignal = @"+";
                }
                
                self.clockView.status = [NSString stringWithFormat:@"%@ %@", balanceSignal, [self stringFromTimeInterval:ABS(self.session.timeBalance)]];
                */
                
                self.clockView.status = @"Finalizada";
                
                [self.clockView setTintColor:[UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]];
            }
            
            self.clockView.timeLimit = [self.session.event.estWorkTime doubleValue];
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
}

- (void)scheduleNotifications {
    
    if (self.session) {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        if (self.session.sessionStateCategory == kSessionStateStart) {
            NSDate *estFinishDate = [_session calculateEstimatedFinishDate:true];
            
            //Todo: Notificação de 15 minutos só deve ser reeschedulada se ainda não tiver sido disparada
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStateStart andMessage:@"Seu expediente irá terminar em 15 minutos" andDate:[estFinishDate dateBySubtractingMinutes:15] andRepeatInterval:false];
            
            //NSLog(@"1-Notifications count = %i", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
            
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStateStart andMessage:@"Fim do expediente!" andDate:estFinishDate andRepeatInterval:true];
        }
        else if (self.session.sessionStateCategory == kSessionStatePaused)
        {
            
            NSDate *estBreakFinishDate = [[NSDate date] dateByAddingTimeInterval:[_session.event.estBreakTime doubleValue]];
            
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStatePaused andMessage:@"O intervalo irá terminar em 10 minutos" andDate:[estBreakFinishDate dateBySubtractingMinutes:10] andRepeatInterval:true];
            
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStatePaused andMessage:@"Fim do intervalo!" andDate:estBreakFinishDate andRepeatInterval:true];
        }
    }
}

- (void)scheduleNotificationWithID:(NSManagedObjectID *)uuid andState:(SessionStateCategory)state andMessage:(NSString *)message andDate:(NSDate *)fireDate andRepeatInterval:(BOOL)repeatInterval {
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (notification)
    {
        if (self.allowNotifications) {
            
            notification.fireDate = fireDate;
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.category = @"timerActionsReminder";
            
            //BUG
            //if (repeatInterval) {
            //    notification.repeatInterval = NSCalendarUnitMinute * 5;
            //}
            
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
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd-yyy hh:mm"];
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
        NSString *notifDate = [formatter stringFromDate:fireDate];
        NSLog(@"%s: fire time = %@", __PRETTY_FUNCTION__, notifDate);
        
        // this will schedule the notification to fire at the fire date
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        // this will fire the notification right away, it will still also fire at the date we set
        //[[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }

}

- (void)setNotificationTypesAllowed
{
    NSLog(@"%s:", __PRETTY_FUNCTION__);
    // get the current notification settings
    UIUserNotificationSettings *currentSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    self.allowNotifications = (currentSettings.types != UIUserNotificationTypeNone);
    self.allowNotificationsSound = (currentSettings.types & UIUserNotificationTypeSound) != 0;
    self.allowNotificationsBadge = (currentSettings.types & UIUserNotificationTypeBadge) != 0;
    self.allowNotificationsAlert = (currentSettings.types & UIUserNotificationTypeAlert) != 0;
}

- (void)handleEventListNotification {
    //
}

- (void)handleScheduleNewNotification {
    //
}


- (void)notifyHUDMessage {
    
    if (_session) {
    
        NSString *hudMessage;
        //NSString *balanceSignal;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
        
        switch (self.session.sessionStateCategory) {
            default:
            case kSessionStateStart:
                hudMessage = [NSString stringWithFormat:@"Sessão iniciada. Previsão de saída:  %@", [formatter stringFromDate:[_session calculateEstimatedFinishDate:true]]];
                break;
            case kSessionStatePaused:
                hudMessage = [NSString stringWithFormat:@"Em intervalo. Previsão de retorno: %@", [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:[_session.event.estBreakTime doubleValue]]]];
                break;
            case kSessionStateStop:
                
                hudMessage = [NSString stringWithFormat:@"Sessão Finalizada com sucesso. Saldo: %@", [NSString stringWithTimeInterval:self.session.timeBalance]];
                
                break;
        }

        BDKNotifyHUD *hud = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Start-Icon"] text:hudMessage];
        hud.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        
        // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
        [self.view addSubview:hud];
        [hud presentWithDuration:1.0f speed:0.5f inView:self.view completion:^{
            [hud removeFromSuperview];
        }];
    }
}


#pragma mark - User Interface

- (IBAction)startStopButtonClick:(id)sender {
    
    if (!self.session) {
        
        //Start
        [self startCounter];
        [self scheduleNotifications];
        [self refreshButtons];
        [self refreshStatusView];
        [self refreshClockView];
        [self notifyHUDMessage];
    }
    else
    {
        //Stop
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Deseja realmente finalizar a sessão" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Sim" otherButtonTitles:nil];
        actionSheet.tag = 1;
        [actionSheet showInView:self.view];
        
    }
}

- (IBAction)breakButtonClick:(id)sender {

    if (self.session) {
    
        if (self.session.sessionStateCategory == kSessionStatePaused) {
            [self resumeCounter];
        }
        else {
            [self pauseCounter];
        }
    }

    [self scheduleNotifications];
    [self refreshButtons];
    [self refreshStatusView];
    [self refreshClockView];
    [self notifyHUDMessage];
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

- (void)stopTimer {
    if ((self.timer) || ([self.timer isValid])) {
        [self.timer invalidate];
    }
}

- (void)poolTimer
{
    if (self.session) {
        
        if (self.session.sessionStateCategory == kSessionStatePaused) {
            
            self.clockView.elapsedTime = [self.session.breakTimeInProgress doubleValue];
        }
        else if (self.session.sessionStateCategory == kSessionStateStart)
        {
            self.clockView.elapsedTime = [self.session.workTime doubleValue];
        }
    }
}

- (void)startCounter
{
    if (!_session)
    {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *defaultStartDate = [defaults workStartDate];
        NSString *defaultFinishDate = [defaults workFinishDate];
        NSString *defaultBreakStartDate = [defaults breakStartDate];
        NSString *defaultBreakFinishDate = [defaults breakFinishDate];
        
        NSDate *startDate = [NSDate date];
        
        NSDate *estWorkStartDate = [[[startDate dateAtStartOfDay] dateByAddingHours:[[defaultStartDate substringToIndex:2] intValue]] dateByAddingMinutes:[[defaultStartDate substringFromIndex:3] intValue]];
        
        NSDate *estWorkFinishDate = [[[startDate dateAtStartOfDay] dateByAddingHours:[[defaultFinishDate substringToIndex:2] intValue]] dateByAddingMinutes:[[defaultFinishDate substringFromIndex:3] intValue]];
        
        NSDate *estBreakStartDate = [[[startDate dateAtStartOfDay] dateByAddingHours:[[defaultBreakStartDate substringToIndex:2] intValue]] dateByAddingMinutes:[[defaultBreakStartDate substringFromIndex:3] intValue]];
        
        NSDate *estBreakFinishDate = [[[startDate dateAtStartOfDay] dateByAddingHours:[[defaultBreakFinishDate substringToIndex:2] intValue]] dateByAddingMinutes:[[defaultBreakFinishDate substringFromIndex:3] intValue]];
        
        _session = [Session startSessionWithEstStartDate:estWorkStartDate andEstFinishDate:estWorkFinishDate andEstBreakStartDate:estBreakStartDate andEstBreakFinishDate:estBreakFinishDate];
        
        NSError *error;
        [self.session.managedObjectContext save:&error];
        
        //Salva o ID da sessão ativa
        NSData *sessionURIData = [NSKeyedArchiver archivedDataWithRootObject:self.session.objectID.URIRepresentation];
        [[NSUserDefaults standardUserDefaults] setObject:sessionURIData forKey:@"sessionID"];
    }
    
}

- (void)pauseCounter {
    
    if ((_session) && (_session.sessionStateCategory == kSessionStateStart)) {

        [_session finishActiveInterval];
        [_session setSessionStateCategory:kSessionStatePaused];
        [_session startInterval:kIntervalTypeBreak];
        [self.session.managedObjectContext save:nil];
    }
}

- (void)resumeCounter {
    
    if ((_session) && (_session.sessionStateCategory == kSessionStatePaused)) {
        
        [_session finishActiveInterval];
        [_session setSessionStateCategory:kSessionStateStart];
        [_session startInterval:kIntervalTypeWork];
        [self.session.managedObjectContext save:nil];
    }
}

- (void)stopCounter
{
    
    NSDate *now = [NSDate date];
    
    if (_session) {
        
        [_session finishActiveInterval];
        
        //Finaliza a Sessão
        _session.finishDate = now;
        //_session.workAdjustedTime = [NSNumber numberWithDouble:_session.calculateAdjustedWorkTime];
        _session.sessionStateCategory = kSessionStateStop;
        
        [self.session.managedObjectContext save:nil];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self stopTimer];
        
    }
}

#pragma mark - Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Finalizar a sessão
    if ((actionSheet.tag == 1) && (buttonIndex == actionSheet.destructiveButtonIndex)) {
        [self stopCounter];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self refreshButtons];
        [self refreshStatusView];
        [self refreshClockView];
        [self notifyHUDMessage];
    }
}

#pragma mark - Navigation

- (IBAction)unwindToClockViewController:(UIStoryboardSegue *)unwindSegue
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"intervalListSegue"]) {
        //Passa o evento

        if (self.session) {
            UINavigationController *navigationController = segue.destinationViewController;
            IntervalListTableViewController *intervalListTableViewController = (IntervalListTableViewController * )navigationController.topViewController;
            
            intervalListTableViewController.session = self.session;
        }
    }
}

@end
