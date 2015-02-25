//
//  ActionButton.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ActionButton.h"

@implementation ActionButton

-(void)awakeFromNib {
    [self.layer setMasksToBounds:YES];
    self.layer.cornerRadius = 50.0f;
    self.selected = false;
}

- (void)setSelected:(BOOL)selected {
    
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0f];
        [self setImage:[UIImage imageNamed:@"Break-Button"] forState:UIControlStateNormal] ;
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f];
        [self setImage:[UIImage imageNamed:@"Start-Button"] forState:UIControlStateNormal] ;
    }
}

@end
