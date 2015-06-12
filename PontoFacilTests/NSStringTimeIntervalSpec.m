//
//  NSStringTimeIntervalSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 05/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "NSString+TimeInterval.h"

SpecBegin(NSStringTimeInterval)

    describe(@"NSStringTimeInterval", ^{

        it(@"should format positive values", ^{
            expect([NSString stringWithTimeInterval:3600]).to.equal(@"01:00");
        });
        
        it(@"should format negative values", ^{
            expect([NSString stringWithTimeInterval:-7200]).to.equal(@"-02:00");
        });
    });

SpecEnd

