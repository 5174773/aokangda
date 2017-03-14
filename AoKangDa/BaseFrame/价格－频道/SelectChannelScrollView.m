//
//  SelectChannelScrollView.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SelectChannelScrollView.h"

#import "Public.h"

#define ButtonStartTag   4100
#define ButtonFont   14
#define BothGap      10

@implementation SelectChannelScrollView
{
    UIScrollView *_scrollView;
    NSInteger _selectSort;
}

-(instancetype)init
{
    if (self == [super init]) {
        [self initUI];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self initUI];
    }
    
    return self;
}

- (void)initUI
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = CGRectMake(0, 0, VIEW_W(self), VIEW_H(self));
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    
    
    float contentLength = 0;
    
    if (_dataArray) {
        
        float buttonGap = 20;
        
        for (int i = 0; i < _dataArray.count; i++) {
           
          NSString *nameStr = @"";
            if (_flag == 1) {
                nameStr = VALUEFORKEY(_dataArray[i], @"Name");
            }else if (_flag == 2){
                nameStr = VALUEFORKEY(_dataArray[i], @"Text");
            }
            
            
           CGSize size =  [Header getContentHightWithContent:nameStr font:[UIFont systemFontOfSize:ButtonFont] constraint:CGSizeMake(1000, VIEW_H(self))];
            
            CGRect frame = CGRectMake(BothGap, 0, size.width, VIEW_H(self));
            
            if (i != 0) {
                frame = CGRectMake(VIEW_W_X([self viewWithTag:(i + ButtonStartTag - 1)]) + buttonGap, 0, size.width, VIEW_H(self));
            }
            
            if (i == _dataArray.count - 1) {
                contentLength = frame.size.width + frame.origin.x + BothGap;
            }
            
            
            
            UIButton *button = [[UIButton alloc]init];
            button.frame = frame;
            button.tag = ButtonStartTag + i;
            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFont];
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
//            button.backgroundColor = [UIColor redColor];
            
            if (_flag == 1) {
                [button setTitle:VALUEFORKEY(_dataArray[i], @"Name") forState:UIControlStateNormal];
                [button setTitle:VALUEFORKEY(_dataArray[i], @"Name") forState:UIControlStateSelected];
            }else if (_flag == 2){
                [button setTitle:VALUEFORKEY(_dataArray[i], @"Text") forState:UIControlStateNormal];
                [button setTitle:VALUEFORKEY(_dataArray[i], @"Text") forState:UIControlStateSelected];
            }

            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:MeDefine_Color forState:UIControlStateSelected];
            [_scrollView addSubview:button];
        }
        
        _scrollView.contentSize = CGSizeMake(contentLength, 0);
        
        
        
        if (_dataArray.count > 0) {
            _selectSort = ButtonStartTag;
            [((UIButton*)[_scrollView viewWithTag:ButtonStartTag]) setSelected:YES];
        }
    }
}


- (void)selectAction:(UIButton *)sender
{

        if (_selectSort != sender.tag) {
            for (int i = ButtonStartTag; i < ButtonStartTag + _dataArray.count; i++) {
                
                if (i == sender.tag) {
                    [((UIButton*)[self viewWithTag:i]) setSelected:YES];
                }else{
                    [((UIButton*)[self viewWithTag:i]) setSelected:NO];
                }
            }
            
            _selectSort = sender.tag;
        }
    
    MMLog(@"%@   %@",_dataArray[sender.tag - ButtonStartTag],_delegate);
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectChannelScrollViewWith:)]) {
        [_delegate selectChannelScrollViewWith:_dataArray[sender.tag - ButtonStartTag]];
    }
}


@end
