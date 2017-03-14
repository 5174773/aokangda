//
//  RequestManager.m
//  LvXin
//
//  Created by Weiyijie on 15/9/17.
//  Copyright (c) 2015年 showsoft. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"



@implementation RequestManager

/**
 资讯列表
 */
+ (void)informationListWithCategory:(NSString *)_category page:(NSString*)_page succeed:(Succeed)succeed failed:(Failed)failed{
    NSDictionary *dic = @{@"category":_category, @"pageNum":_page};
    
    NSString *urlString = [loginURl stringByAppendingString:@"information_list"];
    
    [RequestManager GetRequestWithUrlString:urlString withDic:dic Succeed:^(NSData *data) {
        succeed(data);
    } andFaild:^(NSError *error) {
        failed(error);
    }];
}

//上传图片
#pragma mark -基本的GET 和POST请求
//---******************************-------带附件 POST请求

+ (void)fileRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic name:(NSString *)name photos:(NSArray*)_photosArray Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSLog(@"POST请求链接 == %@ ",urlString);
    NSLog(@"photoArray:%@",_photosArray);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id formData) {
        for (int i = 0; i <[_photosArray count]; i++) {
            UIImage *loc_image = [_photosArray objectAtIndex:i];
            //            CGSize loc_size = loc_image.size;
            //            loc_image=[FunctionManager compressPicturesWithImage:loc_image newSize:loc_size];
            NSData *dataObj = UIImageJPEGRepresentation(loc_image, UpLoadPicQuality);
            [formData appendPartWithFileData:dataObj name:name fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeed(operation.responseData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        falid(error);
    }];
    
}

+ (void)fileRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic name:(NSString *)name video:(NSData *)videoData Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSLog(@"POST请求链接 == %@ ",urlString);
    //    NSLog(@"photoArray:%@",video);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id formData) {
        //        NSData *dataObj = UIImageJPEGRepresentation(loc_image, UpLoadPicQuality);
        [formData appendPartWithFileData:videoData name:name fileName:@"video.mp4" mimeType:@"multipart/form-data"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeed(operation.responseData);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        falid(error);
    }];
    
}


//*************************************基本的GET 和POST请求


+ (void)GetRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSLog(@"GET请求链接 == %@ ",urlString);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeed(operation.responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        falid(error);
    }];
}


+ (void)GetRequestWithUrlString:(NSString *)urlString Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSLog(@"GET请求链接 == %@ ",urlString);
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeed(operation.responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        falid(error);
    }];
}

+ (void)PostRequestWithUrlString:(NSString *)urlString withDic:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSLog(@"POST请求链接 == %@  %@",urlString,dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeed(operation.responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        falid(error);
    }];
    
    
    
    
}

+ (void)PostRequestWithUrlString:(NSString *)urlString withJson:(NSDictionary *)dic Succeed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSLog(@"POST请求链接 == %@  %@",urlString,dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        succeed(operation.responseData);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        falid(error);
    }];
}


