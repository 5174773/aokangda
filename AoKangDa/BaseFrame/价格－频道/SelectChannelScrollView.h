//
//  SelectChannelScrollView.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectChannelScrollViewDelegate <NSObject>

@optional
- (void)selectChannelScrollViewWith:(NSDictionary*)dictionary;

@end


@interface SelectChannelScrollView : UIView


@property (nonatomic,assign) NSInteger flag;    // 1 品牌， // 2 价格
@property (nonatomic,weak) id<SelectChannelScrollViewDelegate>delegate;
@property (nonatomic,strong) NSArray *dataArray;

@end
