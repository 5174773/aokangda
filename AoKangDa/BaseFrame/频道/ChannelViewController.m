//
//  ChannelViewController.m
//  MyTool
//
//  Created by xshhanjuan on 15/12/4.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import "ChannelViewController.h"

#import "ChannelGesView.h"

#import "Public.h"
#import "CommolTool.h"
#import "CacheTool.h"


#define ChannelViewGap   7
#define SubChannelHeight  40
#define EditButtonTag  1001
#define BothGap  15
#define ChannelTitlrApla  0.6


#define ChannelBackViewStartTag   3400
#define SubChannelStartTag   90000         /** 注意不要和子视图相同 **/


@interface ChannelViewController ()<ChannelGesViewDelegate>


@property (nonatomic,strong) UIView *myChannelView;
@property (nonatomic,strong) UIView *leixingView;
@property (nonatomic,strong) UIView *jiageView;
@property (nonatomic,strong) UIView *pinpaiView;

@property (nonatomic,strong) NSMutableArray *mainChannels;
@property (nonatomic,strong) NSMutableArray *jiageChannels;
@property (nonatomic,strong) NSMutableArray *leixingChannels;
@property (nonatomic,strong) NSMutableArray *pinpaiChannels;

@property (nonatomic,assign) BOOL editState;


@property (nonatomic,strong) NSArray *cahceArray;

@property (nonatomic,strong)UIScrollView *scrollView;


@end

@implementation ChannelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    _mainChannels = [NSMutableArray new];
    _jiageChannels = [NSMutableArray new];
    _pinpaiChannels = [NSMutableArray new];
    _leixingChannels = [NSMutableArray new];
    
    
    
    
    [self createClose];
    [self createUI];
    
    [self firstInit];
    
    
    [self httpRequst];
}


- (void)firstInit
{
    ////
    _cahceArray = [CacheTool getChannels];
    [_mainChannels addObjectsFromArray:[CommolTool getMainChannelS]];
    [_mainChannels addObjectsFromArray:_cahceArray];
    
    
    ////
    [_leixingChannels addObjectsFromArray:[CacheTool queryTypeChannelsWith:LexingChannelName]];
    
    ////
    [_jiageChannels addObjectsFromArray:[CacheTool queryTypeChannelsWith:PriceChannelName]];
    
    ////
    [_pinpaiChannels addObjectsFromArray:[CacheTool queryTypeChannelsWith:PinpaiChannelName]];
    
    
    MMLog(@"channel   %@  \n%@  \n%@  \n%@  \n%@",_mainChannels,_leixingChannels,_jiageChannels,_pinpaiChannels,_cahceArray);
    
    [self resetUIWithState:YES];
}

- (void)createClose
{
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    [closeButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"channel_close"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
    
}

- (void)closeAction:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    
    self.view.backgroundColor = RGBACOLOR(237, 243, 244, 1);
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ViewScreen_Width, ViewScreen_Height - 64)];
    _scrollView.backgroundColor = RGBACOLOR(237, 243, 244, 1);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(0, 0);
    [self.view addSubview:_scrollView];
    
    
    
    float startY = 0;
    
    
    ////
    startY = [self createMyChannelViewWithStartY:startY];
    
    ////
    startY = [self createLeixingViewWithStartY:startY + 12];
    
    
    ////
    startY = [self createJiageViewWithStartY:startY + ChannelViewGap];
    
    ///
    startY = [self createPipaiViewWithStartY:startY + ChannelViewGap];
}

