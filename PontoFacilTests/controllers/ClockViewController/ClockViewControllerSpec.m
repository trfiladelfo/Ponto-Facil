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
            clockVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ClockViewController"];
            
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
        
    });

SpecEnd
