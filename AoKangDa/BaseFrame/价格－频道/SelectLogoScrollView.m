//
//  SelectLogoScrollView.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SelectLogoScrollView.h"
#import "UIImageView+WebCache.h"
#import "Public.h"

#define ButtonStartTag   4200
#define LineStartTag     4400
#define ButtonFont   15
#define BothGap      10
#define LineNormoalColor   [UIColor lightGrayColor]



@implementation SelectLogoScrollView
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
    
//    MMLog(@"11--   %@",_dataArray);
    
    float buttonLineGap = 5;
    float buttonWidth  = 72;
    
    
    float startX = BothGap;
    
    if (_dataArray) {
        
        
        
        
        for (int i = 0; i<_dataArray.count; i++) {
            
            
            CGRect frame = CGRectMake(startX , VIEW_H(self) * 0.275, buttonWidth * 0.45, VIEW_H(self) * 0.45);
            
            //
            UIImageView *carImageView = [[UIImageView alloc]init];
            carImageView.frame = frame;
            carImageView.tag = 0;

            
            [carImageView sd_setImageWithURL:[NSURL URLWithString:VALUEFORKEY(_dataArray[i], @"Image")]];
   
            carImageView.contentMode = UIViewContentModeScaleAspectFill;

            [_scrollView addSubview:carImageView];
            
            //
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(startX , VIEW_H(self) * 0.05, buttonWidth * 0.5, VIEW_H(self) * 0.9)];
             button.tag = ButtonStartTag + i;
            [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
            
            
            startX += VIEW_W(carImageView) + buttonLineGap;
            
            
            
            if (i != _dataArray.count - 1) {
                
                UIView *lineView = [[UIView alloc]init];
                lineView.tag = LineStartTag + i;
                lineView.backgroundColor = LineNormoalColor;
                lineView.frame = CGRectMake(startX, VIEW_H(self) * 0.25, 1, VIEW_H(self) * 0.5);
                [_scrollView addSubview:lineView];
                

                
                startX += VIEW_W(lineView) + buttonLineGap;
            }else{
                startX += BothGap - buttonLineGap;
            }
            
        }
        
    }
    
    
    _scrollView.contentSize = CGSizeMake(startX, 0);
    
    if (_dataArray.count > 0) {
        _selectSort = ButtonStartTag;
        [((UIButton*)[_scrollView viewWithTag:ButtonStartTag]) setSelected:YES];
        [_scrollView viewWithTag:LineStartTag].backgroundColor = MeDefine_Color;
        
    }
    
}


- (void)selectAction:(UIButton *)sender
{
    
    if (sender.tag != ButtonStartTag  && sender.tag != ButtonStartTag + _dataArray.count - 1) {
        
        if (_selectSort != sender.tag) {
            
            for (int i = ButtonStartTag; i < ButtonStartTag + _dataArray.count; i++) {
                
                if (i == sender.tag) {
                    [((UIButton*)[self viewWithTag:i]) setSelected:YES];
        
                }else{
                    [((UIButton*)[self viewWithTag:i]) setSelected:NO];

                }
                
            }
            
            
            for (int i = 0; i < _dataArray.count - 1; i++) {
                if (i == sender.tag - ButtonStartTag - 1 || i == sender.tag - ButtonStartTag) {
                    [_scrollView viewWithTag:LineStartTag + i].backgroundColor = MeDefine_Color;
                }else{
                    
                    [_scrollView viewWithTag:LineStartTag + i].backgroundColor = LineNormoalColor;
                }
                
            }
            
            _selectSort = sender.tag;
        }
        
    }else if (sender.tag == ButtonStartTag){
        
        
        if (_selectSort != sender.tag) {
            
            
            [sender setSelected:YES];

            for (int i = ButtonStartTag + 1; i < ButtonStartTag + _dataArray.count; i++) {
                [((UIButton*)[self viewWithTag:i]) setSelected:NO];
                
            }
            
            
            [_scrollView viewWithTag:LineStartTag].backgroundColor = MeDefine_Color;
            
            for (int i = LineStartTag + 1; i < LineStartTag + _dataArray.count - 1; i++) {
                [_scrollView viewWithTag:i].backgroundColor = LineNormoalColor;
            }
            
            
            _selectSort = sender.tag;
        }
        
        
    }else if (sender.tag == ButtonStartTag + _dataArray.count - 1){
        
        if (_selectSort != sender.tag) {
            
            [sender setSelected:YES];
            
            for (int i = ButtonStartTag; i < ButtonStartTag + _dataArray.count - 1; i++) {
                
                [((UIButton*)[self viewWithTag:i]) setSelected:NO];
            }
            
            [_scrollView viewWithTag:LineStartTag + _dataArray.count - 2].backgroundColor = MeDefine_Color;
            
            for (int i = LineStartTag; i < LineStartTag + _dataArray.count - 2; i++) {
                [_scrollView viewWithTag:i].backgroundColor = LineNormoalColor;
            }
            
            _selectSort = sender.tag;
        }
        
    }
    
    
    MMLog(@"%@",_dataArray[sender.tag - ButtonStartTag]);
    if (_delegate && [_delegate respondsToSelector:@selector(selectLogoScrollViewWith:)]) {
        [_delegate selectLogoScrollViewWith:_dataArray[sender.tag - ButtonStartTag]];
    }
    
}

@end
