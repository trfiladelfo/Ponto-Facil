//
//  AboutTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 14/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "AboutTableViewController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *marketingVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    self.versionLabel.text = marketingVersion;
    self.buildLabel.text = buildNumber;
    self.osLabel.text = [[UIDevice currentDevice] systemVersion];
}

- (IBAction)rateAppClick:(id)sender {
}


- (IBAction)composeMailClick:(id)sender {
    
    // Email Subject
    NSString *emailTitle = kPFStringAboutViewEmailTitle;
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"pontofacil@mobistart.com.br"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *logDescription;
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            logDescription = @"Mail cancelled";
            break;
        case MFMailComposeResultSaved:
            logDescription = @"Mail saved";
            break;
        case MFMailComposeResultSent:
            logDescription = @"Mail sent";
            break;
        case MFMailComposeResultFailed:
            logDescription = [NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]];
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
