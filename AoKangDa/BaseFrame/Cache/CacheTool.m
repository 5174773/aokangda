//
//  CacheTool.m
//  AoKangDa
//
//  Created by xshhanjuan on 15/12/11.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "CacheTool.h"

#import "FMDB.h"



@implementation CacheTool

static FMDatabaseQueue *_queue;

+ (void)setup
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Freecash.sqlite"];
    MMLog(@"path  %@",path);
    
    
    _queue  = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]] ) {
            [db executeUpdate:@"create table if not exists ConcernHelpMeAdd (id integer primary key autoincrement,addData blob);"];
            [db executeUpdate:@"create table if not exists SearchHistory (id integer primary key autoincrement,history text);"];
            [db executeUpdate:@"create table if not exists TitleChannels (id integer primary key autoincrement,title text,channel blob);"];

            
            
            /*****推荐、最新、视频、卖车、广告****/
            [db executeUpdate:@"create table if not exists RecommendNewsCacheDataHistory (id integer primary key autoincrement,LatestData blob);"];
            [db executeUpdate:@"create table if not exists LatestDataHistory (id integer primary key autoincrement,LatestData blob);"];
            [db executeUpdate:@"create table if not exists VideoChannelDataHistory (id integer primary key autoincrement,VideoChannelData blob);"];
            [db executeUpdate:@"create table if not exists SellCarChannelDataHistory (id integer primary key autoincrement,SellCarChannelData blob);"];
            [db executeUpdate:@"create table if not exists ADCacheDataHistory (id integer primary key autoincrement,SellCarChannelData blob);"];
        }
        
    }];
}

// 历史数据查询插入
+ (NSArray*)updateSearchHistoryWithString:(NSString *)string
{
    
    [self setup];
    
    __block NSMutableArray *getArray = [NSMutableArray new];
    
    [_queue inDatabase:^(FMDatabase *db) {
       
        //
        FMResultSet *rs = [db executeQuery:@"select history from SearchHistory where history = ?",string];
        if (rs.next) {
            [db executeUpdate:@"delete from SearchHistory where history = ?",string];
        }
         [rs close];
        
        //
        [db executeUpdate:@"insert into SearchHistory (history) values(?)",string];
        
        
        //
        rs = [db executeQuery:@"select history from SearchHistory"];
        while (rs.next) {
           [getArray addObject:[rs stringForColumn:@"history"]];
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    
    return getArray;
}

+ (NSArray*)deleteHistoryWith:(NSString*)string
{
    [self setup];
    
    __block NSMutableArray *getArray = [NSMutableArray new];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        //
        FMResultSet *rs = [db executeQuery:@"select history from SearchHistory where history = ?",string];
        if (rs.next) {
            [db executeUpdate:@"delete from SearchHistory where history = ?",string];
        }
        [rs close];
        
        //
        rs = [db executeQuery:@"select history from SearchHistory"];
        while (rs.next) {
            [getArray addObject:[rs stringForColumn:@"history"]];
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
}

+ (NSArray*)deleteAllHistory
{
    [self setup];
    
    __block NSMutableArray *getArray = [NSMutableArray new];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"delete from SearchHistory"];

        FMResultSet *rs = [db executeQuery:@"select history from SearchHistory"];
        
        while (rs.next) {
            [getArray addObject:[rs stringForColumn:@"history"]];
            
        }
        
        [rs close];
    }];
    
    return getArray;
}

+ (NSArray *)querySearchHistory
{
    [self setup];
    
    __block NSMutableArray *getArray = [NSMutableArray new];
    
    [_queue inDatabase:^(FMDatabase *db) {
       
        FMResultSet *rs = [db executeQuery:@"select history from SearchHistory"];
        
        while (rs.next) {
            [getArray addObject:[rs stringForColumn:@"history"]];
        }
        
        [rs close];
    }];
    
    return getArray;
}




// 关注帮我找车更新
+ (NSArray*)updateconcernHelpMeWithData:(NSArray*)dataArray
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    NSError *err = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&err];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select addData from ConcernHelpMeAdd"];
        
        if (rs.next) {
            
            [db executeUpdate:@"update ConcernHelpMeAdd set addData = ?",jsonData];
            MMLog(@"ConcernHelpMeAdd");
            
        }else{
            
            [db executeUpdate:@"insert into ConcernHelpMeAdd (addData) values(?)",jsonData];
            MMLog(@"ConcernHelpMeAdd");
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
}

// 关注帮我找车查询
+ (NSArray *)queryConcernHelpMe
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
    
        FMResultSet *rs = [db executeQuery:@"select addData from ConcernHelpMeAdd"];
        
        if (rs.next) {
            NSData *data = [rs dataForColumn:@"addData"];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            getArray = array;
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
    
}
+ (void)addChannelWith:(NSDictionary*)dictionary
{
    
    
    [self setup];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *title = VALUEFORKEY(dictionary, @"Text");
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        
        [db executeUpdate:@"insert into TitleChannels (title,channel) values(?,?)",title,jsonData];
        
        
    }];
    
    [_queue close];
    
    
}

