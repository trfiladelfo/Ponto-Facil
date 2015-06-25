//
//  SessionProtocol.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 09/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SessionProtocol <NSObject>

@property (nonatomic, retain) NSDate * currentEstWorkFinishDate;
@property (nonatomic, retain) NSDate * currentEstBreakFinishDate;
@property (nonatomic, assign, readonly) double timeBalance;
@property (nonatomic, retain) NSDate * finishDate;
@property (nonatomic, retain) NSDate * startDate;

@property (nonatomic) SessionStateCategory sessionStateCategory;

@end
