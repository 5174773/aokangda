//
//  ChannelGesView.h
//  MyTool
//
//  Created by xshhanjuan on 15/12/4.
//  Copyright © 2015年 xsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChannelGesView;

@protocol ChannelGesViewDelegate <NSObject>

- (void)moveStartWith:(ChannelGesView*)channelGesView Tag:(NSInteger)tag;

@end


@interface ChannelGesView : UIView


@property (nonatomic,strong) NSDictionary *titleDict;

@property (nonatomic,weak)id<ChannelGesViewDelegate> delegate;


- (void)showDeleteView;
- (void)hiddenDeleteView;

@end