/// 我的频道view
- (float)createMyChannelViewWithStartY:(float)startY
{
    float innerY = 0;
    
    UILabel *myChannelLabel = [[UILabel alloc]initWithFrame:CGRectMake((ViewScreen_Width - 100) * 0.5, innerY, 100, ButtonGlobalHeight)];
    myChannelLabel.text = @"我的频道";
    myChannelLabel.textAlignment = NSTextAlignmentCenter;
    myChannelLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:ChannelTitlrApla];
    
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ViewScreen_Width - BothGap - 40, innerY + ButtonGlobalHeight * 0.25, 40, ButtonGlobalHeight * 0.5)];
    [button setImage:[UIImage imageNamed:@"channel_edit"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"channel_cancel"] forState:UIControlStateSelected];
    button.tag = EditButtonTag;
    [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    ////
    innerY += VIEW_H(myChannelLabel);
    UIView *myChannelView = [[UIView alloc]initWithFrame:CGRectMake(0, innerY, ViewScreen_Width, 0)];
    //    myChannelView.backgroundColor = [UIColor greenColor];
    _myChannelView = myChannelView;
    
    
    ////
    innerY += VIEW_H(myChannelView);
    UIView *myChannelBackView = [[UIView alloc]initWithFrame:CGRectMake(0,startY, ViewScreen_Width,innerY)];
    //        myChannelBackView.backgroundColor = [UIColor greenColor];
    myChannelBackView.tag = ChannelBackViewStartTag + 1;
    [_scrollView addSubview:myChannelBackView];
    
    
    ////
    [myChannelBackView addSubview:myChannelLabel];
    [myChannelBackView addSubview:button];
    [myChannelBackView addSubview:myChannelView];
    
    
    return VIEW_H_Y(myChannelBackView);
}

/// 类型频道view
- (float)createLeixingViewWithStartY:(float)startY
{
    float innerY = 0;
    
    UILabel *moreChannelLabel = [[UILabel alloc]initWithFrame:CGRectMake((ViewScreen_Width - 100) * 0.5, innerY, 100, ButtonGlobalHeight)];
    moreChannelLabel.text = @"更多频道";
    moreChannelLabel.textAlignment = NSTextAlignmentCenter;
    moreChannelLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:ChannelTitlrApla];
    
    
    
    ////
    innerY += VIEW_H(moreChannelLabel) + 15;
    UIView *leixingView = [[UIView alloc]initWithFrame:CGRectMake(0, innerY, ViewScreen_Width, 0)];
    //    leixingView.backgroundColor = [UIColor yellowColor];
    _leixingView = leixingView;
    
    
    ////
    innerY += VIEW_H(leixingView);
    UIView *leixingBackView = [[UIView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, innerY)];
    //        leixingBackView.backgroundColor = [UIColor yellowColor];
    leixingBackView.tag = ChannelBackViewStartTag + 2;
    [_scrollView addSubview:leixingBackView];
    
    
    ////
    [leixingBackView addSubview:moreChannelLabel];
    [leixingBackView addSubview:leixingView];
    
    return VIEW_H_Y(leixingBackView);
}

/// 价格 view
- (float)createJiageViewWithStartY:(float)startY
{
    float innerY = 0;
    
    ///
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, innerY, ViewScreen_Width, 0.5)];
    lineView.backgroundColor = RGBACOLOR(235, 236, 239, 1);
    
    innerY += VIEW_H(lineView) + ChannelViewGap;
    ///
    UIView *jiageView = [[UIView alloc]initWithFrame:CGRectMake(0, innerY, ViewScreen_Width, 0)];
    //    jiageView.backgroundColor = [UIColor orangeColor];
    _jiageView = jiageView;
    
    ///
    innerY += VIEW_H(jiageView);
    UIView *jiageBackView = [[UIView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, innerY)];
    //        jiageBackView.backgroundColor = [UIColor orangeColor];
    jiageBackView.tag = ChannelBackViewStartTag + 3;
    [_scrollView addSubview:jiageBackView];
    
    ///
    [jiageBackView addSubview:lineView];
    [jiageBackView addSubview:jiageView];
    
    return VIEW_H_Y(jiageBackView) + ChannelViewGap;
}

