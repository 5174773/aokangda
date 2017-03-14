//
//  SRLoginViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/11/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SRLoginViewController.h"
#import "forgotViewController.h"
#import "SRRegisterViewController.h"
#import "Utils.h"
#import "Reachability.h"
#import <AFNetworking/AFNetworking.h>
@interface SRLoginViewController ()<UITextFieldDelegate>
//检测网络状态
@property (nonatomic,weak) UITextField *telephoneTF;
@property (nonatomic,weak) UITextField *passwordTF;
@property (nonatomic, assign,setter=isOK:) BOOL isOK;
@end

@implementation SRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleWithName:@"登录" wordNun:2];
    UIImageView *logo_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"login_logo@3x.png")];
    logo_imageView.frame=CGRectMake(310*PSDSCALE_X , 153*PSDSCALE_Y, 432*PSDSCALE_X, 217*PSDSCALE_Y);
    [self.view addSubview:logo_imageView];
    
    UIImageView *user_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"Username@3x.png")];
    user_imageView.frame=CGRectMake(0, 459*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:user_imageView];
    
    UIImageView *password_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"password@3x.png")];
    password_imageView.frame=CGRectMake(0, 633*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:password_imageView];
    
    UITextField *telephoneTF=[[UITextField alloc]init];
    //telephoneTF.frame=CGRectMake(200*PSDSCALE_Y, 459*PSDSCALE_Y, 925*PSDSCALE_X, 152*PSDSCALE_Y);
    telephoneTF.frame=CGRectMake(200*PSDSCALE_Y, 459*PSDSCALE_Y, 800*PSDSCALE_X, 152*PSDSCALE_Y);
    telephoneTF.placeholder=@"请输入手机号";
    telephoneTF.clearButtonMode = UITextFieldViewModeAlways;
    telephoneTF.keyboardType = UIKeyboardTypeNamePhonePad;
    telephoneTF.tag=Tag_telephoneTextField;
    [self.view addSubview:telephoneTF];
    _telephoneTF=telephoneTF;
    
    UITextField *passwordTF=[[UITextField alloc]init];
    //passwordTF.frame=CGRectMake(200*PSDSCALE_Y, 633*PSDSCALE_Y, 925*PSDSCALE_X, 152*PSDSCALE_Y);
    passwordTF.frame=CGRectMake(200*PSDSCALE_Y, 633*PSDSCALE_Y, 800*PSDSCALE_X, 152*PSDSCALE_Y);
    passwordTF.placeholder=@"请输入密码";
    passwordTF.tag=Tag_TempPasswordTextField;
    passwordTF.secureTextEntry=YES;
    passwordTF.keyboardType = UIKeyboardTypeEmailAddress;
    passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:passwordTF];
    _passwordTF=passwordTF;
    
    UIButton *forgotBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [forgotBtn setBackgroundImage:GETNCIMAGE(@"forgotpassword@3x.png") forState:UIControlStateNormal];
    forgotBtn.frame=CGRectMake(825*PSDSCALE_X, 803*PSDSCALE_Y, 274*PSDSCALE_X, 64*PSDSCALE_Y);
    [forgotBtn addTarget:self action:@selector(forgotBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotBtn];
    //登录
    UIButton *login_Btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [login_Btn setBackgroundImage:GETNCIMAGE(@"login_btn@3x.png") forState:UIControlStateNormal];
    login_Btn.frame=CGRectMake(180*PSDSCALE_X, 910*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [login_Btn setTitle:@"登录" forState:UIControlStateNormal];
    [login_Btn addTarget:self action:@selector(loginBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login_Btn];
    //立即注册
    UIButton *register_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [register_btn setBackgroundImage:GETNCIMAGE(@"register@3x.png") forState:UIControlStateNormal];
    register_btn.frame=CGRectMake(180*PSDSCALE_X, 1052*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [register_btn setTitle:@"立即注册" forState:UIControlStateNormal];
    [register_btn addTarget:self action:@selector(resignBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:register_btn];
}
//注册按钮点击事件
-(void)resignBtnDidClick
{
    _telephoneTF.text=@"";
    _passwordTF.text=@"";
    SRRegisterViewController *registerVC=[SRRegisterViewController new];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}
//登录触发事件
-(void)loginBtnDidClick
{
   
    if ( [self checkValidityTextField]) {
        if ([self isExistenceNetwork]) {
            //网络连接OK
            if ([self checkValidityTextField]) {
                [self addActityLoading:@"正在登录" subTitle:nil];
                //延时操作
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            }
            //发送post请求
            NSString *urlString=@"http://192.168.1.208:8081/pointLine/app/login.do";
            AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
            NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
            parameters[@"phone"]=self.telephoneTF.text;
            parameters[@"password"]=self.passwordTF.text;
            [manger POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"success");
                NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
                
                if ([code isEqualToString:@"200"]) {
                    NSLog(@"可以登录");
                    
                }
                if ([code isEqualToString:@"300"]) {
                    NSLog(@"参数有误");
                }
                if ([code isEqualToString:@"400"]) {
                    NSLog(@"没找到该用户");
                }
                if ([code isEqualToString:@"500"]) {
                    NSLog(@"密码错误");
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error=%@",error);
            }];
           }else
           {
               //网络连接error
               UIImageView *errorIV=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"network_error@3x.png")];
               errorIV.center=self.view.center;
               [self.view addSubview:errorIV];
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [errorIV removeFromSuperview];
               });
           }
           }
    
    else
    {
        
        NSLog(@"用户名或密码不能输入为空");
    }
       // NSLog(@"网络连接失败");
//        UIImageView *NetWork_errorIV=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"network_error@3x.png")];
//        NetWork_errorIV.center=self.view.center;
//        [self.view addSubview:NetWork_errorIV];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [NetWork_errorIV removeFromSuperview];
//        });
    
   
   
    
   
    
}
-(void)dismiss{
    [self removeActityLoading];
}
-(void)errorOption
{
    
}
//忘记密码按钮点击事件
-(void)forgotBtnDidClick
{
    forgotViewController *forgotVC=[forgotViewController new];
    [self.navigationController pushViewController:forgotVC animated:YES];
 
    
}
/**
 *	验证文本框是否为空
 */
# pragma mark checkValidityTextField Null
- (BOOL)checkValidityTextField
{
    
    if ([(UITextField *)[self.view viewWithTag:Tag_telephoneTextField] text] == nil || [[(UITextField *)[self.view viewWithTag:Tag_telephoneTextField] text] isEqualToString:@""]) {
        
        return NO;
        
    }
    
    
    if ([(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text]==nil||[[(UITextField *)[self.view viewWithTag:Tag_TempPasswordTextField] text] isEqualToString:@""]) {
        return NO;
    }
   
        return YES;
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    //手机号
    [[self.view viewWithTag:Tag_telephoneTextField] resignFirstResponder];
    //temp密码
    [[self.view viewWithTag:Tag_TempPasswordTextField] resignFirstResponder];

}
//检测网络状态
- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    // 测试服务器状态
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
    }
    return  isExistenceNetwork;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
