//
//  EventProtocol.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EventProtocol <NSObject>

@property (nonatomic, retain) NSDate * estBreakFinish;
@property (nonatomic, retain) NSDate * estBreakStart;
@property (nonatomic, retain) NSDate * estWorkFinish;
@property (nonatomic, retain) NSDate * estWorkStart;

@end