- (float)createPipaiViewWithStartY:(float)startY
{
    float innerY = 0;
    
    ///
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, innerY, ViewScreen_Width, 0.5)];
    lineView.backgroundColor = RGBACOLOR(235, 236, 239, 1);
    
    ///
    innerY += VIEW_H(lineView) + ChannelViewGap;
    UIView *pinpaiView = [[UIView alloc]initWithFrame:CGRectMake(0, innerY, ViewScreen_Width, 0)];
    //    pinpaiView.backgroundColor = [UIColor blueColor];
    _pinpaiView = pinpaiView;
    
    ///
    innerY += VIEW_H(pinpaiView);
    UIView *pinpaiBackView = [[UIView alloc]initWithFrame:CGRectMake(0, startY, ViewScreen_Width, innerY)];
    //    pinpaiBackView.backgroundColor = [UIColor blueColor];
    pinpaiBackView.tag = ChannelBackViewStartTag + 4;
    [_scrollView addSubview:pinpaiBackView];
    
    ///
    [pinpaiBackView addSubview:lineView];
    [pinpaiBackView addSubview:pinpaiView];
    
    return VIEW_H_Y(pinpaiBackView);
}


- (void)action:(UIButton*)sender
{
    if (!sender.selected) {
        
        [sender setSelected:YES];
        
        [self editAction];
        
        
    }else{
        
        [sender setSelected:NO];
        
        [self doneAction];
    }
}




#pragma mark -- httpRequest
- (void)httpRequst
{
    __weak __typeof(self)weakSelf = self;
    
    [RequestManager getChannelsSucceed:^(NSData *data) {
        NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        MMLog(@"channelget     %@",returnDic);
        if (returnDic) {
            //            NSArray *defaultArray = returnDic[@"Default"];
            //            if (defaultArray) {
            //                for (NSDictionary *dict in defaultArray) {
            //
            //                    NSString *getStr = VALUEFORKEY(dict, @"Text");
            //
            //                    if (getStr.length != 0) {
            //
            //                        NSMutableDictionary * defaultDict = [NSMutableDictionary new];
            //                        [defaultDict setObject:getStr forKey:@"Text"];
            //                        [defaultDict setObject:@"1" forKey:@"CBvalue"];
            //                        [defaultDict setObject:@"Default" forKey:@"Type"];
            //
            //                        [_mainChannels addObject:defaultDict];
            //                    }
            //                }
            //            }
            
            NSDictionary *dataDict = returnDic[@"Data"];
            NSArray *tuijianArray = dataDict[@"Tuijian"];
            
            NSMutableArray *tempLexingChannels = [NSMutableArray new];
            NSMutableArray *tempJiageChannels = [NSMutableArray new];
            NSMutableArray *tempPinpaiChannels = [NSMutableArray new];
            
            for (NSDictionary *dict in tuijianArray) {
                
                
                if (![weakSelf judgeHaveCahceWith:VALUEFORKEY(dict, @"Text")]) {
                    
                    NSString *getStr = VALUEFORKEY(dict, @"Text");
                    if (getStr.length != 0) {
                        
                        NSString *type = VALUEFORKEY(dict, @"Type");
                        
                        // CBvalue 纪录是哪种类型频道
                        NSMutableDictionary *tuijianDict = [NSMutableDictionary new];
                        [tuijianDict setObject:getStr forKey:@"Text"];
                        [tuijianDict setObject:VALUEFORKEY(dict, @"Value") forKey:@"Value"];
                        [tuijianDict setObject:VALUEFORKEY(dict, @"ID") forKey:@"ID"];
                        [tuijianDict setObject:@"0" forKey:@"CBvalue"];
                        
                        if ([type isEqualToString:@"pinpai"]) {
                            [tuijianDict setObject:@"pinpai" forKey:@"Type"];
                            [tempPinpaiChannels addObject:tuijianDict];
                            
                        }else if ([type isEqualToString:@"leixing"]){
                            [tuijianDict setObject:@"leixing" forKey:@"Type"];
                            [tempLexingChannels addObject:tuijianDict];
                            
                        }else if ([type isEqualToString:@"jiage"]){
                            [tuijianDict setObject:@"jiage" forKey:@"Type"];
                            [tempJiageChannels addObject:tuijianDict];
                        }
                        
                    }

                }
                
            }
            
            
            _leixingChannels = tempLexingChannels;
            _jiageChannels = tempJiageChannels;
            _pinpaiChannels = tempPinpaiChannels;
            
            
            ////
            for (UIView *subView in _myChannelView.subviews) {
                if ([subView isKindOfClass:[ChannelGesView class]]) {
                    [subView removeFromSuperview];
                }
            }
            
            for (UIView *subView in _leixingView.subviews) {
                if ([subView isKindOfClass:[ChannelGesView class]]) {
                    [subView removeFromSuperview];
                }
            }
            
            for (UIView *subView in _jiageView.subviews) {
                if ([subView isKindOfClass:[ChannelGesView class]]) {
                    [subView removeFromSuperview];
                }
            }
            
            for (UIView *subView in _pinpaiView.subviews) {
                if ([subView isKindOfClass:[ChannelGesView class]]) {
                    [subView removeFromSuperview];
                }
            }
            
            ////
            [CacheTool updateTypeChannelsWithDataArray:_leixingChannels :LexingChannelName];
            [CacheTool updateTypeChannelsWithDataArray:_jiageChannels :PriceChannelName];
            [CacheTool updateTypeChannelsWithDataArray:_pinpaiChannels :PinpaiChannelName];
            
            
            [weakSelf resetUIWithState:YES];
            
        }
    } failed:^(NSError *error) {
        
    }];
}

