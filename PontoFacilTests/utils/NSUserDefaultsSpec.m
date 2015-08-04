//
//  UserDefaultsSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 05/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "NSUserDefaults+PontoFacil.h"

SpecBegin(NSUserDefaults)

    describe(@"UserDefaults", ^{
    
        __block NSDateFormatter *dateFormatter;
        __block NSUserDefaults *defaults;
        
        beforeEach(^{
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            defaults = [NSUserDefaults standardUserDefaults];
        });
        
        it(@"should have a valid work start date", ^{
            expect([dateFormatter dateFromString:[defaults workStartDate]]).toNot.beNil();
        });
        
        it(@"should have a valid work finish date", ^{
            NSLog(@"workFinishDate = %@", [defaults workFinishDate]);
            expect([dateFormatter dateFromString:[defaults workFinishDate]]).toNot.beNil();
        });
        
        it(@"should have a valid break start date", ^{
            NSLog(@"breakStartDate = %@", [defaults breakStartDate]);
            expect([dateFormatter dateFromString:[defaults breakStartDate]]).toNot.beNil();
        });
        
        it(@"should have a valid break finish date", ^{
            NSLog(@"breakFinishDate = %@", [defaults breakFinishDate]);
            expect([dateFormatter dateFromString:[defaults breakFinishDate]]).toNot.beNil();
        });
        
        it(@"should have a valid number for advance time for work notification", ^{
            expect([defaults advanceTimeForWorkNotification]).to.beGreaterThanOrEqualTo(0);
        });
        
        it(@"should have a valid number for advance time for break notification", ^{
            expect([defaults advanceTimeForBreakNotification]).to.beGreaterThanOrEqualTo(0);
        });
        
        afterEach(^{
            defaults = nil;
        });
    });

SpecEnd
