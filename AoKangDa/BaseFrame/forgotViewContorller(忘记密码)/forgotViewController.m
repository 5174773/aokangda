//
//  forgotViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/11/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "Utils.h"
#import <AFNetworking/AFNetworking.h>
#import "forgotViewController.h"

@interface forgotViewController ()<UITextFieldDelegate>
@property (nonatomic,weak) UIButton *check_Btn;

@property (nonatomic,weak) UITextField *telephoneTF;
@property (nonatomic,weak) UITextField *checkTF;
@property (nonatomic,weak) UITextField *passwordTF;
@property (nonatomic,weak) UITextField *resumepasswordTF;
@end

@implementation forgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleWithName:@"忘记密码" wordNun:4];
    [self addBackButton:YES];
    //请输入手机号
    UIImageView *user_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"Username@3x.png")];
    user_imageView.frame=CGRectMake(0, 11*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:user_imageView];
    
    UITextField *telephoneTF=[[UITextField alloc]init];
    telephoneTF.frame=CGRectMake(200*PSDSCALE_Y, 11*PSDSCALE_Y, 925*PSDSCALE_X, 152*PSDSCALE_Y);
    telephoneTF.placeholder=@"请输入手机号";
    telephoneTF.tag=1;
    [self.view addSubview:telephoneTF];
    _telephoneTF=telephoneTF;
    [self.telephoneTF addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    //请输入验证码
    UIImageView *check_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"checkCode@3x.png")];
    check_imageView.frame=CGRectMake(0, 181*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:check_imageView];
    
    UITextField *checkTF=[[UITextField alloc]init];
    checkTF.frame=CGRectMake(200*PSDSCALE_Y, 181*PSDSCALE_Y, 925*PSDSCALE_X, 152*PSDSCALE_Y);
    checkTF.placeholder=@"请输入验证码";
    checkTF.tag=2;
    [self.view addSubview:checkTF];
    _checkTF=checkTF;
   
    UIButton *check_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [check_btn setBackgroundImage:GETNCIMAGE(@"check_frame@3x.png") forState:UIControlStateNormal];
    check_btn.frame=CGRectMake(765*PSDSCALE_X, 182*PSDSCALE_Y, 312*PSDSCALE_X, 158*PSDSCALE_Y);
    [check_btn setImage:GETNCIMAGE(@"check_Image@3x.png") forState:UIControlStateNormal];
    [check_btn addTarget:self action:@selector(getCheckcode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:check_btn];
    _check_Btn=check_btn;
    _check_Btn.enabled=NO;
    //请输入密码
    UIImageView *password_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"password@3x.png")];
    password_imageView.frame=CGRectMake(0, 352*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:password_imageView];
    
    UITextField *passwordTF=[[UITextField alloc]init];
    passwordTF.frame=CGRectMake(200*PSDSCALE_Y, 352*PSDSCALE_Y, 925*PSDSCALE_X, 152*PSDSCALE_Y);
    passwordTF.placeholder=@"请输入新密码";
    passwordTF.tag=3;
    [self.view addSubview:passwordTF];
    _passwordTF=passwordTF;
    //请再次输入新密码
    UIImageView *repeat_password_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"password@3x.png")];
    repeat_password_imageView.frame=CGRectMake(0, 531*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:repeat_password_imageView];
    
    UITextField *resumepasswordTF=[[UITextField alloc]init];
    resumepasswordTF.frame=CGRectMake(200*PSDSCALE_Y, 531*PSDSCALE_Y, 925*PSDSCALE_X, 152*PSDSCALE_Y);
    resumepasswordTF.placeholder=@"请再次输入新密码";
    resumepasswordTF.tag=4;
    [self.view addSubview:resumepasswordTF];
    _resumepasswordTF=resumepasswordTF;
    
    
    //重置密码Button
    UIButton *reset_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [reset_btn setBackgroundImage:GETNCIMAGE(@"register@3x.png") forState:UIControlStateNormal];
    reset_btn.frame=CGRectMake(180*PSDSCALE_X, 784*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [reset_btn setTitle:@"重置密码" forState:UIControlStateNormal];
    [reset_btn addTarget:self action:@selector(resetBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reset_btn];
}
//当telephone内容为空时，验证码按钮不可点击
-(void)textchange
{
    self.check_Btn.enabled=YES;
    if ([self.telephoneTF.text isEqualToString:@""]) {
        self.check_Btn.enabled=NO;
    }
}
#pragma mark -点击重置密码事件
-(void)resetBtnDidClick
{
    //检查文本是否为空
    if ([self checkValidityTextField]) {
        AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
        NSString *urlStr=@"http://192.168.1.208:8081/pointLine/app/register.do";
        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
        parameters[@"phone"]=self.telephoneTF.text;
        parameters[@"password"]=self.passwordTF.text;
        parameters[@"verification"]=self.checkTF.text;
        [manger POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // NSLog(@"success");
            NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
            
            //        NSLog(@"%@",code);
            if ([code isEqualToString:@"400"]) {
                NSLog(@"参数有误");
            }
            if ([code isEqualToString:@"300"]) {
                NSLog(@"手机号未注册");
            }
            if ([code isEqualToString:@"200"]) {
                 NSLog(@"密码重置成功");
                

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
        
        _telephoneTF.text=@"";
        _checkTF.text=@"";
        _passwordTF.text=@"";
        _resumepasswordTF.text=@"";
    }
 [Utils alertTitle:@"提示" message:@"恭喜你，重置密码成功" delegate:self cancelBtn:@"取消" otherBtnName:nil];
    
}
#pragma mark -获取验证码
-(void)getCheckcode
{
    AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
    NSString *urlStr=@"http://192.168.1.208:8081/pointLine/app/sendCodeRegister.do";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"]=self.telephoneTF.text;
    [manger GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
        if ([code isEqualToString:@"400"]) {
            NSLog(@"参数有误");
        }
        if ([code isEqualToString:@"300"]) {
            NSLog(@"手机号已经注册");
        }
        if ([code isEqualToString:@"200"]) {
            NSLog(@"获取验证码正确");
            }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure");
    }];

}
#pragma mark checkValidityTextField Null
-(BOOL)checktelephoneTextField
{
    if ([(UITextField *)[self.view viewWithTag:1] text] == nil || [[(UITextField *)[self.view viewWithTag:1] text] isEqualToString:@""]) {
        
        NSLog(@"kong");
        return  NO;
    }
    else
    {
        return YES;
    }
    
    
    
}

- (BOOL)checkValidityTextField
{
    //手机号为空
    if ([(UITextField *)[self.view viewWithTag:1] text] == nil || [[(UITextField *)[self.view viewWithTag:1] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的手机号不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:2] text] == nil || [[(UITextField *)[self.view viewWithTag:2] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的验证码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:3] text] == nil || [[(UITextField *)[self.view viewWithTag:3] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的密码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:4] text] == nil || [[(UITextField *)[self.view viewWithTag:4] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"请再次输入密码" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if (![[(UITextField *)[self.view viewWithTag:4] text] isEqualToString:[(UITextField *)[self.view viewWithTag:3] text]]) {
        [Utils alertTitle:@"提示" message:@"输入的两次密码不一致" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    
    return YES;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