////
- (BOOL)judgeHaveCahceWith:(NSString*)string
{
    BOOL beHave = NO;
    
    for (NSDictionary *dict in _cahceArray) {
        if ([VALUEFORKEY(dict, @"Text") isEqualToString:string]) {
            beHave = YES;
            
            return beHave;
            
        }
    }
    
    return beHave;
}




- (void)resetUIWithState:(BOOL)state
{
    ////
    float myChannelViewTempHeight = VIEW_H(_myChannelView);
    float leixingViewTempHeight = VIEW_H(_leixingView);
    float jiageViewTempHeight = VIEW_H(_jiageView);
    float pinpaiViewTempHeight = VIEW_H(_pinpaiView);
    
    ////
    float myChannelViewNewHeight = [self autoTakeFrame:_mainChannels withView:_myChannelView state:state];
    float leixingViewNewHeight = [self autoTakeFrame:_leixingChannels withView:_leixingView state:state];
    float jiageViewNewHeight = [self autoTakeFrame:_jiageChannels withView:_jiageView state:state];
    float pinpaiViewNewHeight = [self autoTakeFrame:_pinpaiChannels withView:_pinpaiView state:state];
    
    
    float myDiffer = myChannelViewNewHeight - myChannelViewTempHeight;
    float leixingDiffer = leixingViewNewHeight - leixingViewTempHeight;
    float jiageDiffer = jiageViewNewHeight - jiageViewTempHeight;
    float pinpaiDiffer = pinpaiViewNewHeight - pinpaiViewTempHeight;
    
    [self autoSetFrameWithMyDiffer:myDiffer leixingDiffer:leixingDiffer jiageDiffer:jiageDiffer pinpaiDiffer:pinpaiDiffer];
    
}


// 自动计算self frame值
- (float)autoTakeFrame:(NSArray*)dataArray withView:(UIView*)dataView state:(BOOL)state
{
    float height = 0;
    float subBothGap = 15;
    float SubChannelInterval = 4;
    float SubChannelUpdownInterval = 4;
    
    float subChannelWidth = (ViewScreen_Width - (2 * subBothGap) - SubChannelInterval * 3) / 4.0f;
    
    if (dataArray.count > 0) {
        
        
        
        NSInteger line = dataArray.count / 4 + 1;
        if (dataArray.count % 4 == 0) {
            line -= 1;
        }
        
        
        float myChannelHeight = line * SubChannelHeight + (line - 1) * SubChannelUpdownInterval;
        
        height = myChannelHeight;
        
        
    }
    
    
    if (state) {
        for (int i = 0; i < dataArray.count; i++) {
            
            int deque = i / 4;
            int subChannelLine = i % 4;
            
            CGRect subFrame = CGRectMake(BothGap + subChannelLine * (subChannelWidth + SubChannelInterval), deque * (SubChannelHeight + SubChannelUpdownInterval), subChannelWidth, SubChannelHeight);
            
            
            ChannelGesView *subChannel = [[ChannelGesView alloc]initWithFrame:subFrame];
            subChannel.titleDict = dataArray[i];
            subChannel.tag = SubChannelStartTag + i;
            subChannel.delegate = self;
            
            [dataView addSubview:subChannel];
        }
        
    }
    
    
    
    return height;
}


