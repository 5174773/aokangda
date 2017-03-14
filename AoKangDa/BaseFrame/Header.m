
//
//  GetImage.m
//  PuBar
//
//  Created by showsoft on 15-7-2.
//  Copyright (c) 2015年 秀软. All rights reserved.
//

#import "Header.h"

//系统版本
#define DEVICE_VERSION  [[UIDevice currentDevice].systemVersion floatValue]

@implementation Header

+ (UIImage *)getTheImageNoCache:(NSString *)name{
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], name]];
    if (image) {
        return image;
    }else{
        name = [NSString stringWithFormat:@"%@@3x.%@",[name componentsSeparatedByString:@"."][0],[name componentsSeparatedByString:@"."][1]];
        image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], name]];
        if (image) {
            return image;
        }else{
            name = [NSString stringWithFormat:@"%@@2x.%@",[name componentsSeparatedByString:@"."][0],[name componentsSeparatedByString:@"."][1]];
            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], name]];
            if (image) {
                return image;
            }else{
                return nil;
            }
        }
    }
}

+ (UIImage *)getTheImageWithCache:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    if (image) {
        return image;
    }else{
        name = [NSString stringWithFormat:@"%@@3x.%@",[name componentsSeparatedByString:@"."][0],[name componentsSeparatedByString:@"."][1]];
        image = [UIImage imageNamed:name];
        if (image) {
            return image;
        }else{
            name = [NSString stringWithFormat:@"%@@2x.%@",[name componentsSeparatedByString:@"."][0],[name componentsSeparatedByString:@"."][1]];
            image = [UIImage imageNamed:name];
            if (image) {
                return image;
            }else{
                return nil;
            }
        }
    }
}

+ (UIImage *)getTheOriginalImage:(NSString *)name{
    UIImage *image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (image) {
        return image;
    }else{
        name = [NSString stringWithFormat:@"%@@3x.%@",[name componentsSeparatedByString:@"."][0],[name componentsSeparatedByString:@"."][1]];
        image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if (image) {
            return image;
        }else{
            name = [NSString stringWithFormat:@"%@@2x.%@",[name componentsSeparatedByString:@"."][0],[name componentsSeparatedByString:@"."][1]];
            image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            if (image) {
                return image;
            }else{
                return nil;
            }
        }
    }
}

+ (UIImage *)getButonImageWithName:(NSString *)name
{
    if ([name rangeOfString:@"."].location == NSNotFound)
    {
        NSLog(@"图片名称不正确");
        return  nil;
    }
    
    NSString *headStr = [[name componentsSeparatedByString:@"."] firstObject];
    NSString *footerStr = [[name componentsSeparatedByString:@"."] lastObject];
    NSString *headStr1 =  [headStr stringByAppendingString:@"@3x"];
    NSString *directory = RESOURCES_SUBPATH;
    
    
    NSString *pathStr = [NSString stringWithFormat:@"%@.%@",headStr1,footerStr];
    NSString * directory1 = [RESOURCES_PATH stringByAppendingPathComponent:directory];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:nil inDirectory:directory1];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

+ (UIImage *)getButonImageAdaptationSetimageWithName:(NSString *)name
{
    if ([name rangeOfString:@"."].location == NSNotFound)
    {
        NSLog(@"图片名称不正确");
        return  nil;
    }
    
    NSString *headStr = [[name componentsSeparatedByString:@"."] firstObject];
    NSString *footerStr = [[name componentsSeparatedByString:@"."] lastObject];
    NSString *headStr1 =  [headStr stringByAppendingString:@"@3x"];
    if (IS_Phone4S) {
        headStr1 =  [headStr stringByAppendingString:@"@2x"];
    }
    NSString *directory = RESOURCES_SUBPATH;
    
    
    NSString *pathStr = [NSString stringWithFormat:@"%@.%@",headStr1,footerStr];
    NSString * directory1 = [RESOURCES_PATH stringByAppendingPathComponent:directory];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:pathStr ofType:nil inDirectory:directory1];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}



+ (CGRect)getFrameWithX:(CGFloat)X Y:(CGFloat)Y Width:(CGFloat)width Height:(CGFloat)height
{
    CGRect frame;
    
    frame = CGRectMake(X*[Header getScaleX], Y*[Header getScaleY], width*[Header getScaleX], height*[Header getScaleY]);
    
    return frame;
}

+ (CGFloat)getScaleX
{
    CGFloat X;
    
    if (IS_Phone6_Plus)
    {
        X = 414/320.f;
    }
    else if (IS_Phone6)
    {
        X = 375/320.f;
    }
    else
    {
        X = 1.0;
        
    }
    return X;
    
    
}

+ (CGFloat)getScaleY
{
    CGFloat Y;
    
    if (IS_Phone6_Plus)
    {
        Y = 736/568.f;
    }
    else if (IS_Phone6)
    {
        Y = 667/568.f;
    }else
    {
        Y = 1.0;
    }
    return Y;
}

+ (CGFloat)irScaleX{
    CGFloat X;
    if (IS_Phone6_Plus)
    {
        X = 1.0;
    }
    else if (IS_Phone6)
    {
        X = 320/375.f;
    }
    else
    {
        X = 320/414.f;
    }
    return X;
}

