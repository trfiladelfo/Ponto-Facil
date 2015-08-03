//
//  StringConstants.h
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 17/07/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#define localize(key, default) NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], default, nil)

#pragma mark - Clock View Controller

#define kPFStringClockViewActionSheetTitle localize(@"clockView.actionSheet.title", @"Deseja realmente finalizar a sessão")
#define kPFStringClockViewActionSheetButtonCancelTitle localize(@"clockView.actionSheet.cancelButtonTitle", @"Cancelar")
#define kPFStringClockViewActionSheetButtonDestructiveTitle localize(@"clockView.actionSheet.destructiveButtonTitle", @"Sim")
#define kPFStringClockViewStatusLabelTitleStarted localize(@"clockView.status.started", @"Em andamento")
#define kPFStringClockViewStatusLabelTitlePaused localize(@"clockView.status.paused", @"Intervalo")
#define kPFStringClockViewStatusLabelTitleFinished localize(@"clockView.status.finished", @"Finalizada")
#define kPFStringClockViewStatusLabelTitleNotStarted localize(@"clockView.status.notstarted", @"Não iniciada")

#pragma mark - Interval Detail Controller

#define kPFStringIntervalDetailTableSectionTitleWork localize(@"intervalDetail.tableView.sectionTitle.work", @"Trabalho")
#define kPFStringIntervalDetailTableSectionTitleBreak localize(@"intervalDetail.tableView.sectionTitle.work", @"Intervalo")
#define kPFStringIntervalDetailTableCellLabelStart localize(@"intervalDetail.tableView.cellTitle.start", @"Início")
#define kPFStringIntervalDetailTableCellLabelFinish localize(@"intervalDetail.tableView.cellTitle.finish", @"Fim")

#pragma mark - Event List TableView Controller

#define kPFStringEventListTableViewActionMessageDelete localize(@"eventList.tableView.actionMessage.delete", @"Excluir evento do dia %@")
#define kPFStringEventListTableViewCellLabelEventTypeAbsence localize(@"eventList.tableView.cell.eventType.absence", @"Ausência")
#define kPFStringEventListTableViewCellLabelEventTypeHoliday localize(@"eventList.tableView.cell.eventType.holiday", @"Feriado")
#define kPFStringEventListTableViewCellLabelEventTypeSession localize(@"eventList.tableView.cell.eventType.session", @"Sessão Normal")

#pragma mark - Config View Controller

#define kPFStringConfigTableViewCellLabelToleranceZero localize(@"configView.tableView.cell.tolerance.zero", @"Nenhuma")
#define kPFStringConfigTableViewCellLabelToleranceMinutes localize(@"configView.tableView.cell.tolerance.minutes", @"%2i minutos")

#pragma mark - Schedule View Controller

#define kPFStringScheduleTableViewSectionTitleWork localize(@"schedule.tableView.sectionTitle.work", @"Trabalho")
#define kPFStringScheduleTableViewSectionTitleBreak localize(@"schedule.tableView.sectionTitle.break", @"Intervalo")
#define kPFStringScheduleTableViewCellLabelStart localize(@"schedule.tableView.cellTitle.start", @"Início")
#define kPFStringScheduleTableViewCellLabelFinish localize(@"schedule.tableView.cellTitle.finish", @"Fim")
#define kPFStringScheduleTableViewCellLabelEntrance localize(@"schedule.tableView.cellTitle.entrance", @"Entrada")
#define kPFStringScheduleTableViewCellLabelExit localize(@"schedule.tableView.cellTitle.exit", @"Saída")

#pragma mark - About View Controller

#define kPFStringAboutViewEmailTitle localize(@"about.email.title", @"Dúvidas e Sugestões")

#pragma mark - Overview View Controllee

#define kJBStringLabel2014 localize(@"label.2014", @"2014")
#define kJBStringLabel2013 localize(@"label.2013", @"2013")

#define kJBStringLabelCyclingDistances localize(@"label.cycling.distances", @"Cycling Distances")
#define kJBStringLabelAverageDailyRainfall localize(@"label.average.daily.rainfall", @"Diário")
#define kJBStringLabelMm localize(@"label.mm", @"mm")
#define kJBStringLabelWorkTime localize(@"label.overview.worktime", @"Horas Trabalhadas")
#define kJBStringLabelBalance localize(@"label.overview.balance", @"Resultado")
