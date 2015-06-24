//
//  ScheduleTableViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 02/05/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "NSUserDefaults+PontoFacil.h"
#import "AccordionTableDictionaryDataSource.h"
#import "CheckTimeTableViewCell.h"

static NSString *const WorkStartKey = @"Entrada";
static NSString *const WorkFinishKey = @"Saída";
static NSString *const BreakStartKey = @"Início";
static NSString *const BreakFinishKey = @"Fim";

static NSString * const cellIdentifier = @"eventTimeCell";

@interface ScheduleTableViewController () <UITableViewDataSource>

@property (nonatomic, strong) AccordionTableDictionaryDataSource *datasource;

@end

@implementation ScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
}

- (void)setupTableView
{
    if (!_datasource) {
        TableViewCellConfigureBlock configureCell = ^(CheckTimeTableViewCell *cell, id item, id detail) {
            cell.eventDescription.text = item;
            cell.timeLabel.text = detail;
        };
        
        [self.tableView registerNib:[UINib nibWithNibName:@"CheckTimeCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        NSDictionary *dictionaryData = [NSDictionary dictionaryWithObjects:[self values] forKeys:[self keys]];
        
        _datasource = [[AccordionTableDictionaryDataSource alloc] initWithTableView:self.tableView andItems:dictionaryData cellIdentifier:cellIdentifier configureCellBlock:configureCell];
    }
    
    self.tableView.dataSource = self.datasource;
}

- (NSArray *)keys
{
    return @[WorkStartKey, WorkFinishKey, BreakStartKey, BreakFinishKey];
}

- (NSArray *)values
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    return @[defaults.workStartDate, defaults.workFinishDate, defaults.breakStartDate, defaults.breakFinishDate];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"Trabalho";
    }
    else if (section == 1)
        return @"Intervalo";
    else
        return @"";
}

@end
