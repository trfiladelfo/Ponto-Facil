//
//  ArrayDataSourceSpec.m
//  PontoFacil
//
//  Created by Carlos Eduardo Arantes Ferreira on 10/06/15.
//  Copyright (c) 2015 Mobistart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Specta.h"
#import "Expecta.h"
#import "OCMock.h"
#import "ArrayDataSource.h"

SpecBegin(ArrayDataSource)

    __block id arrayDataSource;

    describe(@"ArrayDataSource", ^{
    
        describe(@"class initializing", ^{
        
            it(@"should not be allowed to init without parameters", ^{
                
                arrayDataSource = [[ArrayDataSource alloc] init];
                
                expect(arrayDataSource).to.beNil();
            });
            
            it(@"should init with items, cell identifier and configuration block", ^{
                
                arrayDataSource = [[ArrayDataSource alloc] initWithItems:@[] cellIdentifier:@"foo" configureCellBlock:^(UITableViewCell *a, id b){}];
                
                expect(arrayDataSource).toNot.beNil();
            });
        });
        
        describe(@"cell configuration", ^{
        
            __block id mockTableView;
            __block id configuredObject;
            __block UITableViewCell *configuredCell;
            
            beforeEach(^{
                TableViewCellConfigureBlock block = ^(UITableViewCell *a, id b){
                    configuredCell = a;
                    configuredObject = b;
                };
                
                arrayDataSource = [[ArrayDataSource alloc] initWithItems:@[@"a", @"b"] cellIdentifier:@"foo" configureCellBlock:block];
                mockTableView = [OCMockObject mockForClass:([UITableView class])];
                
            });
            
            it(@"should return the dummy cell and pass the correct values to the block", ^{
            
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [[[mockTableView expect] andReturn:cell] dequeueReusableCellWithIdentifier:@"foo" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

                [arrayDataSource tableView:mockTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                
                [mockTableView verify];
                
                expect(cell).to.equal(configuredCell);
                expect(@"a").to.equal(configuredObject);
            });
            
            it (@"should return the correct number of rows in tableview", ^{
                expect([arrayDataSource tableView:mockTableView numberOfRowsInSection:0]).to.equal((NSInteger)2);
            });
            
        });
    });

SpecEnd

