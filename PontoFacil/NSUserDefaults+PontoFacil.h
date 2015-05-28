//
//  NSUserDefaults+PontoFacil.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 26/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (PontoFacil)

@property (nonatomic, assign) BOOL isLoaded;
@property (nonatomic, strong) NSString *workStartDate;
@property (nonatomic, strong) NSString *workFinishDate;
@property (nonatomic, strong) NSString *breakStartDate;
@property (nonatomic, strong) NSString *breakFinishDate;
@property (nonatomic, assign) double defaultWorkTime;
@property (nonatomic, assign) double defaultBreakTime;
@property (nonatomic, assign) BOOL breakTimeRequired;
@property (nonatomic, assign) NSInteger toleranceTime;
@property (nonatomic, assign) BOOL workFinishNotification;
@property (nonatomic, assign) BOOL breakFinishNotification;

@end
