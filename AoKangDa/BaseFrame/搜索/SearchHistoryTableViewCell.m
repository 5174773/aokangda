//
//  SearchHistoryTableViewCell.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/11.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SearchHistoryTableViewCell.h"


#define BothGap   15

@implementation SearchHistoryTableViewCell
{
    UIImageView *_timeImageView;
    UILabel *_historyLabel;
    UIButton *_deleteButton;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UIImageView *timeImageView = [[UIImageView alloc]init];
    _timeImageView = timeImageView;
    timeImageView.image = [UIImage imageNamed:@"Search_history"];
    [self addSubview:timeImageView];
    
    
    UILabel *historyLabel = [[UILabel alloc]init];
    historyLabel.font = [UIFont systemFontOfSize:15];
    _historyLabel = historyLabel;
    [self addSubview:historyLabel];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    _deleteButton = deleteButton;
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"Search_delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
}

-(void)deleteAction
{
   
    if (_delegate && [_delegate respondsToSelector:@selector(SearchHistoryTableViewCellSelect:)]) {
        [_delegate SearchHistoryTableViewCellSelect:_historyLabel.text];
    }
    
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    _historyLabel.text = _title;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _timeImageView.frame = CGRectMake(BothGap, VIEW_H(self) * 0.3, VIEW_H(self) * 0.4, VIEW_H(self) * 0.4);
    _deleteButton.frame =  CGRectMake(VIEW_W(self) - BothGap - VIEW_H(self) * 0.4, VIEW_H(self) * 0.3, VIEW_H(self) * 0.4, VIEW_H(self) * 0.4);
    _historyLabel.frame = CGRectMake(VIEW_W_X(_timeImageView) + BothGap, 0, VIEW_W(self) - VIEW_W_X(_timeImageView) - VIEW_W(_deleteButton) - 4 * BothGap, VIEW_H(self));
    
}

@end