// search_result
+ (void)searchByWord:(NSString *)word PageIndex:(NSString *)pageIndex  Brand:(NSString *)brand Price:(NSString *)price Type:(NSString *)type Series:(NSString *)series Order:(NSString *)order  Succeed:(Succeed)succeed failed:(Failed)failed{
    NSDictionary *param = @{@"brand": brand,
                            @"price": price,
                            @"type": type,
                            @"series": series,
                            @"order": order,
                            @"word": word,
                            @"pageIndx": pageIndex
                            };
    
  
    
    [RequestManager PostRequestWithUrlString:URL_Search_Result withDic:param Succeed:^(NSData *data) {
        
        succeed(data);
        
    } andFaild:^(NSError *error) {
        
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
}

+ (void)autoLinkSearchByWord:(NSString*)word Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSDictionary *param = @{@"word": word
                            };
    
    MMLog(@"search_result params  %@\n%@",param,URL_Search_ByWord);
    
    
    [RequestManager GetRequestWithUrlString:URL_Search_ByWord withDic:param Succeed:^(NSData *data) {
       
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"请求返回结果：%@",returnDic);
        
        }
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
    
    
}


+(void)getChannelsSucceed:(Succeed)succeed failed:(Failed)failed
{
    [RequestManager GetRequestWithUrlString:URL_GetChannels Succeed:^(NSData *data) {
        succeed(data);
       
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
}


+(void)concernOnSoldSucceed:(Succeed)succeed andFaild:(Failed)falid
{
    
    NSDictionary *param = @{
                            @"ID":@"",
                            @"Date":@""
                            };
    [RequestManager GetRequestWithUrlString:URL_Concern_OnSold Succeed:^(NSData *data) {
        
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"请求返回结果：%@",returnDic);
            
        }
    } andFaild:^(NSError *error) {
        falid(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
    
}

+(void)getBrandListSucceed:(Succeed)succeed failed:(Failed)failed
{
    [RequestManager GetRequestWithUrlString:URL_GetBrandList Succeed:^(NSData *data) {
        
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"请求返回结果：%@",returnDic);
            
        }
        
    } andFaild:^(NSError *error) {
        
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
        
    }];
}

+ (void)getSeriesListWihtID:(NSString *)ID Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSDictionary *param = @{@"ID":ID};
    
    [RequestManager GetRequestWithUrlString:URL_GetSeriesList withDic:param Succeed:^(NSData *data) {
        
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"--请求返回结果：%@",returnDic);
            
        }
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
}

+ (void)getCarStyleListWihtID:(NSString *)ID Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSDictionary *param = @{@"ID":ID};
    
    [RequestManager GetRequestWithUrlString:URL_GetCarStyleList withDic:param Succeed:^(NSData *data) {
        
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"请求返回结果：%@",returnDic);
            
        }
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
}

+(void)getCarListByUserWithID:(NSString *)ID Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSDictionary *param = @{@"ID":ID};
    
    [RequestManager PostRequestWithUrlString:URL_GetCarListByUser withDic:param Succeed:^(NSData *data) {
        
        succeed(data);
        
    } andFaild:^(NSError *error) {
        
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
}
+(void)getCustomFoucusListWithDataArray:(NSArray *)dataArray Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSString *urlStr = URL_GetCustomFocusList;
    
    for (int i = 0; i<dataArray.count; i++) {
        NSString *string = dataArray[i];
        
        if (i != dataArray.count - 1) {
            urlStr = [NSString stringWithFormat:@"%@%@,",urlStr,string];
        }else{
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,string];
        }
        
        
        
    }
    
    MMLog(@"^^ %@",urlStr);
    
    urlStr = @"http://wx.akd.cn:9127/CarList/GetCustomFocusList/100072,106656";
    
    [RequestManager GetRequestWithUrlString:urlStr Succeed:^(NSData *data) {
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"-- 请求返回结果：%@",returnDic);
            
        }
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
    
}

/**
 获取车辆详情
 */
+ (void)getCarDetailWithCarId:(NSString *)cardId Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSString *urlStr = [@"https://webapi.akd.cn/CarDetail/GetCarDetail/" stringByAppendingString:[NSString stringWithFormat:@"%@", cardId]];
    
    [RequestManager GetRequestWithUrlString:urlStr Succeed:^(NSData *data) {
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"-- 请求返回结果：%@",returnDic);
            
        }
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];
    
}

/**
 车辆更多配置
 */
+ (void)getCarConfigWithCarId:(NSString *)cardId Succeed:(Succeed)succeed failed:(Failed)failed
{
    NSString *urlStr = [@"https://webapi.akd.cn/CarDetail/GetCarConfig/" stringByAppendingString:[NSString stringWithFormat:@"%@", cardId]];
    
    [RequestManager GetRequestWithUrlString:urlStr Succeed:^(NSData *data) {
        succeed(data);
        if (DEBUGTAG) {
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            MMLog(@"-- 请求返回结果：%@",returnDic);
            
        }
    } andFaild:^(NSError *error) {
        failed(error);
        if (DEBUGTAG) {
            MMLog(@"请求错误原因：%@",error.localizedDescription);
        }
    }];

}


@end
