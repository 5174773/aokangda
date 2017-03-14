//
//  TSGetArticleDetailData.h
//  AoKangDa
//
//  Created by showsoft on 15/12/16.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSGetArticleDetailData : NSObject
@property (nonatomic,strong)NSString *Image;
@property (nonatomic,strong)NSString *AddTime;
@property (nonatomic,strong)NSString *Clicks;
@property (nonatomic,strong)NSString *Details;
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSArray *RelatedNews;
@property (nonatomic,strong)NSString *Author;
@property (nonatomic,strong)NSString *ShipinUrl;
@property (nonatomic,strong)NSString *Title;
@property (nonatomic,strong)NSString *ShipinShichang;
@property (nonatomic,strong)NSDictionary *Share;
@end
