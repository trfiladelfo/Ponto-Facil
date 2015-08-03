//
//  SessionDescriptionFormatter.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 09/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session;

@interface SessionDescriptionFormatter : NSObject

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

- (NSString *)sessionStatusMessageFromSession:(Session *)session;

@end
