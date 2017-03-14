//
//  TSShareShiPinNews.h
//  AoKangDa
//
//  Created by showsoft on 15/12/11.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSShareShiPinNews : NSObject
/** 视频Url */
@property (nonatomic, copy) NSURL *Url;
/** 视频图片 */
@property (nonatomic, copy) NSURL *ImageURL;
/** 视频详情 */
@property (nonatomic, copy) NSString *Content;
/** 视频标题 */
@property (nonatomic, copy) NSString *Title;
@end
