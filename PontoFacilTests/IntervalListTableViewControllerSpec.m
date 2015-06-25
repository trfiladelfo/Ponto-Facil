//
//  IntervalListTableViewControllerSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 11/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "OCMock.h"
#import "IntervalListTableViewController.h"
#import "IntervalTableViewCell.h"

SpecBegin(IntervalListTableViewController)

    describe(@"IntervalListTableViewController", ^{
    
        __block IntervalListTableViewController *intervalListVC;
        
        beforeEach(^{
            
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            intervalListVC = (IntervalListTableViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"intervalListTableViewController"];
            
            UIView *view = intervalListVC.view;
            expect(view).toNot.beNil();
        });
        
        it(@"should have an outlet for the tableView", ^{
            expect(intervalListVC.tableView).toNot.beNil();
            expect(intervalListVC.tableView.dataSource).to.equal(intervalListVC);
            expect(intervalListVC.tableView.delegate).to.equal(intervalListVC);
        });
        
        describe(@"IntervalListTableViewCell", ^{
        
            __block id cell;
            
            beforeEach(^{
                
                cell = [intervalListVC.tableView dequeueReusableCellWithIdentifier:@"intervalCell"];
            
                expect(cell).toNot.beNil();
            });
            
            it(@"should be a IntervalTableViewCell", ^{
                expect(cell).to.beAnInstanceOf([IntervalTableViewCell class]);
            });
            
            it(@"should have an outlet to the start date label", ^{
                expect([cell intervalStartLabel]).toNot.beNil();
            });
            
            it(@"should have an outlet to the finish date label", ^{
                expect([cell intervalFinishLabel]).toNot.beNil();
            });
            
            it(@"should have an outlet to the interval type label", ^{
                expect([cell intervalTypeLabel]).toNot.beNil();
            });

        });
    });

SpecEnd