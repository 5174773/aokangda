//
//  RequestManager.h
//  LvXin
//
//  Created by Weiyijie on 15/9/17.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

//网络请求
#define UpLoadPicQuality 0.3
#define loginURl @"http://192.168.1.208:8081/pointLine/app/sendCodeRegister.do"
#define resignURl @"http://192.168.1.208:8081/pointLine/app/register.do"
#define PicURl @" http://192.168.1.208:8081/pointLine/app/uploadAvatar.do"



#define URL_HELP_BASE(path)     @"https://webapi.akd.cn/" path

// 搜索结果
#define URL_Search_Result     URL_HELP_BASE(@"CarList/GetCarListBySearch")

// 搜索结果by word
#define URL_Search_ByWord     URL_HELP_BASE(@"CarWord/getWordList")

// 获取频道
#define URL_GetChannels      @"https://webapi.akd.cn/Channel/GetChannels"

#define URL_Concern_OnSold   URL_HELP_BASE(@"CarList/GetCarFocusList")

// 品牌列表
#define URL_GetBrandList      URL_HELP_BASE(@"CarBrand/GetBrandList")
// 车系列表
#define URL_GetSeriesList      URL_HELP_BASE(@"CarSeries/GetSeriesList")

// 车系列表
#define URL_GetCarStyleList      URL_HELP_BASE(@"CarList/GetCarStyleList")
// 车辆列表
#define URL_GetCarList     URL_HELP_BASE(@"CarList/GetCarList")

// 根据用户选择显示车辆详细信息
#define URL_GetCarListByUser     URL_HELP_BASE(@"CarList/GetCarList")
// 加载用户找车信息
#define URL_GetCustomFocusList   URL_HELP_BASE(@"CarList/GetCustomFocusList/")

// 价格加载
#define URL_GetCarListByParams     URL_HELP_BASE(@"CarList/GetCarListByParams")

typedef void(^Succeed)(NSData * data);
typedef void(^Failed)(NSError *error);

@interface RequestManager : NSObject

/**
 资讯列表
 */
+ (void)informationListWithCategory:(NSString *)_category page:(NSString*)_page succeed:(Succeed)succeed failed:(Failed)failed;
+ (void)PostRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid;

+ (void)concernOnSoldSucceed:(Succeed)succeed andFaild:(Failed)falid;


/**
 搜索
 */

+ (void)searchByWord:(NSString *)word PageIndex:(NSString *)pageIndex  Brand:(NSString *)brand Price:(NSString *)price Type:(NSString *)type Series:(NSString *)series Order:(NSString *)order pageSize:(NSString*)pageSize Succeed:(Succeed)succeed failed:(Failed)failed;

+ (void)autoLinkSearchByWord:(NSString*)word Succeed:(Succeed)succeed failed:(Failed)failed;

/**
 频道
 */
+ (void)getChannelsSucceed:(Succeed)succeed failed:(Failed)failed;

/**
 品牌列表
 */
+ (void)getBrandListSucceed:(Succeed)succeed failed:(Failed)failed;
/**
 车系列表
 */
+ (void)getSeriesListWihtID:(NSString *)ID Succeed:(Succeed)succeed failed:(Failed)failed;
/**
 车辆列表
 */
+(void)getCarListWithSeries:(NSString*)series pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize Succeed:(Succeed)succeed failed:(Failed)failed;
/**
 车型列表
 */
+ (void)getCarStyleListWihtID:(NSString *)ID Succeed:(Succeed)succeed failed:(Failed)failed;
/**
 根据用户选择显示车辆详细信息
 */
+ (void)getCarListByUserWithID:(NSString *)ID Succeed:(Succeed)succeed failed:(Failed)failed;
/**
 加载用户找车信息
 */
+ (void)getCustomFoucusListWithDataArray:(NSArray *)dataArray Succeed:(Succeed)succeed failed:(Failed)failed;
/**
 微信登陆
 */
+ (void)GetRequestWithUrlString:(NSString *)urlString Succeed:(Succeed)succeed andFaild:(Failed)falid;
/**
 加载价格
 */
+ (void)jiageLoadWithPrice:(NSString*)price pageIndex:(NSString*)pageIndex pageSize:(NSString*)pageSize Succeed:(Succeed)succeed failed:(Failed)failed;
/**
 获取车辆详情
 */
+ (void)getCarDetailWithCarId:(NSString *)cardId Succeed:(Succeed)succeed failed:(Failed)failed;

/**
 车辆更多配置
 */
+ (void)getCarConfigWithCarId:(NSString *)cardId Succeed:(Succeed)succeed failed:(Failed)failed;
@end
