//
//  StringConstants.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 17/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#define localize(key, default) NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], default, nil)

#pragma mark - Labels

#define kJBStringLabel2014 localize(@"label.2014", @"2014")
#define kJBStringLabel2013 localize(@"label.2013", @"2013")

#define kJBStringLabelCyclingDistances localize(@"label.cycling.distances", @"Cycling Distances")
#define kJBStringLabelAverageDailyRainfall localize(@"label.average.daily.rainfall", @"Diário")
#define kJBStringLabelMm localize(@"label.mm", @"mm")
#define kJBStringLabelWorkTime localize(@"label.overview.worktime", @"Horas Trabalhadas")
#define kJBStringLabelBalance localize(@"label.overview.balance", @"Resultado")
