//
//  SRUserinfoViewController.m
//  DottedWorld
//
//  Created by showsoft on 15/11/10.
//  Copyright © 2015年 showsoft. All rights reserved.
//

#import "SRUserinfoViewController.h"
#import "SRCompanycertifyViewController.h"
#import "CZKeyboardToolbar.h"
#import "Utils.h"
#import <AFNetworking/AFNetworking.h>
@interface SRUserinfoViewController ()<UITextFieldDelegate,CZKeyboardToolbarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,weak) UIButton *famaleBtn;
@property (nonatomic,weak) UIButton *maleBtn;
@property (nonatomic,weak) UIButton *icon_btn;
@property (nonatomic,weak) UITextField *usertextField;
@property (nonatomic,weak) UITextField *email_textField;
@property (nonatomic,weak) UITextField *bron_textField;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) UIImage *usericon;
@property (strong,nonatomic) UIDatePicker *datepicker;
//头像路径
@property (nonatomic,weak)NSString *totalPath;
@property (nonatomic,weak)NSString* pic_Path;

@property (nonatomic,assign,setter=isMale:) BOOL isMale;

@end

@implementation SRUserinfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTitleWithName:@"填写用户资料" wordNun:6];
    [self addBackButton:YES];
    [self createheadView];
    [self createMidView];
    [self createfooterView];
     NSLog(@"%@",self.gender);
}
/**
 *	创建TableView
 */
- (void)createheadView{
    
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 489*PSDSCALE_Y)];
    bgview.backgroundColor=RGBACOLOR(20, 153, 231, 1);
    //[UIColor colorWithRed:20/255.0 green:153/255.0 blue:231/225.0 alpha:1.0];
    [self.view addSubview:bgview];
    UIButton *icon_btn=[UIButton buttonWithType:UIButtonTypeSystem];
    icon_btn.frame=CGRectMake(390*PSDSCALE_X, 107*PSDSCALE_Y, 243*PSDSCALE_X, 243*PSDSCALE_Y);
    icon_btn.layer.cornerRadius=icon_btn.frame.size.width/2;
    icon_btn.layer.masksToBounds=YES;
   
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    if (data) {
        _usericon = [UIImage imageWithData:data];
        
    }
    else
    {
         _usericon=GETNCIMAGE(@"uesr_icon@3x.png");
    }

    //_usericon = [UIImage imageWithData:data];
    
    [icon_btn setBackgroundImage: self.usericon forState:UIControlStateNormal];
    [icon_btn addTarget:self action:@selector(changeIcon) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:icon_btn];
    _icon_btn=icon_btn;
    
}
- (void)createMidView{
    //用户名
    UIImageView *user_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"person_icon@3x.png")];
    user_imageView.frame=CGRectMake(69*PSDSCALE_X, 545*PSDSCALE_Y, 49*PSDSCALE_X, 52*PSDSCALE_Y);
    [self.view addSubview:user_imageView];
