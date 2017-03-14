//
//  TSThreeTableViewCellFrame.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSEHomeViewNews;
@interface TSThreeTableViewCellFrame : NSObject


@property (nonatomic, strong) TSEHomeViewNews *ThreeViewNews;

@property (nonatomic, assign, readonly) CGRect titleViewFrame;
@property (nonatomic, assign, readonly) CGRect oneimaViewFrame;
@property (nonatomic, assign, readonly) CGRect twoimaViewFrame;
@property (nonatomic, assign, readonly) CGRect threeimaViewFrame;
@property (nonatomic, assign, readonly) CGRect fromSourceLableFrame;
@property (nonatomic, assign, readonly) CGRect createTimeLableFrame;
@property (nonatomic, assign, readonly) CGRect collectLabelFrame;
@property (nonatomic, assign, readonly) CGRect collectBtnFrame;
@property (nonatomic, assign, readonly) CGRect shareLableFrame;
@property (nonatomic, assign, readonly) CGRect weChatBtnFrame;
@property (nonatomic, assign, readonly) CGRect friendsBtnFrame;

@property (nonatomic, assign, readonly) CGFloat rowHeight;

@end
