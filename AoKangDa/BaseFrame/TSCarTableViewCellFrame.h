//
//  TSCarTableViewCellFrame.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSCarNews;
@interface TSCarTableViewCellFrame : NSObject
@property (nonatomic,strong) TSCarNews *carNews;
/** 标题视图 */

@property (nonatomic, assign, readonly) CGRect titleLabelFrame;
/** 图片视图 */
@property (nonatomic, assign, readonly) CGRect imageViewFrame;
/** 播放按钮 */
@property (nonatomic, assign, readonly) CGRect playBtnFrame;
/** 时长视图 */
@property (nonatomic, assign, readonly) CGRect totaltimeFrame;
/**新闻来源视图 */
@property (nonatomic, assign, readonly) CGRect fromSourceLableFrame;
@property (nonatomic, assign, readonly) CGRect createTimeLableFrame;
@property (nonatomic, assign, readonly) CGRect collectLabelFrame;
@property (nonatomic, assign, readonly) CGRect shareLabelFrame;
@property (nonatomic, assign, readonly) CGRect collectBtnFrame;
@property (nonatomic, assign, readonly) CGRect weChatBtnFrame;
@property (nonatomic, assign, readonly) CGRect friendsBtnFrame;

@property (nonatomic, assign, readonly) CGFloat rowHeight;



@end
