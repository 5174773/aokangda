//
//  TSShipinTableViewCellFrame.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSEHomeViewNews;
@interface TSShipinTableViewCellFrame : NSObject


@property (nonatomic, strong) TSEHomeViewNews *ShipinViewNews;

@property (nonatomic, assign, readonly) CGRect titleViewFrame;
@property (nonatomic, assign, readonly) CGRect imaViewFrame;
/** 时长视图 */
@property (nonatomic, assign, readonly) CGRect totaltimeFrame;


@property (nonatomic, assign, readonly) CGRect fromSourceLableFrame;
@property (nonatomic, assign, readonly) CGRect createTimeLableFrame;
@property (nonatomic, assign, readonly) CGRect collectLabelFrame;
@property (nonatomic, assign, readonly) CGRect collectBtnFrame;
@property (nonatomic, assign, readonly) CGRect shareLableFrame;
@property (nonatomic, assign, readonly) CGRect weChatBtnFrame;
@property (nonatomic, assign, readonly) CGRect friendsBtnFrame;

@property (nonatomic, assign, readonly) CGFloat rowHeight;
@end
