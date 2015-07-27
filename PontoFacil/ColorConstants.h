//
//  ColorConstants.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 16/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#pragma mark - Navigation

#define kPFColorNavigationBar UIColorFromHex(0x1297DD)
#define kPFColorNavigationTitle [UIColor whiteColor]

#pragma mark - Tableview

#define kPFColorEventCellTitle [UIColor blueColor]
#define kPFColorWeekDateView [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]

#pragma mark - ClockView

#define kPFColorClockViewBlueView UIColorFromHex(0x1297DD)
#define kPFColorClockViewPaused [UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0f]
#define kPFColorClockViewInProgress [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]
#define kPFColorClockViewStoped [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]
#define kPFColorClockViewNotStarted [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]

#define kPFColorStatusLabelShadow [UIColor colorWithRed:25/255.0 green:187/255.0 blue:155/255.0 alpha:1.0f]

#pragma mark - Bar Chart

#define kJBColorBarChartBarBlue UIColorFromHex(0x08bcef)
#define kJBColorBarChartBarGreen UIColorFromHex(0x34b234)
#define kJBColorBarChartBackground UIColorFromHex(0x3c3c3c)

#pragma mark - Line Chart

#define kJBColorLineChartControllerBackground UIColorFromHex(0xb7e3e4)
#define kJBColorLineChartBackground UIColorFromHex(0xb7e3e4)
#define kJBColorLineChartHeader UIColorFromHex(0x1c474e)
#define kJBColorLineChartHeaderSeparatorColor UIColorFromHex(0x8eb6b7)
#define kJBColorLineChartDefaultSolidLineColor [UIColor colorWithWhite:1.0 alpha:0.5]
#define kJBColorLineChartDefaultSolidSelectedLineColor [UIColor colorWithWhite:1.0 alpha:1.0]
#define kJBColorLineChartDefaultDashedLineColor [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]
#define kJBColorLineChartDefaultDashedSelectedLineColor [UIColor colorWithWhite:1.0 alpha:1.0]

#pragma mark - Tooltips

#define kJBColorTooltipColor [UIColor colorWithWhite:1.0 alpha:0.9]
#define kJBColorTooltipTextColor UIColorFromHex(0x313131)
