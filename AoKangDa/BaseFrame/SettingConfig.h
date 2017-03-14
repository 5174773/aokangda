//
//  SettingConfig.h
//  LvXin
//
//  Created by wei_yijie on 15/9/1.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//
//  系统语言和字体修改配置单例

#import <Foundation/Foundation.h>

typedef enum{
    SimpleChinese,
    TraditionalChinese,
    English
}LanguageType ;

typedef enum{
    SuperBig,
    Big,
    Normal,
    Small
}FontType ;

@interface SettingConfig : NSObject

@property (nonatomic,assign) LanguageType languege;

@property (nonatomic,assign) FontType fontSize;

+ (SettingConfig *)shareInstance;

+ (void)releaseInstance;

@end
