//
//  EventDetailTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Session;

@interface EventDetailTableViewController : UITableViewController

@property (strong, nonatomic) Session *session;

@end
