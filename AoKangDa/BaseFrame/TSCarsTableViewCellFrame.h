//
//  TSCarsTableViewCellFrame.h
//  AoKangDa
//
//  Created by showsoft on 15/12/7.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSEHomeViewNews,TSLatestNews;
@interface TSCarsTableViewCellFrame : NSObject

@property (nonatomic,strong) TSLatestNews *latestNews ;
@property (nonatomic, assign, readonly) CGRect imaViewFrame;
@property (nonatomic, assign, readonly) CGRect titleViewFrame;
/** 副标题 */
@property (nonatomic, assign, readonly) CGRect subTitleViewFrame;


@property (nonatomic, assign, readonly) CGRect priceLableFrame;

@property (nonatomic, assign, readonly) CGRect separateFrame;
@property (nonatomic, assign, readonly) CGFloat rowHeight;
@end
