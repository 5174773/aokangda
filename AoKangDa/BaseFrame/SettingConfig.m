//
//  SettingConfig.m
//  LvXin
//
//  Created by wei_yijie on 15/9/1.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//

#import "SettingConfig.h"

@implementation SettingConfig

static SettingConfig *instance;

+ (SettingConfig *)shareInstance{
    @synchronized(self){
        if (instance == nil) {
            instance = [[SettingConfig alloc] init];
        }
    }
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        //语言
        NSString *settingLanguage = [userdefault objectForKey:AppLanguage];
        //没设置
        if (settingLanguage.length < 1) {
            NSArray *languages = [NSLocale preferredLanguages];
            NSString *currentLanguage = [languages objectAtIndex:0];
            [userdefault setObject:currentLanguage forKey:AppLanguage];
            [userdefault synchronize];
            if ([currentLanguage isEqualToString:@"en"]) {
                _languege = English;
            }else if ([currentLanguage isEqualToString:@"zh-Hant"]) {
                _languege = TraditionalChinese;
            }else if ([currentLanguage isEqualToString:@"zh-Hans"]) {
                _languege = SimpleChinese;
            }
        }else{
            if ([settingLanguage isEqualToString:@"zh-Hans"]) {
                _languege = SimpleChinese;
            }else if ([settingLanguage isEqualToString:@"zh-Hant"]) {
                _languege = TraditionalChinese;
            }else if ([settingLanguage isEqualToString:@"en"]) {
                _languege = English;
            }
        }
        //字号
        NSString *settingFontSize = [userdefault objectForKey:AppFontSize];
        if (settingFontSize.length < 1) {
            [userdefault setObject:@"normal" forKey:AppFontSize];
            [userdefault synchronize];
            _fontSize = Normal;
        }else{
            if ([settingFontSize isEqualToString:@"superbig"]) {
                _fontSize = SuperBig;
            }else if ([settingFontSize isEqualToString:@"big"]) {
                _fontSize = Big;
            }else if ([settingFontSize isEqualToString:@"normal"]) {
                _fontSize = Normal;
            }else if ([settingFontSize isEqualToString:@"small"]) {
                _fontSize = Small;
            }
            
        }

    }
    return self;
}
+ (void)releaseInstance{
    instance = nil;
}
- (void)setLanguege:(LanguageType)languege{
    if (languege == SimpleChinese) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:AppLanguage];
        _languege = SimpleChinese;
    }else if (languege == TraditionalChinese) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hant" forKey:AppLanguage];
        _languege = TraditionalChinese;
    }else if (languege == English) {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:AppLanguage];
        _languege = English;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGELANGUAGE" object:nil];
}

- (void)setFontSize:(FontType)fontSize{
    if (fontSize == SuperBig) {
        [[NSUserDefaults standardUserDefaults] setObject:@"superbig" forKey:AppFontSize];
        _fontSize = SuperBig;
    }else if (fontSize == Big) {
        [[NSUserDefaults standardUserDefaults] setObject:@"big" forKey:AppFontSize];
        _fontSize = Big;
    }else if (fontSize == Normal) {
        [[NSUserDefaults standardUserDefaults] setObject:@"normal" forKey:AppFontSize];
        _fontSize = Normal;
    }else if (fontSize == Small) {
        [[NSUserDefaults standardUserDefaults] setObject:@"small" forKey:AppFontSize];
        _fontSize = Small;
    }
    
}



@end
