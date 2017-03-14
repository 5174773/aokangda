//
//  ConcernSubView.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/11.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "ConcernSubView.h"

#import "ConcernOnSoldTableViewCell.h"

#import "Public.h"


#define SBCellHeight   ConcernTableViewHeight

@interface ConcernSubView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation ConcernSubView

-(instancetype)initWithFrame:(CGRect)frame  dataArray:(NSArray*)dataArray
{
    if (self == [super initWithFrame:frame]) {
        
        _dataArray = dataArray;
        [self initTableViewWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_tableView reloadData];
    }
    return self;
}



- (void)initTableViewWithFrame:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    tableView.bounces = NO;
    _tableView = tableView;
    [self addSubview:tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConcernOnSoldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[ConcernOnSoldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.carInfo = _dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SBCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

@end
