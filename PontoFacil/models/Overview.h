//
//  Overview.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Overview : NSObject

- (instancetype)initWithTitle:(NSString *)title andEventArray:(NSArray *)eventArray;

@property (nonatomic) NSString *title;
@property (nonatomic) int sessionCount;
@property (nonatomic) int absentCount;
@property (nonatomic) int holidayCount;
@property (nonatomic) double timeBalance;
@property (nonatomic) double workTime;

@end
