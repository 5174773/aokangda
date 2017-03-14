//
//  TSGetCarDetailMetaData.h
//  AoKangDa
//
//  Created by showsoft on 15/12/16.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSGetCarDetailMetaData : NSObject
/** 品牌Logo**/
@property (nonatomic,strong) NSURL    *CarBrandLogo;
/** 车名**/
@property (nonatomic,strong) NSString *CarName;
/** 上牌时间**/
@property (nonatomic,strong) NSString *EnterDate;
/** 公里数**/
@property (nonatomic,strong) NSString *KMNum;
/** 排量**/
@property (nonatomic,strong) NSString *Emissions;
/** 车辆展示大图**/
@property (nonatomic,strong) NSString *FirstImage;
/** 是否为无质保车**/
@property (nonatomic,strong) NSString *IsWZBC;
/** 特价**/
@property (nonatomic,strong) NSString *WZBCSpecialPrice;
/** 价格状态**/
@property (nonatomic,strong) NSString *SalePriceState;
/** 市价**/
@property (nonatomic,strong) NSString *SalePrice;
/** 原新车价**/
@property (nonatomic,strong) NSString *ReferencePriceTitle;
/** 燃油**/
@property (nonatomic,strong) NSString *FuelOil;
/** 变速箱**/
@property (nonatomic,strong) NSString *Transmission;
/** 产 地**/
@property (nonatomic,strong) NSString *ProdAddr;
/** 驱动形式**/
@property (nonatomic,strong) NSString *DriveType;
/** 过户手续**/
@property (nonatomic,strong) NSString *DataTransfer;
/** 内饰颜色**/
@property (nonatomic,strong) NSString *InsideColor;
/** 座位数**/
@property (nonatomic,strong) NSString *SeatNum;
/** 座椅**/
@property (nonatomic,strong) NSString *Chair;
/** 所属品牌**/
@property (nonatomic,strong) NSString *BrandName;
/** 车辆颜色**/
@property (nonatomic,strong) NSString *OutSideColor;
/** 车型**/
@property (nonatomic,strong) NSString *CarType;
/** 出厂日期**/
@property (nonatomic,strong) NSString *ProductionDate;
/** 车辆编号**/
@property (nonatomic,strong) NSString *CarVIN;
/** 车 况**/
@property (nonatomic,strong) NSString *CarState;
/** 原车用途**/
@property (nonatomic,strong) NSString *Uses;
/** 是否显示更多配置**/
@property (nonatomic,assign) BOOL     IsShowConfig;
/** 车辆概述**/
@property (nonatomic,strong) NSString *Summary;
/** 车况详情**/
@property (nonatomic,strong) NSString *WZBCRemark;
/** 车身外观首图**/
@property (nonatomic,strong) NSString *BodyFirst;
/** 车身内饰**/
@property (nonatomic,strong) NSString *Body;
/** 车身内饰首图**/
@property (nonatomic,strong) NSString *InteriorFirst;
/** 车身内饰**/
@property (nonatomic,strong) NSString *Interior;
/** 发送机首图**/
@property (nonatomic,strong) NSString *EngineFirst;
/** 发动机**/
@property (nonatomic,strong) NSString *Engine;
/** 同价位车**/
@property (nonatomic,strong) NSString *SamePriceCars;
/** 同品牌车**/
@property (nonatomic,strong) NSString *SameBrandCars;
/** 销售顾问电话**/
@property (nonatomic,strong) NSString *SalespersonPhone;
/** ID**/
@property (nonatomic,strong) NSString *ID;



@end
