//
//  CacheTool.h
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/11.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheTool : NSObject

// 关注帮我找车
+ (NSArray*)updateconcernHelpMeWithData:(NSArray*)dataArray;
+ (NSArray *)queryConcernHelpMe;


// 历史数据查询插入
+ (NSArray*)updateSearchHistoryWithString:(NSString *)string;
+ (NSArray*)deleteHistoryWith:(NSString*)string;
+ (NSArray*)deleteAllHistory;
+ (NSArray *)querySearchHistory;

// 频道缓存
+ (void)addChannelWith:(NSDictionary*)dictionary;
+ (NSArray*)getChannels;
+ (void)deleteChannelWith:(NSString*)string;


/***********分界线***************/
// 推荐频道浏览数据缓存
+(NSArray*)updateRecommendNewsCacheDataHistory:(NSDictionary*)dataArray;
+(NSArray*)queryRecommendNewsDataHistory;

// 最新频道浏览数据缓存
+(NSArray*)updateLastestCacheDataHistory:(NSDictionary*)dataArray;
+(NSArray*)queryLatestHistory;

// 视频频道浏览数据缓存
+(NSArray *)updateVideoCacheDataHistory:(NSDictionary *)dataArray;
+ (NSArray *)queryVideoChannelDataHistory;
// 卖车频道浏览数据缓存
+(NSArray *)updateSellCarCacheDataHistory:(NSDictionary *)dataArray;
+ (NSArray *)querySellCarChannelDataHistory;

// 频道广告数据缓存
+(NSArray *)updateADCacheDataHistory:(NSDictionary *)dataArray;
+ (NSArray *)queryADCacheDataHistory;
@end
