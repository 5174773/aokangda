//
//  SBShowTableView.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SBShowTableView.h"

#import "Public.h"
#import "WholeLineTableViewCell.h"

#define SBTablViewHeight   300
#define SBCellHeight   40

@interface SBShowTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) CGRect startFrame;

@end

@implementation SBShowTableView


-(instancetype)initwithStartFrame:(CGRect)frame
{
    if (self == [super init]) {
        
        _startFrame = frame;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UITableView *tableView = [[UITableView alloc]init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
    _tableView = tableView;
    [self addSubview:tableView];
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    [self addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setDataArray:(NSArray *)dataArray
{
    
    _dataArray = dataArray;
    
    [_tableView reloadData];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    float height = 0;
    
    if (_dataArray.count < 5) {
        
        height = _dataArray.count * SBCellHeight;
    }else{
        height = SBTablViewHeight;
    }
    
    
    float bothGap = 25 + 15;
    float addHeight = (_startFrame.size.height - ButtonGlobalHeight) * 0.4 + ButtonGlobalHeight;
    
    if (_flag == 3) {
        
        _tableView.frame = CGRectMake(_startFrame.origin.x + 5,64 - 4,_startFrame.size.width - 2 * 5, height);
    }else
    {
    
        _tableView.frame = CGRectMake(_startFrame.origin.x + bothGap,30 + ButtonGlobalHeight + 64 + _startFrame.origin.y + addHeight + 8,_startFrame.size.width - bothGap * 2, height);

    }
}


- (void)removeAction
{
#warning ---  后期
    
    _dataArray = nil;
    _tableView = nil;
    [self removeFromSuperview];
    
    
    
    //   __block CGRect frame = _tableView.frame;
    //    frame.size.height = 0;
    //
    //    [UIView animateWithDuration:0.5 animations:^{
    //
    //
    //        _tableView.frame = frame;
    //
    //    } completion:^(BOOL finished) {
    //        MMLog(@"2");
    //        [self removeFromSuperview];
    //        MMLog(@"3");
    //    }];
    
    
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
#warning ---  后期
    //    __block  CGRect frame = _tableView.frame;
    //    frame.size.height = 0;
    //    float tempHeight = frame.size.height;
    //    _tableView.frame = frame;
    //    MMLog(@"4");
    //    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    MMLog(@"5");
    //    [UIView animateWithDuration:4 animations:^{
    //
    //        frame.size.height = tempHeight;
    //        _tableView.frame = frame;
    //    }];
}


#pragma mark - talbviewDatasource
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
    static NSString *cellI  = @"cell";
    WholeLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellI];
    if (cell == nil) {
        cell = [[WholeLineTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellI];
    }
    
    if (_flag == 3) {
        
        cell.textLabel.text = [Header formateString:_dataArray[indexPath.section]];
        
    }else{
    
        NSDictionary *dict = _dataArray[indexPath.section];
        
        cell.textLabel.text = VALUEFORKEY(dict, @"Name");
       
    }
     cell.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_flag == 3) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(SBShowTableViewSelectString::)]) {
            [ _delegate SBShowTableViewSelectString:self :_dataArray[indexPath.section]];
        }
        
    }else{
    
    if (_delegate && [_delegate respondsToSelector:@selector(SBShowTableViewSelect::)]) {
        [_delegate SBShowTableViewSelect:self :_dataArray[indexPath.section]];
    }
    }
    [self removeFromSuperview];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SBCellHeight;
}



@end
