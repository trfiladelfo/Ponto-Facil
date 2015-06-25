//
//  SessionDescriptionFormatterSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 09/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "OCMock.h"
#import "SessionDescriptionFormatter.h"
#import "Session+Management.h"
#import "NSDate-Utilities.h"
#import "SessionProtocol.h"

SpecBegin(SessionDescriptionFormatter)

    describe(@"SessionDescriptionFormatter", ^{
    
        __block SessionDescriptionFormatter *sessionFormatter;
        __block id mockSession;
        
        beforeEach(^{
            sessionFormatter = [[SessionDescriptionFormatter alloc] init];
            mockSession = [OCMockObject mockForProtocol:@protocol(SessionProtocol)];
        });
        
        it(@"should return a formatated start message", ^{
            
            [[[mockSession stub] andReturnValue:[NSNumber numberWithInt:kSessionStateStart]] sessionStateCategory];
            [[[mockSession stub] andReturn:[NSDate todayAtTime:18 andMinute:0]] currentEstWorkFinishDate];
            
            expect([sessionFormatter sessionStatusMessageFromSession:mockSession]).to.equal(@"Sessão iniciada. Previsão de saída: 18:00");
        });
        
        it(@"should return a formatated break message", ^{
            
            [[[mockSession stub] andReturnValue:[NSNumber numberWithInt:kSessionStatePaused]] sessionStateCategory];
            [[[mockSession stub] andReturn:[NSDate todayAtTime:13 andMinute:0]] currentEstBreakFinishDate];
            
            expect([sessionFormatter sessionStatusMessageFromSession:mockSession]).to.equal(@"Em intervalo. Previsão de retorno: 13:00");
        });
        
        it(@"should return a formatated stop message", ^{
            
            [[[mockSession stub] andReturnValue:[NSNumber numberWithInt:kSessionStateStop]] sessionStateCategory];
            [[[mockSession stub] andReturnValue:[NSNumber numberWithInt:600]] timeBalance];
            
            expect([sessionFormatter sessionStatusMessageFromSession:mockSession]).to.equal(@"Sessão Finalizada com sucesso. Saldo: 00:10");
        });
        
    });

SpecEnd
