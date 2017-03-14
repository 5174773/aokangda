//
//  SRCompanycertifyViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/11/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SRCompanycertifyViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"
@interface SRCompanycertifyViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic)UIButton *iconBtn;

@property (nonatomic,weak)  UITextField *company_textField;
@property (nonatomic,weak)  UITextField *organization_textField;
@property (nonatomic,weak)  UITextField *legalentity_textField;
@property (nonatomic,weak)  UITextField *telephone_textField;
@property (nonatomic,weak)  UITextField *address_textField;
@property (nonatomic,strong) UIImage *companyIcon;
@property (nonatomic,strong) NSString *companyPath;
@property (nonatomic,strong) NSString *totalPath;
@end

@implementation SRCompanycertifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTitleWithName:@"企业认证" wordNun:4];
    [self addBackButton:YES];
    //创建tableView
    [self createheadView];
    [self createMidView];
    [self createfooterView];
}
- (void)createheadView{
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 485*PSDSCALE_Y)];
    bgview.backgroundColor=RGBACOLOR(20, 153, 231, 1);
    [self.view addSubview:bgview];
//    UIImageView *iconView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"logo_conmpany@3x.png")];
//    iconView.frame=CGRectMake(416*PSDSCALE_X, 67*PSDSCALE_Y, 236*PSDSCALE_X, 236*PSDSCALE_Y);
   
    UIButton *icon_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    _iconBtn=icon_btn;
    icon_btn.frame=CGRectMake(416*PSDSCALE_X, 67*PSDSCALE_Y, 236*PSDSCALE_X, 236*PSDSCALE_Y);
    icon_btn.layer.cornerRadius=icon_btn.frame.size.width/2;
    icon_btn.layer.masksToBounds=YES;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyName"];
    
    if (data) {
        _companyIcon = [UIImage imageWithData:data];
        
    }
    else
    {
        _companyIcon=GETNCIMAGE(@"logo_conmpany@3x.png");
    }
    
    [icon_btn setBackgroundImage:_companyIcon forState:UIControlStateNormal];
    [icon_btn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:icon_btn];
    UILabel * licence=[[UILabel alloc]init];
    licence.frame=CGRectMake(0, 342*PSDSCALE_Y, self.view.frame.size.width, 65*PSDSCALE_Y);
    licence.text=@"营业执照";
    licence.textColor=[UIColor whiteColor];
    licence.textAlignment=NSTextAlignmentCenter;
    licence.font=[UIFont systemFontOfSize:20];
    [self.view addSubview: licence];
    [self.view addSubview:icon_btn];
    
}
- (void)createMidView{
    //企业名称
    UIImageView *company_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"diamond@3x.png")];
    company_imageView.frame=CGRectMake(45*PSDSCALE_X, 548*PSDSCALE_Y, 47*PSDSCALE_X, 42*PSDSCALE_Y);
    [self.view addSubview:company_imageView];
    UITextField *company_textField= [[UITextField alloc] initWithFrame:CGRectMake(200*PSDSCALE_X, 490*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    company_textField.returnKeyType = UIReturnKeyDone;
    company_textField.tag=1;
    company_textField.placeholder = @"请输入企业名称";
    company_textField.clearButtonMode = UITextFieldViewModeAlways;
    company_textField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:company_textField];
    _company_textField=company_textField;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 647*PSDSCALE_Y, self.view.frame.size.width, 1)];
    lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:lineView];
    //组织机构代表
    UIImageView *organization_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"organization@3x.png")];
    organization_imageView.frame=CGRectMake(45*PSDSCALE_X, 706*PSDSCALE_Y, 53*PSDSCALE_X, 42*PSDSCALE_Y);
    [self.view addSubview:organization_imageView];
    UITextField *organization_textField= [[UITextField alloc] initWithFrame:CGRectMake(200*PSDSCALE_X, 648*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    organization_textField.tag=2;
    organization_textField.clearButtonMode = UITextFieldViewModeAlways;
    organization_textField.returnKeyType = UIReturnKeyDone;
    organization_textField.placeholder = @"请输入组织机构代码";
    organization_textField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:organization_textField];
    _organization_textField=organization_textField;
    UIView *organization_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 805*PSDSCALE_Y, self.view.frame.size.width, 1)];
    organization_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:organization_lineView];
    //请输入法定代表人
    UIImageView *legalentity_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"person_icon@3x.png")];
    legalentity_imageView.frame=CGRectMake(45*PSDSCALE_X, 859*PSDSCALE_Y, 49*PSDSCALE_X, 52*PSDSCALE_Y);
    [self.view addSubview:legalentity_imageView];
    UITextField *legalentity_textField= [[UITextField alloc] initWithFrame:CGRectMake(200*PSDSCALE_X, 806*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    legalentity_textField.tag=3;
    legalentity_textField.returnKeyType = UIReturnKeyDone;
    legalentity_textField.clearButtonMode = UITextFieldViewModeAlways;
    legalentity_textField.placeholder = @"请输入法定代表人";
    legalentity_textField.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.view addSubview:legalentity_textField];
    _legalentity_textField=legalentity_textField;
    
    UIView *legalentity_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 963*PSDSCALE_Y, self.view.frame.size.width, 1)];
    legalentity_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:legalentity_lineView];
    //请输入联系电话
    UIImageView *telephone_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"telephone@3x.png")];
    telephone_imageView.frame=CGRectMake(45*PSDSCALE_X, 1013*PSDSCALE_Y, 46*PSDSCALE_X, 61*PSDSCALE_Y);
    [self.view addSubview:telephone_imageView];
    UITextField *telephone_textField= [[UITextField alloc] initWithFrame:CGRectMake(200*PSDSCALE_X, 964*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    telephone_textField.tag = Tag_EmailTextField ;
    telephone_textField.tag=4;
    telephone_textField.returnKeyType = UIReturnKeyDone;
    telephone_textField.placeholder = @"请输入联系电话";
    telephone_textField.clearButtonMode = UITextFieldViewModeAlways;
    telephone_textField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:telephone_textField];
    _telephone_textField=telephone_textField;
    UIView *telephone_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 1121*PSDSCALE_Y, self.view.frame.size.width, 1)];
    telephone_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:telephone_lineView];
    //请输入联系地址
    UIImageView *address_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"address@3x.png")];
    address_imageView.frame=CGRectMake(45*PSDSCALE_X, 1174*PSDSCALE_Y, 37*PSDSCALE_X, 54*PSDSCALE_Y);
    [self.view addSubview:address_imageView];
    UITextField *address_textField= [[UITextField alloc] initWithFrame:CGRectMake(200*PSDSCALE_X, 1122*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    address_textField.tag = 5;
    address_textField.returnKeyType = UIReturnKeyDone;
    address_textField.placeholder = @"请输入联系地址";
    address_textField.clearButtonMode = UITextFieldViewModeAlways;
    address_textField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:address_textField];
    _address_textField=address_textField;
    UIView *address_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 1279*PSDSCALE_Y, self.view.frame.size.width, 1)];
    address_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:address_lineView];
    
}
/**
 *	创建
 */