//    UITextField *usertextField= [[UITextField alloc] initWithFrame:CGRectMake(201*PSDSCALE_X, 489*PSDSCALE_Y, 879*PSDSCALE_X, 157*PSDSCALE_Y)];
    UITextField *usertextField= [[UITextField alloc] initWithFrame:CGRectMake(201*PSDSCALE_X, 489*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    usertextField.tag = 5 ;
    usertextField.returnKeyType = UIReturnKeyDone;
    usertextField.clearButtonMode = UITextFieldViewModeAlways;
    usertextField.placeholder = @"请输入用户名";
    usertextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:usertextField];
    _usertextField=usertextField;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 646*PSDSCALE_Y, self.view.frame.size.width, 1)];
    lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:lineView];
    //邮箱
    UIImageView *email_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"register_email@3x.png")];
    email_imageView.frame=CGRectMake(69*PSDSCALE_X, 715*PSDSCALE_Y, 45*PSDSCALE_X, 32*PSDSCALE_Y);
    [self.view addSubview:email_imageView];
    UITextField *email_textField= [[UITextField alloc] initWithFrame:CGRectMake(201*PSDSCALE_X, 647*PSDSCALE_Y, 800*PSDSCALE_X, 157*PSDSCALE_Y)];
    email_textField.tag = 6;
    email_textField.returnKeyType = UIReturnKeyDone;
    email_textField.clearButtonMode = UITextFieldViewModeAlways;
    email_textField.placeholder = @"请输入邮箱";
    email_textField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:email_textField];
    _email_textField=email_textField;
    UIView *email_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 804*PSDSCALE_Y, self.view.frame.size.width, 1)];
    email_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:email_lineView];
    //出生日期
    UIImageView *bron_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"register_date@3x.png")];
    bron_imageView.frame=CGRectMake(69*PSDSCALE_X, 862*PSDSCALE_Y, 48*PSDSCALE_X, 40*PSDSCALE_Y);
    [self.view addSubview:bron_imageView];
    UITextField *bron_textField= [[UITextField alloc] initWithFrame:CGRectMake(201*PSDSCALE_X, 805*PSDSCALE_Y, 700*PSDSCALE_X, 157*PSDSCALE_Y)];
    _bron_textField=bron_textField;
    bron_textField.tag = 7;
    bron_textField.returnKeyType = UIReturnKeyDone;
    bron_textField.clearButtonMode = UITextFieldViewModeAlways;
    bron_textField.placeholder = @"请输入出生日期";
    bron_textField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:bron_textField];
    _bron_textField=bron_textField;
    UIButton *datepickerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    datepickerBtn.frame=CGRectMake(930*PSDSCALE_X, 860*PSDSCALE_Y, 43*PSDSCALE_X, 43*PSDSCALE_Y);
    [datepickerBtn setImage:GETNCIMAGE(@"datepiker@3x.png") forState:UIControlStateNormal];
    [datepickerBtn addTarget:self action:@selector(datepickerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:datepickerBtn];
    
    UIView *bron_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 962*PSDSCALE_Y, self.view.frame.size.width, 1)];
    bron_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:bron_lineView];
    //性别选择
    UIImageView *sex_imageView=[[UIImageView alloc]initWithImage:GETNCIMAGE(@"sex_icon@3x.png")];
    sex_imageView.frame=CGRectMake(69*PSDSCALE_X, 1030*PSDSCALE_Y, 41*PSDSCALE_X, 40*PSDSCALE_Y);
    [self.view addSubview:sex_imageView];
    _gender=@"1";
    //male:男
    UIButton *maleBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _maleBtn=maleBtn;
    _maleBtn.frame=CGRectMake(201*PSDSCALE_X, 1025*PSDSCALE_Y, 110*PSDSCALE_X, 60*PSDSCALE_Y);
    [_maleBtn setTitle:@"男" forState:UIControlStateNormal];
    [_maleBtn addTarget:self action:@selector(maleBtnDidclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_maleBtn];
    //famale:女
    UIButton *famaleBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    famaleBtn.frame=CGRectMake(520*PSDSCALE_X, 1025*PSDSCALE_Y, 110*PSDSCALE_X, 60*PSDSCALE_Y);
    _famaleBtn=famaleBtn;
    [_famaleBtn setTitle:@"女" forState:UIControlStateNormal];
    [_famaleBtn addTarget:self action:@selector(famaleBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
     //self.isMale?[_famaleBtn setImage:GETNCIMAGE(@"sex_selected@3x.png")  forState:UIControlStateNormal]:[_famaleBtn setImage:GETNCIMAGE(@"sex_normal@3x.png") forState:UIControlStateNormal];
    [self.view addSubview:famaleBtn];
    [self setUpMaleImage];
    UIView *sex_lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 1120*PSDSCALE_Y, self.view.frame.size.width, 1)];
    sex_lineView.backgroundColor=RGBACOLOR(174, 174, 174, 0.5);
    [self.view addSubview:sex_lineView];
   // GETNCIMAGE(@"sex_normal@3x.png")
}
/**
 *
 */
- (void)createfooterView{
    UIButton *nextBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    nextBtn.frame=CGRectMake(180*PSDSCALE_X, 1265*PSDSCALE_Y, 716*PSDSCALE_X, 104*PSDSCALE_Y);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnDidclick) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:GETNCIMAGE(@"register@3x.png") forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
  
    
}
#pragma mark -下一步
-(void)nextBtnDidclick
{
    
//    if ([self checkValidityTextField]) {
//        AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
//        NSString *urlStr=@"http://192.168.1.208:8081/pointLine/app/registerTwo.do";
//        NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
//        parameters[@"userId"]=self.userID;
//        parameters[@"pic"]=self.pic_Path;
//        parameters[@"name"]=self.usertextField.text;
//        parameters[@"email"]=self.email_textField.text;
//        parameters[@"birthday"]=self.bron_textField.text;
//        parameters[@"gender"]=self.gender;
//        [manger POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            // NSLog(@"success");
//            NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
//            
//            //        NSLog(@"%@",code);
//            if ([code isEqualToString:@"300"]) {
//                NSLog(@"参数有误");
//            }
//            if ([code isEqualToString:@"200"]) {
//                NSLog(@"可以下一步");
//                SRCompanycertifyViewController *companyVC=[SRCompanycertifyViewController new];
//                companyVC.userId=self.userID;
//                [self.navigationController pushViewController:companyVC animated:YES];
//            }
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"failure");
//        }];
//        
//        _usertextField.text=@"";
//        _email_textField.text=@"";
//        _bron_textField.text=@"";
//    }
   SRCompanycertifyViewController *companyVC=[SRCompanycertifyViewController new];
   [self.navigationController pushViewController:companyVC animated:YES];
}
#pragma mark -点击日期
-(void)datepickerBtnDidClick
{
    
    _datepicker = [[UIDatePicker alloc] init];
    _datepicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    _datepicker.datePickerMode = UIDatePickerModeDate;
    _bron_textField.inputView = self.datepicker;
    CZKeyboardToolbar *toolbar = [CZKeyboardToolbar toolbar];
    toolbar.kbDelegate = self;
    _bron_textField.inputAccessoryView = toolbar;
    
}
#pragma mark 自定义键盘工具条的代理方法
-(void)keyboardToolbar:(CZKeyboardToolbar *)toolbar btndidSelected:(UIBarButtonItem *)item{
    
    if (item.tag == 2) {//Done按钮点击
        //获取日期显示在textField
        NSDate *date = self.datepicker.date;
        NSLog(@"%@",date);
        //日期转字符串
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置日期格式
        dateFormatter.dateFormat = @"yyyyMMdd";
        
        NSString *dateStr =  [dateFormatter stringFromDate:date];
        
        _bron_textField.text = dateStr;
        [_bron_textField.inputView removeFromSuperview];
        [_bron_textField.inputAccessoryView removeFromSuperview];
    }
    if (item.tag==0) {
        _bron_textField.text = @"";
    }
    
}
#pragma mark -代码创建的toolbar
-(void)codeForToolbar{
    //代码创建UIToolbar
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.backgroundColor = [UIColor grayColor];
    
    //屏幕宽度
    CGFloat screenW = [[UIScreen mainScreen] bounds].size.width;
    toolbar.bounds = CGRectMake(0, 0, screenW, 44);
    
    UIBarButtonItem *previousBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    //固定长度的按钮
    UIBarButtonItem *fixedBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //代码实现要设置宽度
    fixedBtn.width = 10;
    
    
    //可拉伸的按钮
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //添加UIToolbar里面的按钮
    toolbar.items = @[previousBtn,fixedBtn,nextBtn,flexible,doneBtn];
}

