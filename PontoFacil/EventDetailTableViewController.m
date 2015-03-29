//
//  EventDetailTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 29/03/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "EventDetailTableViewController.h"

@interface EventDetailTableViewController ()

@end

@implementation EventDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //Alteração
    if (_session) {
        
    }
    else {
        
        //Habilita o botão de cancelar
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender
{

}

@end
