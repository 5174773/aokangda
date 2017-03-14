//
//  SRRegisterViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/11/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "Utils.h"
#import "SRRegisterViewController.h"
#import "SRUserinfoViewController.h"
#import <AFNetworking/AFNetworking.h>
@interface SRRegisterViewController ()<UITextFieldDelegate>

@property (nonatomic,weak) UITextField *telephoneTF;
@property (nonatomic,weak) UITextField *checkTF;
@property (nonatomic,weak) UIButton *check_Btn;
@property (nonatomic,weak) UITextField *passwordTF;
@property (nonatomic,weak) UITextField *resumepasswordTF;
@end

@implementation SRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitleWithName:@"注册" wordNun:2];
    [self addBackButton:YES];
    self.checkTF.delegate=self;
    //请输入手机号
    UIImageView *user_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"Username@3x.png")];
    user_imageView.frame=CGRectMake(0, 11*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:user_imageView];
    
    UITextField *telephoneTF=[[UITextField alloc]init];
    telephoneTF.frame=CGRectMake(200*PSDSCALE_Y, 11*PSDSCALE_Y, 800*PSDSCALE_X, 152*PSDSCALE_Y);
    telephoneTF.placeholder=@"请输入手机号";
    telephoneTF.clearButtonMode = UITextFieldViewModeAlways;
    telephoneTF.tag=1;
    [self.view addSubview:telephoneTF];
    _telephoneTF=telephoneTF;
    [self.telephoneTF addTarget:self action:@selector(textchange) forControlEvents:UIControlEventEditingChanged];
    //请输入验证码
    UIImageView *check_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"checkCode@3x.png")];
    check_imageView.frame=CGRectMake(0, 181*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:check_imageView];
    
    UITextField *checkTF=[[UITextField alloc]init];
    checkTF.frame=CGRectMake(200*PSDSCALE_Y, 181*PSDSCALE_Y, 550*PSDSCALE_X, 152*PSDSCALE_Y);
    checkTF.placeholder=@"请输入验证码";
    checkTF.clearButtonMode = UITextFieldViewModeAlways;
    checkTF.tag=2;
    [self.view addSubview:checkTF];
    _checkTF=checkTF;
    UIButton *check_Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [check_Btn setBackgroundImage:GETNCIMAGE(@"check_frame@3x.png") forState:UIControlStateNormal];
    check_Btn.frame=CGRectMake(765*PSDSCALE_X, 182*PSDSCALE_Y, 312*PSDSCALE_X, 148*PSDSCALE_Y);
    [check_Btn setImage:GETNCIMAGE(@"check_Image@3x.png") forState:UIControlStateNormal];
    [check_Btn addTarget:self action:@selector(getCheckcode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:check_Btn];
    _check_Btn=check_Btn;
    _check_Btn.enabled=NO;
    //请输入密码
    UIImageView *password_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"password@3x.png")];
    password_imageView.frame=CGRectMake(0, 352*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:password_imageView];
    
    UITextField *passwordTF=[[UITextField alloc]init];
    passwordTF.frame=CGRectMake(200*PSDSCALE_Y, 352*PSDSCALE_Y, 800*PSDSCALE_X, 152*PSDSCALE_Y);
    passwordTF.placeholder=@"请输入新密码";
    passwordTF.clearButtonMode = UITextFieldViewModeAlways;
    passwordTF.tag=3;
    [self.view addSubview:passwordTF];
    _passwordTF=passwordTF;
    //请再次输入新密码
    UIImageView *resume_password_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"password@3x.png")];
    resume_password_imageView.frame=CGRectMake(0, 531*PSDSCALE_Y, self.view.frame.size.width, 152*PSDSCALE_Y);
    [self.view addSubview:resume_password_imageView];
    
    UITextField *resumepasswordTF=[[UITextField alloc]init];
    resumepasswordTF.frame=CGRectMake(200*PSDSCALE_Y, 531*PSDSCALE_Y, 800*PSDSCALE_X, 152*PSDSCALE_Y);
    resumepasswordTF.placeholder=@"请再次输入新密码";
    resumepasswordTF.clearButtonMode = UITextFieldViewModeAlways;
    resumepasswordTF.tag=4;
    [self.view addSubview:resumepasswordTF];
    _resumepasswordTF=resumepasswordTF;
    
    
    //注册按钮点击事件
    UIButton *register_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [register_btn setBackgroundImage:GETNCIMAGE(@"register@3x.png") forState:UIControlStateNormal];
    register_btn.frame=CGRectMake(180*PSDSCALE_X, 784*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [register_btn setTitle:@"注册" forState:UIControlStateNormal];
    [register_btn addTarget:self action:@selector(registerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:register_btn];
}
-(void)textchange
{
    self.check_Btn.enabled=YES;
    if ([self.telephoneTF.text isEqualToString:@""]) {
        self.check_Btn.enabled=NO;
    }
}
//-(void)back
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//
//}
#pragma mark -点击注册
-(void)registerBtnDidClick
{
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
            if ([code isEqualToString:@"300"]) {
                NSLog(@"手机号未注册");
            }
            if ([code isEqualToString:@"400"]) {
                NSLog(@"参数有误");
            }
            if ([code isEqualToString:@"500"]) {
                NSLog(@"验证码错误");
            }
            if ([code isEqualToString:@"600"]) {
                NSLog(@"验证码过期");
            }
            if ([code isEqualToString:@"200"]) {
                NSLog(@"注册成功");
                NSString *person_id=responseObject[@"userId"];
                NSLog(@"%@",person_id);
            SRUserinfoViewController *userinfoVC=[SRUserinfoViewController new];
            userinfoVC.userID=person_id;
            [self.navigationController pushViewController:userinfoVC animated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
        
        _telephoneTF.text=@"";
        _checkTF.text=@"";
        _passwordTF.text=@"";
        _resumepasswordTF.text=@"";
    }
    SRUserinfoViewController *userinfoVC=[SRUserinfoViewController new];
    [self.navigationController pushViewController:userinfoVC animated:YES];

}
#pragma mark -获取验证码
-(void)getCheckcode:(NSString *)str
{
    AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
    NSString *urlStr=@"http://192.168.1.208:8081/pointLine/app/sendCodeRegister.do";
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"phone"]=self.telephoneTF.text;
    [manger GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
       // NSLog(@"success");
        NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
        //NSString* person_id=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
        //        NSLog(@"%@",code);
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
