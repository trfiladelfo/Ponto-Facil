//
//  ColorConstants.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define kPFBaseRedColor UIColorFromHex(0xFF0000)
#define kPFBaseBlueColor UIColorFromHex(0x246CC1)

#pragma mark - Navigation

#define kPFColorNavigationBar UIColorFromHex(0x246CC1)
#define kPFColorNavigationTitle [UIColor whiteColor]

#pragma mark - Tableview

#define kPFColorEventCellTitle [UIColor blueColor]
#define kPFColorWeekDateView UIColorFromHex(0x6CA0DD)

#pragma mark - ClockView

#define kPFColorClockViewBlueView UIColorFromHex(0x246CC1)
#define kPFColorClockViewPaused [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0f]
#define kPFColorClockViewInProgress [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]
#define kPFColorClockViewStoped [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]
#define kPFColorClockViewNotStarted [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]

#define kPFColorStatusLabelShadow [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]

#pragma mark - Bar Chart

#define kJBColorBarChartControllerBackground UIColorFromHex(0x313131)
#define kJBColorBarChartBarBlue UIColorFromHex(0x08bcef)
#define kJBColorBarChartBarGreen UIColorFromHex(0x34b234)
#define kJBColorBarChartBackground UIColorFromHex(0x3c3c3c)

#pragma mark - Tooltips

#define kJBColorTooltipColor [UIColor colorWithWhite:1.0 alpha:0.9]
#define kJBColorTooltipTextColor UIColorFromHex(0x313131)