- (void)autoSetFrameWithMyDiffer:(float)myDiffer leixingDiffer:(float)leixingDiffer jiageDiffer:(float)jiageDiffer pinpaiDiffer:(float)pinpaiDiffer
{
    
    ///
    UIView *mychannelBackView = [self.view viewWithTag:ChannelBackViewStartTag + 1];
    CGRect frame = mychannelBackView.frame;
    frame.size.height += myDiffer;
    mychannelBackView.frame = frame;
    
    frame = _myChannelView.frame;
    frame.size.height += myDiffer;
    _myChannelView.frame = frame;
    
    ///
    UIView *leixingBackView = [self.view viewWithTag:ChannelBackViewStartTag + 2];
    frame = leixingBackView.frame;
    frame.origin.y += myDiffer;
    frame.size.height += leixingDiffer;
    leixingBackView.frame = frame;
    
    frame = _leixingView.frame;
    frame.size.height += leixingDiffer;
    _leixingView.frame = frame;
    
    ///
    UIView *jiageBackView = [self.view viewWithTag:ChannelBackViewStartTag + 3];
    frame = jiageBackView.frame;
    frame.origin.y += myDiffer + leixingDiffer;
    frame.size.height += jiageDiffer;
    jiageBackView.frame = frame;
    
    
    frame = _jiageView.frame;
    frame.size.height += jiageDiffer;
    _jiageView.frame = frame;
    
    ///
    UIView *pinpaiBackView = [self.view viewWithTag:ChannelBackViewStartTag + 4];
    frame = pinpaiBackView.frame;
    frame.origin.y += myDiffer + leixingDiffer + jiageDiffer;
    frame.size.height += pinpaiDiffer;
    pinpaiBackView.frame = frame;
    
    frame = _pinpaiView.frame;
    frame.size.height += pinpaiDiffer;
    _pinpaiView.frame = frame;
    
    
    _scrollView.contentSize = CGSizeMake(0, VIEW_H_Y(pinpaiBackView) + 20);
}


