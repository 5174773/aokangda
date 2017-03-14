//
//  AppDelegate.m
//  BaseFrame
//
//  Created by wei_yijie on 15/9/17.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//
// 微信分享APP_ID  wx9564da626b03b34a
// 微信分享APP_KEY  5730f7e8c15a6f105ad314fd291e2ed1

/**
 *      WXSceneSession   分享到会话
 *      WXSceneTimeline  分享到朋友圈
 *      WXSceneFavorite  分享到我的收藏
 */


#import "AppDelegate.h"
#import "WMCommon.h"
#import "WXApi.h"
#import "WMHomeViewController.h"
#import "ViewController.h"
@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate
enum WXScene _scene;
- (id)init{
    if(self = [super init]){
        _scene = WXSceneSession;
    }
    return self;
}
-(void) changeScene:(NSInteger)scene
{
    _scene = scene;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     /**设置根控制器 */
    WMCommon *common = [WMCommon getInstance];
    common.screenW = [[UIScreen mainScreen] bounds].size.width;
    common.screenH = [[UIScreen mainScreen] bounds].size.height;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    ViewController *homeVC=[[ViewController alloc]init];
    self.window.rootViewController=[[UINavigationController alloc]initWithRootViewController:homeVC];
    [self.window makeKeyAndVisible];
    
    
    // 其它代码
    
    // 向微信注册应用ID
    [WXApi registerApp:@"wx9564da626b03b34a"];
    
    
    
    return YES;
}
#pragma mark - 重写AppDelegate的handleOpenURL和openURL方法
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
