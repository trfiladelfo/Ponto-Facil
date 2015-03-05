//
//  ScheduleViewController.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleCollectionViewCell.h"

@interface ScheduleViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 30;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 12;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"scheduleCell" forIndexPath:indexPath];
    cell.day = indexPath.row+1;
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
