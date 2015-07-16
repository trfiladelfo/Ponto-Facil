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
#import "CircularButtonView.h"
#import "ActionButton.h"
#import <BDKNotifyHUD.h>
#import "IntervalListTableViewController.h"
#import "NSString+TimeInterval.h"
#import "NSDate-Utilities.h"
#import "NSUserDefaults+PontoFacil.h"
#import "UIColor+PontoFacil.h"
#import "SessionDescriptionFormatter.h"
#import "LocalNotificationManager.h"

@interface ClockViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) Session *session;

@property (nonatomic, assign) NSUserDefaults *userDefaults;
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, retain) LocalNotificationManager *notificationManager;

@property (strong, nonatomic) BDKNotifyHUD *alertViewProvider;
@property (strong, nonatomic) UIActionSheet *actionSheetProvider;

@end

@implementation ClockViewController


- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"HH:mm"];
        [_formatter setDefaultDate:[NSDate date]];
        [_formatter setTimeZone:[NSTimeZone defaultTimeZone]];
    }
    
    return _formatter;
}

- (LocalNotificationManager *)notificationManager {
    if (!_notificationManager) {
        _notificationManager = [[LocalNotificationManager alloc] init];
    }
    
    return _notificationManager;
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
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self loadActiveSession];
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
    if (([self.session isStoped]) && (![self.session.event.estWorkStart isToday])) {
        self.session = nil;
        [self.userDefaults setActiveSessionID:nil];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)refreshButtons {

    if (self.session) {
        if ([self.session isStarted]) {
            [self.startStopButton setEnabled:true];
            [self.pauseResumeButton setEnabled:true];
            [self.startStopButton setSelected:true];
            [self.pauseResumeButton setSelected:false];
        }
        else if ([self.session isPaused]) {
            [self.startStopButton setEnabled:true];
            [self.pauseResumeButton setEnabled:true];
            [self.startStopButton setSelected:true];
            [self.pauseResumeButton setSelected:true];
        }
        else if ([self.session isStoped]) {
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
        [self.formatter setDateFormat:@"HH:mm"];
        
        self.startDateLabel.text = [self.formatter stringFromDate:self.session.startDate == NULL ? self.session.event.estWorkStart : self.session.startDate];
        
        self.breakTimeLabel.text = [NSString stringWithTimeInterval:[[self.session.breakTime doubleValue] == 0 ? self.session.event.estBreakTime : self.session.breakTime doubleValue]];
        
        self.finishDateLabel.text = [self.formatter stringFromDate:self.session.finishDate == NULL ? (self.session.startDate == NULL ? self.session.event.estWorkFinish : self.session.currentEstWorkFinishDate) : self.session.finishDate];
    }
    else {
        self.startDateLabel.text = [self.userDefaults workStartDate];
        self.finishDateLabel.text = [self.userDefaults workFinishDate];
        self.breakTimeLabel.text = [NSString stringWithTimeInterval:[self.userDefaults defaultBreakTime]];
    }
}

- (void)refreshClockView {

    if (_session) {
        
        if ([self.session isPaused])
        {
            self.clockView.status = @"Intervalo";
            self.clockView.timeLimit = [self.session.event.estBreakTime doubleValue];
            self.clockView.elapsedTime = [self.session.breakTimeInProgress doubleValue];
            [self.clockView setTintColor:[UIColor clockViewPausedColor]];
        }
        else
        {
            if ([self.session isStarted]) {
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


- (void)notifyHUDMessage {
    SessionDescriptionFormatter *sessionFormatter = [[SessionDescriptionFormatter alloc] init];
    [self.alertViewProvider setText:[sessionFormatter sessionStatusMessageFromSession:self.session]];
    [self.alertViewProvider presentWithDuration:1.0f speed:0.5f inView:self.view completion:nil];
}

- (void)scheduleNotifications {
    if (self.session) {
        if ([self.session isStarted]) {
            [self.notificationManager scheduleNotificationsFromType:kLocalNotificationTypeWork withFireDate:[self.session currentEstWorkFinishDate]];
        }
        else if ([self.session isPaused]) {
            [self.notificationManager scheduleNotificationsFromType:kLocalNotificationTypeBreak withFireDate:[self.session currentEstBreakFinishDate]];
        }
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
        [self.actionSheetProvider showInView:self.view];
    }
}

- (IBAction)breakButtonClick:(id)sender {

    if (self.session) {
    
        if ([self.session isPaused]) {
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
        
        if ([self.session isPaused]) {
            
            self.clockView.elapsedTime = [self.session.breakTimeInProgress doubleValue];
        }
        else if ([self.session isStarted])
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
    
    if ((_session) && ([_session isStarted])) {

        [_session pause];
        [self.session.managedObjectContext save:nil];
    }
}

- (void)resumeCounter {
    
    if ((_session) && ([_session isPaused])) {
        
        [_session resume];
        [self.session.managedObjectContext save:nil];
    }
}

- (void)stopCounter
{
    if (_session) {
        
        [_session stop];
        [self.session.managedObjectContext save:nil];
        [self.notificationManager clearNotifications];
        [self stopTimer];
    }
}

#pragma mark - Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //Finalizar a sessão
    if ((actionSheet.tag == 1) && (buttonIndex == actionSheet.destructiveButtonIndex)) {
        [self stopCounter];
        [self.notificationManager clearNotifications];
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
