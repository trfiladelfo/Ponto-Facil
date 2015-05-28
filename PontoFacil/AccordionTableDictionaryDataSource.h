//
//  AccordionTableDictionaryDataSource.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 27/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DatePickerTableViewCell.h"

typedef void (^TableViewCellConfigureBlock)(id cell, id title, id subtitle);

@interface AccordionTableDictionaryDataSource : NSObject <UITableViewDataSource, UITableViewDelegate, DatePickerTableViewCellDelegate>

- (id)initWithTableView:(UITableView *)tableView andItems:(NSDictionary *)items
         cellIdentifier:(NSString *)cellIdentifier
     configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

@end
