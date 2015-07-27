//
//  sessionSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 31/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "Session+Management.h"
#import "EventProtocol.m"
#import "Interval+Management.h"
#import "NSDate-Utilities.h"
#import "Event+Management.h"

@protocol SessionProtocol <NSObject>

@property (nonatomic, retain) NSDate * currentEstWorkFinishDate;
@property (nonatomic, retain) NSDate * currentEstBreakFinishDate;
@property (nonatomic, assign, readonly) double timeBalance;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSDate * startDate;

@property (nonatomic) SessionStateCategory sessionStateCategory;

@end

SpecBegin(Session)

    describe(@"Session", ^{
    
        __block Session *session;
        
        beforeEach(^{
            
            //New session with default values
            session = [[Session alloc] init];
            
            //Redefine initial values
            session.event.estWorkStart = [NSDate todayAtTime:9 andMinute:0];
            session.event.estWorkFinish = [NSDate todayAtTime:18 andMinute:0];
            session.event.estBreakStart = [NSDate todayAtTime:12 andMinute:0];
            session.event.estBreakFinish = [NSDate todayAtTime:13 andMinute:0];
            
        });
        
        afterEach(^{
            session = nil;
        });
        
        it(@"should have a Estimated Work Time", ^{
            expect([session.event.estWorkTime doubleValue]).to.equal(3600*8);
        });
        
        it(@"should have a Estimated Break Time", ^{
            expect([session.event.estBreakTime doubleValue]).to.equal(3600);
        });
        
        it(@"should not have a start date", ^{
            expect(session.startDate).to.beNil();
        });
        
        it(@"should not have a finish date", ^{
            expect(session.finishDate).to.beNil();
        });
        
        describe(@"when it is started", ^{
            
            beforeEach(^ {
                [session start];
            });
            
            it(@"should have a start date", ^{
                expect(session.startDate).toNot.beNil();
            });
            
            it(@"should have a in progress work interval", ^{
                Interval *lastInterval = (Interval *)[[session.intervalList allObjects] lastObject];
                
                expect([lastInterval intervalType]).to.equal(kIntervalTypeWork);
                expect([lastInterval intervalFinish]).to.beNil();
            });
            
            it(@"should have a running status", ^{
                expect(session.sessionState).to.equal(kSessionStateStart);
            });
            
            
        });
        
        describe(@"when it is paused", ^{
            
            beforeEach(^ {
                [session pause];
            });
            
            it(@"should have a in progress break interval", ^{
                Interval *lastInterval = (Interval *)[[session.intervalList allObjects] lastObject];
                
                expect([lastInterval intervalType]).to.equal(kIntervalTypeBreak);
                expect([lastInterval intervalFinish]).to.beNil();
            });
            
            it(@"should have a paused status", ^{
                expect(session.sessionState).to.equal(kSessionStatePaused);
            });
        });
        
        describe(@"when it is stoped", ^{
            
            beforeEach(^ {
                [session stop];
            });
            
            it(@"should have a stop date", ^{
                expect(session.finishDate).toNot.beNil();
            });
            
            it(@"should have a stoped status", ^{
                expect(session.sessionState).to.equal(kSessionStateStop);
            });
        });
        
        
    });

SpecEnd
