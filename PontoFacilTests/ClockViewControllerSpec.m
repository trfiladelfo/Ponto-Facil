//
//  ClockViewControllerSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 06/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "ClockViewController_Spec.h"
#import "ActionButton.h"
#import "Session+Management.h"
#import "OCMock.h"
#import <BDKNotifyHUD.h>
#import "NSUserDefaults+PontoFacil.h"

SpecBegin(ClockViewControllerSpec)

    describe(@"ClockViewController", ^{
    
        __block ClockViewController *clockVC;
        
        beforeEach(^{
        
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *mainTabController = [mainStoryBoard instantiateInitialViewController];
            clockVC = (ClockViewController *)[mainTabController.viewControllers objectAtIndex:0];
            
            UIView *view = clockVC.view;
            expect(view).toNot.beNil();
        });
        
        it(@"should be instantiated from the storyboard" , ^{
        
            expect(clockVC).toNot.beNil();
            expect(clockVC).to.beInstanceOf([ClockViewController class]);
        });
        
        it(@"should have an outlet to the clock view", ^{
            expect(clockVC.clockView).toNot.beNil();
        });
        
        it(@"should have a start stop button", ^{
            expect(clockVC.startStopButton).toNot.beNil();
            //expect(clockVC.startStopButton).to.beAMemberOf([UIButton class]);
        });
        
        it(@"should have a pause resume button", ^{
            expect(clockVC.pauseResumeButton).toNot.beNil();
            expect(clockVC.pauseResumeButton).to.beAnInstanceOf([UIButton class]);
        });
        
        it(@"should have a review button", ^{
            expect(clockVC.reviewButton).toNot.beNil();
            expect(clockVC.reviewButton).to.beAnInstanceOf([UIButton class]);
        });
            
        it(@"should have a start date label", ^{
            expect(clockVC.startDateLabel).toNot.beNil();
            expect(clockVC.startDateLabel).to.beAnInstanceOf([UILabel class]);
        });
        
        it(@"should have a break time label", ^{
            expect(clockVC.breakTimeLabel).toNot.beNil();
            expect(clockVC.breakTimeLabel).to.beAnInstanceOf([UILabel class]);
        });
        
        it(@"should have a finish date label", ^{
            expect(clockVC.finishDateLabel).toNot.beNil();
            expect(clockVC.finishDateLabel).to.beAnInstanceOf([UILabel class]);
        });
        
        it(@"should wire up the startButtonClick action", ^{
            UIButton *startButton = (UIButton *)clockVC.startStopButton;
            NSString *selectorString = NSStringFromSelector(@selector(startStopButtonClick:));
            expect([startButton actionsForTarget:clockVC forControlEvent:UIControlEventTouchUpInside]).to.equal(@[selectorString]);
        });
        
        it(@"should wire up the breakButtonClick action", ^{
            UIButton *breakButton = (UIButton *)clockVC.pauseResumeButton;
            NSString *selectorString = NSStringFromSelector(@selector(breakButtonClick:));
            expect([breakButton actionsForTarget:clockVC forControlEvent:UIControlEventTouchUpInside]).to.equal(@[selectorString]);
        });
        
        it(@"should wire up the reviewButtonClick action", ^{
            UIButton *reviewButton = (UIButton *)clockVC.reviewButton;
            NSString *selectorString = NSStringFromSelector(@selector(reviewButtonClick:));
            expect([reviewButton actionsForTarget:clockVC forControlEvent:UIControlEventTouchUpInside]).to.equal(@[selectorString]);
            
        });
        
        /*
        describe(@"status view", ^{
        
            __block id _userDefaults;
            
            beforeEach(^{
                _userDefaults = OCMClassMock([NSUserDefaults class]);
                OCMStub([_userDefaults stringForKey:@"workStartDate"]).andReturn(@"09:01");
                OCMStub([_userDefaults stringForKey:@"workFinishDate"]).andReturn(@"09:01");
                OCMStub([_userDefaults stringForKey:@"breakStartDate"]).andReturn(@"09:01");
                OCMStub([_userDefaults stringForKey:@"breakFinishDate"]).andReturn(@"09:01");
                OCMStub([_userDefaults standardUserDefaults]).andReturn(_userDefaults);
                
                clockVC.userDefaults = _userDefaults;
                clockVC.session = nil;
            });
            
            it(@"should show the default value on start label", ^{
                expect(clockVC.startDateLabel.text).to.equal(@"09:00");
            });
            
            it(@"should show the default value on break label", ^{
                expect(clockVC.breakTimeLabel.text).to.equal(@"01:00");
            });
            
            it(@"should show the default value on finish label", ^{
                expect(clockVC.finishDateLabel.text).to.equal(@"18:00");
            });
            
        });
        */
        
        describe(@"tapping the action button", ^{

            __block id _session;
            
            context(@"when start button is visible", ^{
            
                __block id _alertViewProvider;
                
                beforeEach(^{
                    _alertViewProvider = [OCMockObject partialMockForObject:[BDKNotifyHUD notifyHUDWithImage:[UIImage imageNamed:@"Start-Icon"] text:@""]];
                    clockVC.alertViewProvider = _alertViewProvider;
                    
                    clockVC.startStopButton.selected = false;
                    clockVC.startStopButton.enabled = true;
                    clockVC.session.sessionStateCategory = kSessionStateStop;
                });
                it(@"should show an alert", ^{
                    
                    [[_alertViewProvider expect] setText:[OCMArg any]];
                    [[_alertViewProvider expect] presentWithDuration:1.0f speed:0.5f inView:clockVC.view completion:nil];
                    
                    [clockVC startStopButtonClick:nil];
                    
                    [_alertViewProvider verify];
                    [_session verify];
                });

            });

            context(@"when stop button is visible", ^{
                
                __block id _actionSheetPopup;
                __block Session *_session;
                
                beforeEach(^{
                    _actionSheetPopup = [OCMockObject partialMockForObject:[[UIActionSheet alloc] initWithTitle:@"Deseja realmente finalizar a sessão" delegate:clockVC cancelButtonTitle:[OCMArg any] destructiveButtonTitle:[OCMArg any] otherButtonTitles:nil]];
                    clockVC.actionSheetProvider = _actionSheetPopup;
                    
                    _session = [[Session alloc] init];
                    [_session start];
                    
                    clockVC.startStopButton.selected = true;
                    clockVC.startStopButton.enabled = true;
                    clockVC.session = _session;
                });
                
                it(@"should show a confirmation UIActionSheet Popup", ^{
                    
                    [[_actionSheetPopup expect] showInView:clockVC.view];
                    [clockVC startStopButtonClick:nil];
                    
                    [_actionSheetPopup verify];
                });
                
            });

        });
        
        describe(@"tapping the event list button", ^{
        
            __block id mockClockVC;
            
            beforeEach(^{
                mockClockVC = [OCMockObject partialMockForObject:clockVC];
            });
            
            it(@"should segue to intervalListSegue", ^{
            
                [[mockClockVC expect]  performSegueWithIdentifier:@"intervalListSegue" sender:clockVC];
                
                [clockVC.reviewButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                
                [mockClockVC verify];
            });
        });
    });

SpecEnd
