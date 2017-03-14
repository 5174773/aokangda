//
//  ChannelSubView.h
//  MyTool
//
//  Created by xshhanjuan on 15/12/4.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChannelSubView;

@protocol ChannelSubViewDelegate <NSObject>

@optional

- (void)moveActionChannelSubView:(ChannelSubView*)ChannelSubView oldFrame:(CGRect)oldFrame;

- (void)tapChannelChannelSubView:(ChannelSubView*)ChannelSubView Dictionary:(NSDictionary*)dictionary;

@end



@interface ChannelSubView : UIView

@property (nonatomic,strong) NSMutableArray *channels;         // string type
@property (nonatomic,weak) id<ChannelSubViewDelegate> delegate;


-(instancetype)initChannelViewWithWidth:(CGFloat)width X:(CGFloat)X Y:(CGFloat)Y;

- (void)editAction;
- (void)doneAction;

- (void)addChannelWithDictionary:(NSDictionary*)dictionary;

@end
