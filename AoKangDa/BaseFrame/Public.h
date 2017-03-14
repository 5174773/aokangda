//
//  Public.h
//  XCAR
//
//  Created by Morris on 9/21/15.
//  Copyright (c) 2015 Samtse. All rights reserved.
//

#ifndef XCAR_Public_h
#define XCAR_Public_h
#define HeadURl @"http://wx.akd.cn:9127/News/GetTuijianCarList/"
// 设置颜色
#define TSEColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]
#define TSEAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//
#define TableViewContentInset 100

//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenWidth5S 320
#define ScreenWidth6 375
#define ScreenWidth6plus 414

// 自定义Log
#ifdef DEBUG
#define TSELog(...) NSLog(__VA_ARGS__)
#else
#define TSELog(...)
#endif



/**
 newsid=1805939 新闻的id
 pubtime=201505 新闻发布时间
 uid=7916227 用户的uid
 */




/** 3.获取所有车品牌 */
#define kGetAllXCarBrandsURL @"http://mi.xcar.com.cn/interface/xcarapp/getBrands.php"

#define kGetSpecialSaleURL @"http://mi.xcar.com.cn/interface/xcarapp/getSpecialSale.php?cityId=348&deviceId=668B4D65-724E-461E-A389-905F158A0871&provinceId=30&uid=7916227"


#define PARAM @"param"
/**
 参数
 param = param
 
 数据分析
 brands 数组 品牌
 icon 车标图片
 keyword 品牌名 （宝马）
 subBrandNum 分类数量 3
 
 subBrands 数组 该品牌的所有分类
 series 数组 该分类的车型
 icon 车型图片
 name 车型名字
 price 价格范围
 subBrandName 分类名字（华晨宝马、宝马(进口)、宝马M）
 
 #define BRANDID @"brandId"
 #define CITYID @"cityId"
 #define PROVINCEID @"provincedId"
 #define SERIESID @"seriesId"
 #define SORTTYPE @"sortType"
 #define kGetDiscountInfoURL @"http://mi.xcar.com.cn/interface/xcarapp/getDiscountList.php"
 // 活动
 #define kGetSalesInfoURL @"http://a.xcar.com.cn/interface/6.0/getEventList.php"
 




 
 
 

 /** 澳康达名车广场 */
/** 0. 获取推荐新闻列表 */

//#define kGetCarNewsURL HeadURl@"index.do"

/** 0.1 刷新的新闻数量 */
#define VIDEOCOUNT @"count"
/** 0.2 刷新状态  */
#define VIDEOPAGESIZE @"pageSize"

/** 1. 获取最新新闻列表 */

/** 1.1 排序ID */
#define LATESTORDER @"order"
/** 1.2 每页条数  */
#define LATESTPAGESIZE @"pageSize"
/** 1.3 列表页码  */
#define LATESTPAGEINDEX @"pageIndex"


/** 澳康达汽车广场 */


/**频道 */
#define kGetChannelNewsURL @"https://webapi.akd.cn/Channel/GetChannels"


/**推荐 */
#define kGetCarNewsURL @"https://webapi.akd.cn/News/GetTuijianCarList"

/**最新 */
#define kGetLaststInfoURL @"https://webapi.akd.cn/CarList/GetCarList"

/**视频 */
#define kGetVideoCarNewsURL @"https://webapi.akd.cn/Shipin/GetShipinCarList"

/**卖车 */
#define kGetCarSellNewsURL @"https://webapi.akd.cn/CarList/GetCarSell"

/**预约保养 */
#define kCallPhoneCarNewsURL @"http://img.akdcar.com/Source/image/2015/12/09/8f7c04c930b645fb98c548b309357998.jpg"

/**文章详情 */
#define kGetArticleDetailURL @"https://webapi.akd.cn/News/GetArticleDetail/4570"

/**车辆详情 */
#define kGetCarsDetailURL @"https://webapi.akd.cn/CarDetail/GetCarDetail/29489"



/**     add              **/

// viewcontroller尺寸
#define ViewScreen_Height   self.view.frame.size.height
#define ViewScreen_Width    self.view.frame.size.width
#define MeSectionHeight   5
#define ButtonGlobalHeight     40
#define MeDefine_Color    RGBACOLOR(216, 82, 18, 1)
#define MeNorMalFontColor    RGBACOLOR(50, 56, 58, 1)
#define MeGlobalBackgroundColor   RGBACOLOR(224, 225, 226, 1)
#define HelpMeTableViewTopHeight   50
#define ConcernTableViewHeight     110
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

#define  SearchBarTag  9876543


#define ChannelAddNotification      @"ChannelAddNotification"
#define ChannelDeleteNotification   @"ChannelDeleteNotification"


#define MyChannelName        @"MyChannelName"
#define LexingChannelName    @"LexingChannelName"
#define PriceChannelName     @"PriceChannelName"
#define PinpaiChannelName    @"PinpaiChannelName"


#endif
