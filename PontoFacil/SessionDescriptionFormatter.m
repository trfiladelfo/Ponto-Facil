//
//  SessionDescriptionFormatter.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 09/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "SessionDescriptionFormatter.h"
#import "Session+Management.h"
#import "NSString+TimeInterval.h"

@implementation SessionDescriptionFormatter

- (id)init {

    self = [super init];
    
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"HH:mm";
    }
    
    return self;
}

- (NSString *)sessionStatusMessageFromSession:(Session *)session {
    
    switch (session.sessionStateCategory) {
        
        default:
        case kSessionStateStart:
            return [NSString stringWithFormat:@"Sessão iniciada. Previsão de saída: %@", [self.dateFormatter stringFromDate:session.currentEstWorkFinishDate]];
            break;
        case kSessionStatePaused:
            return [NSString stringWithFormat:@"Em intervalo. Previsão de retorno: %@", [self.dateFormatter stringFromDate:session.currentEstBreakFinishDate]];
            break;
        case kSessionStateStop:
            return [NSString stringWithFormat:@"Sessão Finalizada com sucesso. Saldo: %@", [NSString stringWithTimeInterval:session.timeBalance]];
            break;
    }
}

@end