-(void)maleBtnDidclick
{
    self.isMale=NO;
    [self setUpMaleImage];
    self.gender=@"1";
     NSLog(@"%@",self.gender);
}
-(void)famaleBtnDidClick
{
    self.isMale=YES;
    [self setUpMaleImage];
    self.gender=@"2";
    NSLog(@"%@",self.gender);
}
#pragma mark -判断性别
-(void)setUpMaleImage
{
    self.isMale?[_maleBtn setImage:GETNCIMAGE(@"sex_normal@3x.png") forState:UIControlStateNormal]:[_maleBtn setImage:GETNCIMAGE(@"sex_selected@3x.png") forState:UIControlStateNormal];
    self.isMale?[_famaleBtn setImage:GETNCIMAGE(@"sex_selected@3x.png")  forState:UIControlStateNormal]:[_famaleBtn setImage:GETNCIMAGE(@"sex_normal@3x.png") forState:UIControlStateNormal];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    [self allEditActionsResignFirstResponder];
}
- (void)allEditActionsResignFirstResponder{
    //用户名
    [[self.view viewWithTag:5] resignFirstResponder];
    //邮箱
    [[self.view viewWithTag:6] resignFirstResponder];
    //出生日期
    [[self.view viewWithTag:7] resignFirstResponder];
}
//更换头像
-(void)changeIcon
{
    NSLog(@"更换个人头像");
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
    
    _usericon = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveImage:_usericon WithName:@"usericon"];
    [_icon_btn setBackgroundImage:_usericon forState:UIControlStateNormal];
    _icon_btn.layer.cornerRadius=self.icon_btn.frame.size.width/2;
    _icon_btn.layer.masksToBounds=YES;
    
}
#pragma mark 保存图片到document
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage); //PNG格式
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
  [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"userName"];
    NSString* totalpath = [documentsDirectory stringByAppendingPathComponent:imageName];
    _totalPath=totalpath;
    // and then we write it out
    [imageData writeToFile:totalpath atomically:NO];
    NSURL *icon_url=[NSURL URLWithString:totalpath];
    NSString *urlstr=[[icon_url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manger=[[AFHTTPRequestOperationManager alloc]init];
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"picture"]=self.usericon;
    [manger POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* code=[NSString stringWithFormat:@"%@",responseObject[@"retCode"]];
        //        NSLog(@"%@",code);
        if ([code isEqualToString:@"300"]) {
            NSLog(@"上传有误");
        }
        if ([code isEqualToString:@"200"]) {
            NSLog(@"上传后的图片路径");
            NSString* pic_Path=[NSString stringWithFormat:@"%@",responseObject[@"pic"]];
            _pic_Path=pic_Path;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
}

- (BOOL)checkValidityTextField
{
    //手机号为空
    if ([(UITextField *)[self.view viewWithTag:5] text] == nil || [[(UITextField *)[self.view viewWithTag:5] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的用户不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:6] text] == nil || [[(UITextField *)[self.view viewWithTag:6] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的邮箱不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([(UITextField *)[self.view viewWithTag:7] text] == nil || [[(UITextField *)[self.view viewWithTag:7] text] isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"输入的出生日期不能为空" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    if ([self.gender isEqualToString:@""]) {
        [Utils alertTitle:@"提示" message:@"请选择性别" delegate:self cancelBtn:@"取消" otherBtnName:nil];
        return NO;
    }
    return YES;
    
    
}


@end



