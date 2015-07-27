//
//  AboutTableViewController.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AboutTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *buildLabel;
@property (weak, nonatomic) IBOutlet UILabel *osLabel;

@end
