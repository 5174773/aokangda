//
//  ChannelSubView.m
//  MyTool
//
//  Created by xshhanjuan on 15/12/4.
//  Copyright © 2015年 xsh. All rights reserved.
//



/*
 layoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews
 2、addSubview会触发layoutSubviews
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
 4、滚动一个UIScrollView会触发layoutSubviews
 5、旋转Screen会触发父UIView上的layoutSubviews事件
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件
 */



#define BothGap  15
#define SubChannelHeight  35
#define SubChannelInterval  0
#define SubChannelUpdownInterval  4    //上下间距


#define SubChannelStartTag   90000         /** 注意不要和子视图相同 **/

#import "ChannelSubView.h"

#import "ChannelGesView.h"




@interface ChannelSubView ()<ChannelGesViewDelegate>

@end


@implementation ChannelSubView
{
//    NSInteger _channelCount;      // 子频道个数
    float _subChannelWidth;       // 子频道宽度
    float _recordX;
    float _recordY;
    float _recordWidth;
    BOOL _isBeCreate;           // layout 锁
    BOOL _beStartMove;
    BOOL _editState;       // 编辑状态
    
}


-(instancetype)initChannelViewWithWidth:(CGFloat)width X:(CGFloat)X Y:(CGFloat)Y
{
    if (self == [super init]) {
        
        _recordX = X;
        _recordY = Y;
        _recordWidth = width;
        
    }
    
    return self;
}



-(void)setChannels:(NSMutableArray *)channels
{
    _channels = channels;

    [self autoTakeFrame];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    ////
    if (!_isBeCreate) {
        
        if (_channels.count == 0) {
            _isBeCreate = NO;
        }else{
            _isBeCreate = YES;
        }
        
        for (int i = 0; i < _channels.count; i++) {
            
            int deque = i / 4;
            int subChannelLine = i % 4;
            
            CGRect subFrame = CGRectMake(BothGap + subChannelLine * (_subChannelWidth + SubChannelInterval), deque * (SubChannelHeight + SubChannelUpdownInterval), _subChannelWidth, SubChannelHeight);
            
            ChannelGesView *subChannel = [[ChannelGesView alloc]initWithFrame:subFrame];
            subChannel.titleDict = _channels[i];
            subChannel.tag = SubChannelStartTag + i;
            subChannel.delegate = self;
            
            [self addSubview:subChannel];
            
        }
    }
}


// 自动计算self frame值
- (void)autoTakeFrame
{

    CGRect tempFrame = self.frame;
    
    float subChannelWidth = (_recordWidth - (2 * BothGap) - SubChannelInterval * 3) / 4.0f;
    _subChannelWidth = subChannelWidth;
    
    if (_channels.count > 0) {
        
        
       
        NSInteger line = _channels.count / 4 + 1;
        if (_channels.count % 4 == 0) {
            line -= 1;
        }
        MMLog(@"%d   %d",_channels.count,line);
        
        float myChannelHeight = line * SubChannelHeight + (line - 1) * SubChannelUpdownInterval;
        
        self.frame = CGRectMake(_recordX, _recordY, _recordWidth, myChannelHeight);
        
        
    }else{
        self.frame = CGRectZero;
    }
    
    
    if (_beStartMove) {
        if (_delegate && [_delegate respondsToSelector:@selector(moveActionChannelSubView:oldFrame:)]) {
            [_delegate moveActionChannelSubView:self oldFrame:tempFrame];
            
            if (_channels.count == 0) {
                _beStartMove = NO;
            }
        }
    }

}


// 完成状态
-(void)doneAction
{
    _editState = NO;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ChannelGesView class]]) {
            ChannelGesView *gesView = (ChannelGesView *)view;
            [gesView hiddenDeleteView];
        }
    }
}

// 编辑状态
-(void)editAction
{
    _editState = YES;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[ChannelGesView class]]) {
            ChannelGesView *gesView = (ChannelGesView *)view;
            [gesView showDeleteView];
        }
    }
}

-(void)addChannelWithDictionary:(NSDictionary*)dictionary
{
    
        ////
        for (int i = (int)_channels.count - 1; i < _channels.count; i++) {
            
            int deque = i / 4;
            int subChannelLine = i % 4;
            
            CGRect subFrame = CGRectMake(BothGap + subChannelLine * (_subChannelWidth + SubChannelInterval), deque * (SubChannelHeight + SubChannelUpdownInterval), _subChannelWidth, SubChannelHeight);
            
            ChannelGesView *subChannel = [[ChannelGesView alloc]initWithFrame:subFrame];
            subChannel.titleDict = _channels[i];
            subChannel.tag = SubChannelStartTag + i;
            subChannel.delegate = self;
            if (_editState) {
                [subChannel showDeleteView];
            }else{
                [subChannel hiddenDeleteView];
            }
                
            
            
            [self addSubview:subChannel];
            
        }
}





// 移动子频道
-(void)moveStartWithTag:(NSInteger)tag
{
        ////
        ChannelGesView *gesView = [self viewWithTag:tag];
        
        CGRect tagFrame = gesView.frame;
        
        [gesView removeFromSuperview];
        
        
        _beStartMove = YES;
        if (_delegate && [_delegate respondsToSelector:@selector(tapChannelChannelSubView:Dictionary:)]) {
            [_delegate tapChannelChannelSubView:self Dictionary:_channels[tag - SubChannelStartTag]];
        }
        
        [_channels removeObjectAtIndex:(tag - SubChannelStartTag)];
        
        ////
        for (NSInteger i = tag + 1; i < (SubChannelStartTag + _channels.count) + 1; i++) {
            
            ChannelGesView *moveView = [self viewWithTag:i];
            
            CGRect tempFrame = moveView.frame;
            NSInteger tempTag = moveView.tag;
            
            [UIView animateWithDuration:0.5 animations:^{
                moveView.frame = tagFrame;
                moveView.tag = tag;
            } completion:^(BOOL finished) {
                [self autoTakeFrame];
            }];
            
            
            tagFrame = tempFrame;
            tag = tempTag;
        }
        
        if (_channels.count == 0) {
            [self autoTakeFrame];
        }
}



-(void)dealloc
{
    _delegate = nil;
}


@end