+ (CGFloat)irScaleY{
    CGFloat X;
    if (IS_Phone6_Plus)
    {
        X = 1.0;
    }
    else if (IS_Phone6)
    {
        X = 320/375.f;
    }
    else
    {
        X = 320/414.f;
    }
    return X;
}

//获取内容label
+ (CGSize)getContentHightWithContent:(NSString *)content font:(UIFont *)font constraint:(CGSize)constraint
{
    
    CGSize size ;
    
    size = [content boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return  size;
}
+ (NSString *)formateString:(id)object{
    if (object == nil || object == NULL || [object isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return  [NSString stringWithFormat:@"%@",object];
}

+ (void)generyallyAnimationWithView:(UIView *)animationView animationType:(GenerallyAnimationEnum)animationType duration:(float)animationTime delayTime:(float)delayTime finishedBlock: (void (^)(void))completion{
    CGRect oriFrame = animationView.frame;
    CGRect lastFrame = oriFrame;
    UIView *fatherView = animationView.superview;
    CGRect fatherFrame = fatherView.frame;
    float fallValue = 1.0 ;
    float viewAlphaValue = 1.0;
    UIImageView *converView = [[UIImageView alloc]initWithFrame:animationView.bounds];
    converView.backgroundColor = [UIColor redColor];
    CGRect converFrame = converView.bounds ;
    CGRect converBounds = converFrame;
    
    switch (animationType) {
        case GenerallyAnimationSliderFormTop:
            animationView.alpha = 0 ;
            lastFrame.origin.y = -1 * (oriFrame.size.height);
            break;
        case GenerallyAnimationSliderToTop:
            oriFrame.origin.y = -1 *(oriFrame.size.height);
            break;
        case GenerallyAnimationSliderFormBottom:
            animationView.alpha = 0 ;
            lastFrame.origin.y = fatherFrame.size.height ;
            break;
        case GenerallyAnimationSliderToBottom:
            oriFrame.origin.y = fatherFrame.size.height ;
            break;
        case GenerallyAnimationSliderFormLeft:
            animationView.alpha = 0 ;
            lastFrame.origin.x = -1 * (oriFrame.size.width) ;
            break;
        case GenerallyAnimationSliderToLeft:
            oriFrame.origin.x = -1 *(oriFrame.size.width);
            break;
        case GenerallyAnimationSliderFormRight:
            animationView.alpha = 0 ;
            lastFrame.origin.x = fatherFrame.size.width;
            break;
        case GenerallyAnimationSliderToRight:
            oriFrame.origin.x = oriFrame.size.width ;
            break;
        case GenerallyAnimationFallIn:
            animationView.alpha = 0 ;
            animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), 1.5, 1.5);
            break;
        case GenerallyAnimationFallOut:
            animationView.alpha = 1 ;
            fallValue = 2.0 ;
            viewAlphaValue = 0.0 ;
            break;
        case GenerallyAnimationPopIn:
            viewAlphaValue = 0.0 ;
            fallValue = 0.1 ;
            oriFrame.origin.x = 512 - 50 ;
            oriFrame.origin.y = 768/2 - 50 ;
            oriFrame.size = CGSizeMake(100, 100);
            break;
        case GenerallyAnimationPopOut:
            animationView.alpha = 0 ;
            animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), 0.1, 0.1);
            //            lastFrame = CGRectMake(oriFrame.origin.x + oriFrame.size.width/2 - 10, oriFrame.origin.y + oriFrame.size.height/2 - 10, 20, 20);
            viewAlphaValue = 1.0 ;
            fallValue = 1.0 ;
            break;
        case GenerallyAnimationFallSliderFormLeft:
            animationView.alpha = 0 ;
            lastFrame.size.width = 1 ;
            lastFrame.origin.y -= 10;
            animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), 1.5, 1.5);
            break;
        case GenerallyAnimationFallSliderFormRight:
            animationView.alpha = 0 ;
            lastFrame.size.width = 1 ;
            lastFrame.origin.x += oriFrame.size.width - 1 ;
            lastFrame.origin.y -= 15;
            animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), 1.5, 1.5);
            break;
        case GenerallyAnimationFallSliderFormTop:
            animationView.alpha = 0 ;
            lastFrame.size.height = 1 ;
            lastFrame.size.width = 1 ;
            lastFrame.origin.x -= 10 ;
            lastFrame.origin.y -= 10 ;
            animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), 1.5, 1.5);
            break;
        case GenerallyAnimationFallSliderFormBottom:
            animationView.alpha = 0 ;
            lastFrame.size.width = 1 ;
            lastFrame.size.height = 1 ;
            lastFrame.origin.x -= 10 ;
            lastFrame.origin.y += oriFrame.size.height - 1 ;
            lastFrame.origin.y -= 10 ;
            animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), 1.5, 1.5);
            break;
        case GenerallyAnimationConverLayerFormLeft:
            converFrame.origin.x -= converFrame.size.width ;
            animationView.alpha = 1 ;
            converView.frame = converFrame ;
            [animationView.layer setMask:converView.layer];
            break;
        case GenerallyAnimationConverLayerFormRight:
            converFrame.origin.x = converFrame.size.width ;
            animationView.alpha = 1 ;
            converView.frame = converFrame ;
            [animationView.layer setMask:converView.layer];
            break;
        case GenerallyAnimationConverLayerFormTop:
            converFrame.origin.y -= converFrame.size.height ;
            animationView.alpha = 1 ;
            converView.frame = converFrame ;
            [animationView.layer setMask:converView.layer];
            break;
        case GenerallyAnimationConverLayerFormBottom:
            converFrame.origin.y = converFrame.size.height ;
            animationView.alpha = 1 ;
            converView.frame = converFrame ;
            [animationView.layer setMask:converView.layer];
            break;
        case GenerallyAnimationConverLayerFormCenter:
            
            converView.image = GETNCIMAGE(@"CircleLayerImage.png");
            converView.backgroundColor = [UIColor clearColor];
            converFrame.origin.x = converFrame.size.width / 2 - 1 ;
            converFrame.origin.y = converFrame.size.height / 2 - 1 ;
            converFrame.size = CGSizeMake(2, 2);
            converView.frame = converFrame ;
            [animationView.layer setMask:converView.layer];
            animationView.alpha = 0 ;
            
            converFrame = converBounds;
            converBounds = CGRectMake(-50, -50, converFrame.size.width+100, converFrame.size.height+100);
            
            viewAlphaValue = 1 ;
            break;
        case GenerallyAnimationFadeIn:
            animationView.alpha = 0 ;
            viewAlphaValue = 1 ;
            break;
        case GenerallyAnimationFadeOut:
            animationView.alpha = 1 ;
            viewAlphaValue = 0 ;
            break;
        default:
            break;
    }
    switch (animationType) {
        case GenerallyAnimationFallIn:
        case GenerallyAnimationPopOut:
            
            break;
            
        default:
            animationView.frame = lastFrame ;
            break;
    }
    
    [UIView animateWithDuration:animationTime delay:delayTime options:UIViewAnimationOptionCurveLinear animations:^{
        animationView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0.0), fallValue, fallValue);
        animationView.frame = oriFrame ;
        animationView.alpha = viewAlphaValue ;
        
        converView.frame = converBounds ;
    }completion:^(BOOL finshed){
        if( finshed ){
            [converView removeFromSuperview];
            
            if( completion ){
                completion();
            }
        }
    }];
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


