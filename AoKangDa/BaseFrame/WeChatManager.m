//
//  WeChatManager.m
//  UPark
//
//  Created by 深圳市 秀软科技有限公司 on 15/12/2.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "WeChatManager.h"

#define BASE_HEAD_URL   @"https://api.weixin.qq.com/sns/"

#define APP_ID          @"wx9564da626b03b34a"               //APPID
#define APP_SECRET      @"5730f7e8c15a6f105ad314fd291e2ed1" //appsecret

#define SCOPE           @"snsapi_userinfo"
#define STATE           @"AoKangDa"

#define GRANT_TYPE      @"authorization_code"

@implementation WeChatManager

static WeChatManager *manager = nil;

+ (instancetype)shareWeChatManager
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    }) ;
    
    return manager ;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [WeChatManager shareWeChatManager];
}

/*! @brief 检查微信是否已被用户安装
 *
 * @return 微信已安装返回YES，未安装返回NO。
 */
- (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}

/*!发送授权登录请求
 *
 */
- (void)sendAuthRequest
{
    SendAuthReq *authReq = [[SendAuthReq alloc] init];
    authReq.scope = SCOPE;
    authReq.state = STATE;
    
    [WXApi sendReq:authReq];
}

/*通过code获取access_token
 *
 */
- (void)getAccess_tokenWithCode:(NSString *)code succeed:(Succeed)succeed failed:(Failed)failed
{
    NSString *urlString = [BASE_HEAD_URL stringByAppendingString:[NSString stringWithFormat:@"oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=%@", APP_ID, APP_SECRET, code, GRANT_TYPE]];
    
    [RequestManager GetRequestWithUrlString:urlString Succeed:^(NSData *data) {

        succeed(data);
    } andFaild:^(NSError *error) {
        failed(error);
    }];
}

// 获取微信用户信息
- (void)getWeChat_userInfoWithAccess_token:(NSString *)access_token openId:(NSString *)openId succeed:(Succeed)succeed failed:(Failed)failed
{
    NSString *urlString = [BASE_HEAD_URL stringByAppendingString:[NSString stringWithFormat:@"userinfo?access_token=%@&openid=%@", access_token, openId]];
    
    [RequestManager GetRequestWithUrlString:urlString Succeed:^(NSData *data) {
//        NSDictionary *result_dic = DIC_FROM_DATA(data);
//        
//        NSLog(@"result_dic = %@", result_dic);
        
        succeed(data);
    } andFaild:^(NSError *error) {
        failed(error);
    }];
}

/*
 *发送消息到微信
 */
- (void)sendMessageToWX:(NSString *)text message:(WXMediaMessage *)message bText:(BOOL)bText scene:(int)scene
{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text = text;
    req.message = message;
    req.bText = bText;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

@end
