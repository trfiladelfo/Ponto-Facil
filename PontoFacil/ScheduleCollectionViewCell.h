//
//  ScheduleCollectionViewCell.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 25/02/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCollectionViewCell : UICollectionViewCell

@property (nonatomic) NSInteger day;
@property (nonatomic) BOOL isHighlighted;
@property (nonatomic) BOOL hasEvents;

@end
