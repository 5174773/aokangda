//
//  TSEHomeViewNews.h
//  XCAR
//
//  Created by Morris on 9/24/15.
//  Copyright (c) 2015 Samtse. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface TSEHomeViewNews : NSObject

/** 文章ID */
@property (nonatomic, strong) NSString *ID;

/** 文章标题 */
@property (nonatomic, strong) NSString *Title;

/** 添加时间） */
@property (nonatomic, strong) NSString *AddTime;

/** 点击率 */
@property (nonatomic, strong) NSString *Clicks;

/** 图片数组*/
@property (nonatomic,strong)NSArray *Image;

/** 图片类型 */
@property (nonatomic, strong) NSString* ImageType;

/** 视频链接地址 */
@property (nonatomic, strong) NSURL *ShipinUrl;

/** 视频时长 */
@property (nonatomic, strong) NSString *ShipinShichang;

/** 车ID */
@property (nonatomic, strong) NSString * CarID;

/** 作者 */
@property (nonatomic, strong) NSString * Author;

/** 分享链接 */
@property (nonatomic, strong) NSDictionary * Share;

@property (nonatomic, assign) NSInteger tag;

@end
