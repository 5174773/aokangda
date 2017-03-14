//
//  TSCarViewNews.h
//  AoKangDa
//
//  Created by showsoft on 15/12/4.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TSCarNews : NSObject

/** 视频ID */
@property (nonatomic, copy) NSString *ID;

/** 视频图片链接 */
@property (nonatomic, copy) NSURL *Image;

/** 视频链接（手机端） */
@property (nonatomic, copy) NSURL *ShipinUrl;

/** 视频发布者 */
@property (nonatomic, copy) NSString *Author;

/** 视频标题 */
@property (nonatomic, copy) NSString *Title;

/** 视频时长 */
@property (nonatomic, copy) NSString* ShipinShichang;

/** 视频发布时间 */
@property (nonatomic, copy) NSString *AddTime;

/** 视频详情 */
@property (nonatomic, copy) NSString *Detail;

/**
 *  视频分享数组(TSShareShiPinNews)
 */@property (nonatomic, copy) NSDictionary *Share;


@end