- (void)createfooterView{
    UIButton *commitBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    commitBtn.frame=CGRectMake(180*PSDSCALE_X, 1380*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitBtnDidclick) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundImage:GETNCIMAGE(@"login_btn@3x.png") forState:UIControlStateNormal];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:commitBtn];
    
    UIButton *skipBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    skipBtn.frame=CGRectMake(180*PSDSCALE_X, 1536*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(skipBtnDidclick) forControlEvents:UIControlEventTouchUpInside];
    [skipBtn setBackgroundImage:GETNCIMAGE(@"register@3x.png") forState:UIControlStateNormal];
    [self.view addSubview:skipBtn];
    
    
}
#pragma mark -提交资料
-(void)commitBtnDidclick
{
    NSLog(@"提交");
    if ([self checkValidityTextField]) {
        AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
        NSString *urlStr=@" http://192.168.1.208:8081/pointLine/app/registerTwo.do";
        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
        parameters[@"userId"]=self.userId;
        parameters[@"ename"]=self.company_textField.text;
        parameters[@"address"]=self.address_textField.text;
        parameters[@"telephone"]=self.telephone_textField.text;
        parameters[@"person"]=self.legalentity_textField.text;
        parameters[@"enterpriseCode"]=self.organization_textField.text;
        parameters[@"yanzhenPic"]=self.companyPath;
        [manger POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            // NSLog(@"success");
            NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
            
            //        NSLog(@"%@",code);
            if ([code isEqualToString:@"300"]) {
                NSLog(@"参数有误");
            }
            if ([code isEqualToString:@"200"]) {
                NSLog(@"成功");
        
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failure");
        }];
        
        _company_textField.text=@"";
        _telephone_textField.text=@"";
        _address_textField.text=@"";
        _legalentity_textField.text=@"";
        _organization_textField.text=@"";
    }
    
    
    
    
    
    
    
    
}
#pragma mark -跳过注册
-(void)skipBtnDidclick
{
    NSLog(@"跳过");
}
#pragma mark - touchMethod
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self allEditActionsResignFirstResponder];
}

#pragma mark - PrivateMethod
- (void)allEditActionsResignFirstResponder{
    
    [[self.view viewWithTag:1]  resignFirstResponder];
    [[self.view viewWithTag:2]  resignFirstResponder];
    [[self.view viewWithTag:3]  resignFirstResponder];
    [[self.view viewWithTag:4]  resignFirstResponder];
    [[self.view viewWithTag:5]  resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更换头像
-(void)changeIcon
{
    NSLog(@"更换公司名片");
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    _companyIcon = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_iconBtn setBackgroundImage:_companyIcon forState:UIControlStateNormal];
    _iconBtn.layer.cornerRadius=self.iconBtn.frame.size.width/2;
    _iconBtn.layer.masksToBounds=YES;
    //保存图片
    [self saveImage:_companyIcon WithName:@"companyIcon"];
    
}

#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage); //PNG格式
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"companyName"];
    NSString* totalpath = [documentsDirectory stringByAppendingPathComponent:imageName];
    _totalPath=totalpath;
    // and then we write it out
    [imageData writeToFile:totalpath atomically:NO];
    NSString *urlstr=@"http://192.168.1.208:8081/pointLine/app/uploadImg.do";
    AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"picture"]=_companyIcon;
    [manger POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
        if ([code isEqualToString:@"300"]) {
            NSLog(@"上传有误");
        }
        if ([code isEqualToString:@"200"]) {
            NSLog(@"上传后的图片路径");
            NSString* companyPath=[NSString stringWithFormat:@"%@",responseObject[@"picture"]];
            _companyPath=companyPath;
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}


- (BOOL)checkValidityTextField
{
    //手机号为空
    if ([(UITextField *)[self.view viewWithTag:1] text] == nil || [[(UITextField *)[self.view viewWithTag:1] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的企业名称不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:2] text] == nil || [[(UITextField *)[self.view viewWithTag:2] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的组织机构代码不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:3] text] == nil || [[(UITextField *)[self.view viewWithTag:3] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"法定代表人不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:4] text] == nil || [[(UITextField *)[self.view viewWithTag:4] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"联系电话不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:5] text] == nil || [[(UITextField *)[self.view viewWithTag:5] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"联系地址不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    return YES;
    
    
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
