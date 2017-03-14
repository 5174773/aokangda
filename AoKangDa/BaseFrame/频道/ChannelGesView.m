//
//  ChannelGesView.m
//  MyTool
//
//  Created by xshhanjuan on 15/12/4.
//  Copyright © 2015年 xsh. All rights reserved.
//


#define DownViewYRotation  0.1
#define DownViewWidthRotation 0.05
#define DeleteViewWidthRotation   DownViewYRotation * 2

#define ChannelTitlrApla  0.6

#import "ChannelGesView.h"



@implementation ChannelGesView
{
    UIButton *_downView;
    UIView *_deleteView;
}


-(instancetype)init
{
    if (self == [super init]) {
        
        [self setupView];
        
    }
    return self;
}


- (void)setupView
{
    
    UIButton *downView = [[UIButton alloc]init];
    [downView setBackgroundImage:[UIImage imageNamed:@"channel_buttonBackground"] forState:UIControlStateSelected];
    [downView setBackgroundImage:[UIImage imageNamed:@"channel_buttonBackground"] forState:UIControlStateNormal];
    [downView setBackgroundImage:[UIImage imageNamed:@"channel_buttonBackground"] forState:UIControlStateHighlighted];
    [downView setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:ChannelTitlrApla]  forState:UIControlStateNormal];
    downView.titleLabel.font = [UIFont systemFontOfSize:14];
    _downView = downView;
    [self addSubview:downView];
    
    
    UIImageView *deleteView = [[UIImageView alloc]init];
    deleteView.image = [UIImage imageNamed:@"channel_state"];
    deleteView.hidden = YES;
    _deleteView = deleteView;
    [self addSubview:deleteView];
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self setupView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}



- (void)setTitleDict:(NSDictionary *)titleDict
{
    _titleDict = titleDict;
   
    if (titleDict) {
        [_downView setTitle:VALUEFORKEY(titleDict, @"Text") forState:UIControlStateNormal];
        if ([VALUEFORKEY(_titleDict, @"Type") isEqualToString:@"Default"]) {
            
            [_downView addTarget:self action:@selector(selectChannelGesView) forControlEvents:UIControlEventTouchUpInside];
            [_deleteView removeFromSuperview];
            
        }else{
            
            if ([VALUEFORKEY(_titleDict, @"CBvalue") isEqualToString:@"1"]) {
                
                [_downView addTarget:self action:@selector(selectChannelGesView) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
            
            [_downView addTarget:self action:@selector(tapChannelGesView) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    
    CGRect downViewFrame = CGRectMake(frame.size.width * DownViewWidthRotation,frame.size.height * DownViewYRotation, frame.size.width * (1 - 2 * DownViewWidthRotation), frame.size.height * (1 - 2 * DownViewYRotation));
    
    _downView.frame = downViewFrame;
    
    
    if (_deleteView) {
        CGRect deleteFrame = CGRectMake(frame.size.width * (1 - DeleteViewWidthRotation), 0, frame.size.width * DeleteViewWidthRotation,frame.size.width * DeleteViewWidthRotation);
        _deleteView.frame = deleteFrame;
    }
}



- (void)tapChannelGesView
{
 
    
    if (_delegate && [_delegate respondsToSelector:@selector(moveStartWith:Tag:)]) {
        
        [_delegate moveStartWith:self Tag:self.tag];
        
    }
}

- (void)selectChannelGesView
{
    MMLog(@"selected %@",VALUEFORKEY(_titleDict, @"Text"));
}


-(void)showDeleteView
{

    if ([VALUEFORKEY(_titleDict, @"CBvalue") isEqualToString:@"1"]) {
        
        if (_deleteView && _deleteView.hidden == YES) {
            _deleteView.hidden = NO;
            
            if (![VALUEFORKEY(_titleDict, @"Type") isEqualToString:@"Default"]) {
            [_downView removeTarget:self action:@selector(selectChannelGesView) forControlEvents:UIControlEventTouchUpInside];
             [_downView addTarget:self action:@selector(tapChannelGesView) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                 [_downView addTarget:self action:@selector(selectChannelGesView) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
}

-(void)hiddenDeleteView
{
    
    
    if ([VALUEFORKEY(_titleDict, @"CBvalue") isEqualToString:@"1"]) {
        
        if (_deleteView && _deleteView.hidden == NO) {
           
            _deleteView.hidden = YES;
            
        }
        if (![VALUEFORKEY(_titleDict, @"Type") isEqualToString:@"Default"]) {
        [_downView removeTarget:self action:@selector(tapChannelGesView) forControlEvents:UIControlEventTouchUpInside];
        [_downView addTarget:self action:@selector(selectChannelGesView) forControlEvents:UIControlEventTouchUpInside];
        }else{
             [_downView addTarget:self action:@selector(selectChannelGesView) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
   
   
}


-(void)dealloc
{
    _delegate = nil;
}

@end