+ (void)deleteChannelWith:(NSDictionary*)string
{
    
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select title from TitleChannels where title = ?",string];
        
        
        if (rs.next) {
            [db executeUpdate:@"delete from TitleChannels where title = ?",string];
        }
        
        [rs close];
    }];
    
    [_queue close];
    
}


+ (NSArray*)getChannels
{
    [self setup];
    
    __block NSMutableArray *getArray = [NSMutableArray new];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select channel from TitleChannels"];
        
        while (rs.next) {
            
            NSData *jsonData = [rs dataForColumn:@"channel"];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            [getArray addObject:dict];
        }
        
        
        [rs close];
    }];
    
    [_queue close];
    
    return getArray;
}


/********************分界线************************/
//推荐频道数据缓存
+(NSArray *)updateRecommendNewsCacheDataHistory:(NSDictionary *)dataArray
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    NSError *err = nil;
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&err];
    
    [_queue inDatabase:^(FMDatabase *db) {
        // 查询数据
        FMResultSet *rs = [db executeQuery:@"select RecommendNewsCacheData from RecommendNewsCacheDataHistory"];
        //插入数据
        if (rs.next) {
            
            [db executeUpdate:@"update RecommendNewsCacheDataHistory set RecommendNewsCacheData = ?",jsonData];
            MMLog(@"RecommendNewsCacheDataHistory");
            
        }else{
            
            [db executeUpdate:@"insert into RecommendNewsCacheDataHistory (RecommendNewsCacheData) values(?)",jsonData];
            MMLog(@"RecommendNewsCacheDataHistory");
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
}

//推荐频道数据获取
+ (NSArray *)queryRecommendNewsDataHistory
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select RecommendNewsCacheData from RecommendNewsCacheDataHistory"];
        
        if (rs.next) {
            NSData *data = [rs dataForColumn:@"RecommendNewsCacheData"];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            getArray = array;
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
    
}

//最新频道数据缓存
+(NSArray *)updateLastestCacheDataHistory:(NSDictionary *)dataArray
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    NSError *err = nil;
 
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&err];
    
    [_queue inDatabase:^(FMDatabase *db) {
        // 查询数据
        FMResultSet *rs = [db executeQuery:@"select LatestData from LatestDataHistory"];
        //插入数据
        if (rs.next) {
            
            [db executeUpdate:@"update LatestDataHistory set LatestData = ?",jsonData];
            MMLog(@"LatestDataHistory");
            
        }else{
            
            [db executeUpdate:@"insert into LatestDataHistory (LatestData) values(?)",jsonData];
            MMLog(@"LatestDataHistory");
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
}

// //最新频道数据获取
+ (NSArray *)queryLatestHistory
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select LatestData from LatestDataHistory"];
        
        if (rs.next) {
            NSData *data = [rs dataForColumn:@"LatestData"];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            getArray = array;
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
    
}
//视频频道数据缓存
+(NSArray *)updateVideoCacheDataHistory:(NSDictionary *)dataArray
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    NSError *err = nil;
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&err];
    
    [_queue inDatabase:^(FMDatabase *db) {
        // 查询数据
        FMResultSet *rs = [db executeQuery:@"select VideoChannelData from VideoChannelDataHistory"];
        //插入数据
        if (rs.next) {
            
            [db executeUpdate:@"update VideoChannelDataHistory set VideoChannelData = ?",jsonData];
            MMLog(@"VideoChannelDataHistory");
            
        }else{
            
            [db executeUpdate:@"insert into VideoChannelDataHistory (VideoChannelData) values(?)",jsonData];
            MMLog(@"VideoChannelDataHistory");
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
}

// ////视频频道数据获取
+ (NSArray *)queryVideoChannelDataHistory
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select VideoChannelData from VideoChannelDataHistory"];
        
        if (rs.next) {
            NSData *data = [rs dataForColumn:@"VideoChannelData"];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            getArray = array;
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
    
}

// 频道广告数据缓存
+(NSArray *)updateADCacheDataHistory:(NSDictionary *)dataArray
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    NSError *err = nil;
    
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted error:&err];
    
    [_queue inDatabase:^(FMDatabase *db) {
        // 查询数据
        FMResultSet *rs = [db executeQuery:@"select ADCacheData from ADCacheDataHistory"];
        //插入数据
        if (rs.next) {
            
            [db executeUpdate:@"update ADCacheDataHistory set ADCacheData = ?",jsonData];
            MMLog(@"ADCacheDataHistory");
            
        }else{
            
            [db executeUpdate:@"insert into ADCacheDataHistory (ADCacheData) values(?)",jsonData];
            MMLog(@"ADCacheDataHistory");
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;
}
// 频道广告数据获取
+(NSArray*)queryADCacheDataHistory
{
    [self setup];
    
    __block NSArray *getArray = nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select ADCacheData from ADCacheDataHistory"];
        
        if (rs.next) {
            NSData *data = [rs dataForColumn:@"ADCacheData"];
            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            getArray = array;
        }
        
        [rs close];
        
    }];
    
    [_queue close];
    
    return getArray;

}
@end