+ (NSString *)DicValueForKey:(NSDictionary *)dic key:(NSString *)key{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        if ([[dic allKeys] containsObject:key]) {
            return [dic objectForKey:key];
        }else{
            NSLog(@"dictionary：%@ without key:%@ !",dic,key);
            if (DEBUGTAG) {
                return key;
            }else{
                return @"";
            }
        }
    }else{
        NSLog(@"dic is no NSDictionary class");
        return @"";
    }
}

//+ (NSString *)updateLanguage{
//    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",language] ofType:@"lproj"];
//
//
//    [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:@"" table:nil]
//}

#pragma mark- 加载动画
+ (UIImageView *)gifAnimationWithView:(UIView *)view{
    view.backgroundColor = [UIColor whiteColor];
    //加载
    float loc_number = 0.5;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"people_%zd", i]];
        [idleImages addObject:image];
    }
    
    UIImageView *loadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 54, 58)];
    loadView.center = CGPointMake(VIEW_W(view)/2, VIEW_H(view)/2);
    loadView.animationImages = idleImages;
    loadView.animationDuration = loc_number;
    [loadView startAnimating];
    loadView.backgroundColor = [UIColor redColor];
    [view addSubview:loadView];
    
    UILabel *loc_lable = [[UILabel alloc] initWithFrame:CGRectMake(-VIEW_X(loadView), VIEW_H(loadView), SCREEN_WIDTH, 30*GETSCALE_X)];
    loc_lable.text = MMLocalizedString(@"NEWS_MJ_HEARD_Refreshing", @"狂奔加载中...");
    loc_lable.textColor = RGBACOLOR(40, 139, 221, 1);
    loc_lable.font = [UIFont systemFontOfSize:14.f*GETSCALE_X];
    [loadView addSubview:loc_lable];
    loc_lable.textAlignment = NSTextAlignmentCenter;
    
    return loadView;
}

+ (void)gifRemoveAnimationWithView:(UIImageView *)loadView{
    if (loadView) {
        [loadView stopAnimating];
        [UIView animateWithDuration:0.5 animations:^{
            loadView.alpha = 0;
        } completion:^(BOOL finished) {
            [loadView removeFromSuperview];
        }];
        loadView = nil;
    }
}

+ (NSString *)thousandsSeparatorString:(NSString *)string{
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    NSString *numberString;
    if ([string containsString:@"."]) {
        numberString = [numberFormatter stringFromNumber: [NSNumber numberWithFloat:[string floatValue]]];
    }else{
        numberString = [numberFormatter stringFromNumber: [NSNumber numberWithInteger:[string integerValue]]];
    }
    return numberString;
}

+ (NSString *)getNowTime{
    //当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}

@end
