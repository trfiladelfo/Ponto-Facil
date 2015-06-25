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
#import "UIColor+PontoFacil.h"
#import "SessionDescriptionFormatter.h"

@interface ClockViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) Session *session;
@property (nonatomic, assign) BOOL sendWorkTimeNotification;
@property (nonatomic, assign) BOOL sendBreakTimeNotification;

@property (nonatomic, assign) BOOL allowNotifications;
@property (nonatomic, assign) BOOL allowNotificationsSound;
@property (nonatomic, assign) BOOL allowNotificationsBadge;
@property (nonatomic, assign) BOOL allowNotificationsAlert;
@property (nonatomic, assign) NSUserDefaults *userDefaults;
@property (strong, nonatomic) BDKNotifyHUD *alertViewProvider;
@property (strong, nonatomic) UIActionSheet *actionSheetProvider;

@end

@implementation ClockViewController

NSString * const NotificationCategoryIdent  = @"ACTIONABLE";
NSString * const NotificationActionOneIdent = @"ACTION_ONE";
NSString * const NotificationActionTwoIdent = @"ACTION_TWO";


- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (BDKNotifyHUD *)alertViewProvider {

    if (!_alertViewProvider) {
        _alertViewProvider = [BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Start-Icon"] text:@""];
        _alertViewProvider.center = CGPointMake(self.view.center.x, self.view.center.y - 20);
        
        // Animate it, then get rid of it. These settings last 1 second, takes a half-second fade.
        [self.view addSubview:_alertViewProvider];
    }
    
    return _alertViewProvider;
}

- (UIActionSheet *)actionSheetProvider {

    if (!_actionSheetProvider) {
        _actionSheetProvider = [[UIActionSheet alloc] initWithTitle:@"Deseja realmente finalizar a sessão" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:@"Sim" otherButtonTitles:nil];
        _actionSheetProvider.tag = 1;
    }
    
    return _actionSheetProvider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForNotification];
}

- (void)viewWillAppear:(BOOL)animated {

    //Load Default Values
    self.sendWorkTimeNotification = [self.userDefaults workFinishNotification];
    self.sendBreakTimeNotification = [self.userDefaults breakFinishNotification];
    
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
    NSData *sessionURIData = [self.userDefaults activeSessionID];
    self.session = [[Session alloc] initSessionFromUri:sessionURIData];
    
    //Se a sessão não é do dia de hoje e o status está finalizado
    if ((self.session.sessionStateCategory == kSessionStateStop) && (![self.session.event.estWorkStart isToday])) {
        self.session = nil;
        [self.userDefaults setActiveSessionID:nil];
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
        
        self.finishDateLabel.text = [formatter stringFromDate:self.session.finishDate == NULL ? (self.session.startDate == NULL ? self.session.event.estWorkFinish : self.session.currentEstWorkFinishDate) : self.session.finishDate];
    }
    else {
        self.startDateLabel.text = [self.userDefaults workStartDate];
        self.finishDateLabel.text = [self.userDefaults workFinishDate];
        self.breakTimeLabel.text = [NSString stringWithTimeInterval:[self.userDefaults defaultBreakTime]];
    }
}

- (void)refreshClockView {

    if (_session) {
        
        if (self.session.sessionStateCategory == kSessionStatePaused)
        {
            self.clockView.status = @"Intervalo";
            self.clockView.timeLimit = [self.session.event.estBreakTime doubleValue];
            self.clockView.elapsedTime = [self.session.breakTimeInProgress doubleValue];
            [self.clockView setTintColor:[UIColor clockViewPausedColor]];
        }
        else
        {
            if (self.session.sessionStateCategory == kSessionStateStart) {
                self.clockView.status = @"Em andamento";
                [self.clockView setTintColor:[UIColor clockViewInProgressColor]];
            }
            else
            {
                self.clockView.status = @"Finalizada";
                
                [self.clockView setTintColor:[UIColor clockViewStopedColor]];
            }
            
            self.clockView.timeLimit = [self.session.event.estWorkTime doubleValue];
            self.clockView.elapsedTime = [self.session.workTime doubleValue];
        }
    }
    else {
    
        self.clockView.timeLimit = [self.userDefaults defaultWorkTime];
        self.clockView.status = @"Não iniciada";
        self.clockView.elapsedTime = 0;
        
        [self.clockView setTintColor:[UIColor clockViewNotStartedColor]];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleEventListNotification) name:@"eventListNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScheduleNewNotification) name:@"scheduleNewNotification" object:nil];
}

- (void)scheduleNotifications {
    
    if (self.session) {
        
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        if (self.session.sessionStateCategory == kSessionStateStart) {
            
            //Todo: Notificação de 15 minutos só deve ser reeschedulada se ainda não tiver sido disparada
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStateStart andMessage:@"Seu expediente irá terminar em 15 minutos" andDate:[_session.currentEstWorkFinishDate dateBySubtractingMinutes:15] andRepeatInterval:false];
            
            //NSLog(@"1-Notifications count = %i", [[[UIApplication sharedApplication] scheduledLocalNotifications] count]);
            
            [self scheduleNotificationWithID:_session.objectID andState:kSessionStateStart andMessage:@"Fim do expediente!" andDate:_session.currentEstWorkFinishDate andRepeatInterval:true];
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
    SessionDescriptionFormatter *sessionFormatter = [[SessionDescriptionFormatter alloc] init];
    [self.alertViewProvider setText:[sessionFormatter sessionStatusMessageFromSession:self.session]];
    [self.alertViewProvider presentWithDuration:1.0f speed:0.5f inView:self.view completion:nil];
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
        [self.actionSheetProvider showInView:self.view];
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

- (IBAction)reviewButtonClick:(id)sender {
    
    [self performSegueWithIdentifier:@"intervalListSegue" sender:self];
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
        _session = [[Session alloc] init];
        [_session start];
        
        NSError *error;
        [self.session.managedObjectContext save:&error];
        
        //Salva o ID da sessão ativa
        NSData *sessionURIData = [NSKeyedArchiver archivedDataWithRootObject:self.session.objectID.URIRepresentation];
        [self.userDefaults setActiveSessionID:sessionURIData];
    }
    
}

- (void)pauseCounter {
    
    if ((_session) && (_session.sessionStateCategory == kSessionStateStart)) {

        [_session pause];
        [self.session.managedObjectContext save:nil];
    }
}

- (void)resumeCounter {
    
    if ((_session) && (_session.sessionStateCategory == kSessionStatePaused)) {
        
        [_session resume];
        [self.session.managedObjectContext save:nil];
    }
}

- (void)stopCounter
{
    if (_session) {
        
        [_session stop];
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
