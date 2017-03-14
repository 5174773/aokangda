//
//  TSAdvertisementNews.h
//  AoKangDa
//
//  Created by showsoft on 15/12/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSAdvertisementNews : NSObject
//广告ID
@property (nonatomic,strong) NSString *ID;
//汽车广告图片
@property (nonatomic,strong) NSString *ImageUrl;
//广告标题
@property (nonatomic,strong) NSString *Text;
//广告类别
@property (nonatomic,strong) NSString *Type;
//广告图片
@property (nonatomic,strong) NSArray *Ad;
//item链接
@property (nonatomic,strong) NSURL *Url;

@end