// 完成状态
-(void)doneAction
{
    _editState = NO;
    
    for (UIView *view in _myChannelView.subviews) {
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
    
    for (UIView *view in _myChannelView.subviews) {
        if ([view isKindOfClass:[ChannelGesView class]]) {
            ChannelGesView *gesView = (ChannelGesView *)view;
            [gesView showDeleteView];
        }
    }
}


// 移动子频道
-(void)moveStartWith:(ChannelGesView *)channelGesView Tag:(NSInteger)tag
{
    
    
    
    UIView *firstPView = channelGesView.superview;
    
    NSMutableArray *tempArray = [NSMutableArray new];
    
    if (channelGesView.superview.superview.tag == ChannelBackViewStartTag + 1) {
        tempArray = _mainChannels;
        
    }else if (channelGesView.superview.superview.tag == ChannelBackViewStartTag + 2){
        tempArray = _leixingChannels;
        
    }else if (channelGesView.superview.superview.tag == ChannelBackViewStartTag + 3){
        tempArray = _jiageChannels;
        
    }else if (channelGesView.superview.superview.tag == ChannelBackViewStartTag + 4){
        tempArray = _pinpaiChannels;
        
    }
    
    
    ////
    ChannelGesView *gesView = [firstPView viewWithTag:tag];
    
    CGRect tagFrame = gesView.frame;
    
    [gesView removeFromSuperview];
    
    
    if (firstPView != _myChannelView) {
        [self addChannelWithDictionary:tempArray[tag - SubChannelStartTag]];
    }else {
        [self otherAddChannelWithDictionary:tempArray[tag - SubChannelStartTag]];
    }
    
    [tempArray removeObjectAtIndex:(tag - SubChannelStartTag)];
    
    ////
    for (NSInteger i = tag + 1; i < (SubChannelStartTag + tempArray.count) + 1; i++) {
        
        ChannelGesView *moveView = [firstPView viewWithTag:i];
        
        CGRect tempFrame = moveView.frame;
        NSInteger tempTag = moveView.tag;
        
        [UIView animateWithDuration:0.5 animations:^{
            moveView.frame = tagFrame;
            moveView.tag = tag;
        } completion:^(BOOL finished) {
            [self resetUIWithState:NO];
        }];
        
        
        tagFrame = tempFrame;
        tag = tempTag;
    }
    
    
    ////
    [self resetUIWithState:NO];
    
}


- (void)otherAddChannelWithDictionary:(NSDictionary*)dictionary
{
    
    NSMutableDictionary *tempDict = [dictionary mutableCopy];
    [tempDict setObject:@"0" forKey:@"CBvalue"];
    dictionary = tempDict;
    
    MMLog(@"other  %@  %@",VALUEFORKEY(dictionary, @"Text"),dictionary);
    [CacheTool deleteChannelWith:VALUEFORKEY(dictionary, @"Text")];
    
    
    NSString *type = VALUEFORKEY(dictionary, @"Type");
    if ([type isEqualToString:@"leixing"]) {
        
        [_leixingChannels addObject:dictionary];
        [self addChannelViewWith:_leixingView dataArray:_leixingChannels];
        
    }else if ([type isEqualToString:@"jiage"]){
        
        [_jiageChannels addObject:dictionary];
        [self addChannelViewWith:_jiageView dataArray:_jiageChannels];
        
    }else if ([type isEqualToString:@"pinpai"]){
        
        [_pinpaiChannels addObject:dictionary];
        [self addChannelViewWith:_pinpaiView dataArray:_pinpaiChannels];
        
    }
    
}

-(void)addChannelWithDictionary:(NSDictionary*)dictionary
{
    NSMutableDictionary *tempDict = [dictionary mutableCopy];
    [tempDict setObject:@"1" forKey:@"CBvalue"];
    dictionary = tempDict;
    
    MMLog(@"main  %@  %@",VALUEFORKEY(dictionary, @"Text"),dictionary);
    [CacheTool addChannelWith:dictionary];
   
    
    [_mainChannels addObject:dictionary];
    
    
    [self addChannelViewWith:_myChannelView dataArray:_mainChannels];
    
}


- (void)addChannelViewWith:(UIView*)paternView dataArray:(NSMutableArray*)dataArray
{
    
    
    
    float subBothGap = 15;
    float SubChannelInterval = 4;
    float SubChannelUpdownInterval = 4;
    float subChannelWidth = (ViewScreen_Width - (2 * subBothGap) - SubChannelInterval * 3) / 4.0f;
    
    for (int i = (int)dataArray.count - 1; i < dataArray.count; i++) {
        
        int deque = i / 4;
        int subChannelLine = i % 4;
        
        CGRect subFrame = CGRectMake(BothGap + subChannelLine * (subChannelWidth + SubChannelInterval), deque * (SubChannelHeight + SubChannelUpdownInterval), subChannelWidth, SubChannelHeight);
        
        ChannelGesView *subChannel = [[ChannelGesView alloc]initWithFrame:subFrame];
        subChannel.titleDict = dataArray[i];
        subChannel.tag = SubChannelStartTag + i;
        subChannel.delegate = self;
        if (_editState) {
            [subChannel showDeleteView];
        }else{
            [subChannel hiddenDeleteView];
        }
        
        
        [paternView addSubview:subChannel];
        
    }
}




@end
