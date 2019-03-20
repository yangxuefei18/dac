//
//  HDAFNetWork.m
//  zdsApp
//
//  Created by 汉德 on 2017/2/21.
//  Copyright © 2017年 中电四公司. All rights reserved.
//

#import "HDAFNetWork.h"
#import "MBProgressHUD+JDragon.h"
#import "Common.h"
#import "AppDelegate.h"

@implementation HDAFNetWork
+(void)GET:(NSString *)url params:(NSDictionary *)params
   success:(HDResponseSuccess)success fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:nil sessionConfiguration:NO];
    //设置请求头
    AFHTTPRequestSerializer *request_serializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer = request_serializer;
    [request_serializer setValue:TOKEN forHTTPHeaderField:@"USERTOKEN"];

    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        if ([dic[@"code"] isEqualToString:@"-100"]) {
            [((AppDelegate *)[UIApplication sharedApplication].delegate) enterLoginView];
        }
        if (![dic[@"code"] isEqualToString:@"1"]) {
            [MBProgressHUD hideHUD];
            if (dic[@"msg"] != NULL && ![dic[@"msg"] isEqualToString:@""]){
                [MBProgressHUD showTipMessageInWindow:dic[@"msg"] yOffset:SCREENHEIGHT/2-100 color:nil];
            }
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSDictionary *errDic =error.userInfo;
        if ([errDic[@"_kCFStreamErrorCodeKey"] isKindOfClass:[NSNumber class]]) {
            if ([errDic[@"_kCFStreamErrorCodeKey"] intValue] == 50) {
                [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
            }else{
                [MBProgressHUD showTipMessageInWindow:@"服务器繁忙，请稍后重试！" yOffset:SCREENHEIGHT/2-100 color:nil];
            }
        }else{
            [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
        }

        fail(task,error);
    }];
}


+(void)GET_TT:(NSString *)url params:(NSDictionary *)params
   success:(HDResponseSuccess)success fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:nil sessionConfiguration:NO];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        if ([dic[@"code"] isEqualToString:@"-100"]) {
//            [((AppDelegate *)[UIApplication sharedApplication].delegate) enterLoginView];
//            [((AppDelegate *)[UIApplication sharedApplication].delegate) restartTimer:YES];
        }
        if (![dic[@"code"] isEqualToString:@"1"]) {
            if (dic[@"msg"] != NULL && ![dic[@"msg"] isEqualToString:@""]){
                [MBProgressHUD showTipMessageInWindow:dic[@"msg"] yOffset:SCREENHEIGHT/2-100 color:nil];
            }
        }
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *errDic =error.userInfo;
        if ([errDic[@"_kCFStreamErrorCodeKey"] isKindOfClass:[NSNumber class]]) {
            if ([errDic[@"_kCFStreamErrorCodeKey"] intValue] == 50) {
                [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
            }else{
                [MBProgressHUD showTipMessageInWindow:@"服务器繁忙，请稍后重试！" yOffset:SCREENHEIGHT/2-100 color:nil];
            }
        }else{
            [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
        }
        
        fail(task,error);
    }];
}

+(void)GET:(NSString *)url baseURL:(NSString *)baseUrl params:(NSDictionary *)params
   success:(HDResponseSuccess)success fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        if ([dic[@"code"] isEqualToString:@"1"]) {
            success(task,dic);
        }else{
            if ([dic[@"code"] isEqualToString:@"-100"]) {
//                [((AppDelegate *)[UIApplication sharedApplication].delegate) enterLoginView];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate) restartTimer:YES];
            }
            [MBProgressHUD hideHUD];
            if (dic[@"msg"] != NULL && ![dic[@"msg"] isEqualToString:@""]){
                [MBProgressHUD showTipMessageInWindow:dic[@"msg"]];
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSDictionary *errDic =error.userInfo;
        if ([errDic[@"_kCFStreamErrorCodeKey"] isKindOfClass:[NSNumber class]]) {
            if ([errDic[@"_kCFStreamErrorCodeKey"] intValue] == 50) {
                [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
            }else{
                [MBProgressHUD showTipMessageInWindow:@"服务器繁忙，请稍后重试！" yOffset:SCREENHEIGHT/2-100 color:nil];
            }
        }else{
            [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
        }

        fail(task,error);
    }];
    
}

+(void)POST:(NSString *)url params:(NSDictionary *)params
    success:(HDResponseSuccess)success {
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:nil sessionConfiguration:NO];
    
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        id dic = [HDAFNetWork responseConfiguration:responseObject];
        if ([dic[@"code"] isEqualToString:@"1"]) {
            success(task,dic);
        }else{
            if ([dic[@"code"] isEqualToString:@"-100"]) {
//                [((AppDelegate *)[UIApplication sharedApplication].delegate) enterLoginView];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate) restartTimer:YES];
            }

            [MBProgressHUD hideHUD];
            if (dic[@"msg"] != NULL && ![dic[@"msg"] isEqualToString:@""]){
                [MBProgressHUD showTipMessageInWindow:dic[@"msg"]];
            }
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showTipMessageInWindow:@"服务器繁忙，请稍后重试！"];
    }];
    
}


+(void)POST:(NSString *)url params:(NSDictionary *)params
    success:(HDResponseSuccess)success fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:nil sessionConfiguration:NO];
    //设置请求头
//    AFHTTPRequestSerializer *request_serializer = [AFHTTPRequestSerializer serializer];
//    manager.requestSerializer = request_serializer;
//    [request_serializer setValue:TOKEN forHTTPHeaderField:@"USERTOKEN"];
//    manager.requestSerializer = [AFJSONRequestSerializer new];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
//    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"USERTOKEN"];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    //向请求头中添加参数
    [manager.requestSerializer setValue:TOKEN forHTTPHeaderField:@"USERTOKEN"];
    
  
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        if ([dic[@"code"] isEqualToString:@"1"]) {
            success(task,dic);
        }else{
            if ([dic[@"code"] isEqualToString:@"-100"]) {
//                [((AppDelegate *)[UIApplication sharedApplication].delegate) enterLoginView];
//                [((AppDelegate *)[UIApplication sharedApplication].delegate) restartTimer:YES];
            }
            if (dic[@"msg"] != nil && ![dic[@"msg"] isEqualToString:@""]){
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:dic[@"msg"] yOffset:SCREENHEIGHT/2-100 color:nil];            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUD];
        NSDictionary *errDic =error.userInfo;
        if ([errDic[@"_kCFStreamErrorCodeKey"] isKindOfClass:[NSNumber class]]) {
            if ([errDic[@"_kCFStreamErrorCodeKey"] intValue] == 50) {
                [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
            }else{
                [MBProgressHUD showTipMessageInWindow:@"服务器繁忙，请稍后重试！" yOffset:SCREENHEIGHT/2-100 color:nil];
            }
        }else{
            [MBProgressHUD showTipMessageInWindow:@"请检查您的网络连接" yOffset:SCREENHEIGHT/2-100 color:nil];
        }
//        [MBProgressHUD showTipMessageInWindow:@"服务器繁忙，请稍后重试！"];
        fail(task,error);
    }];
}

+(void)POST:(NSString *)url baseURL:(NSString *)baseUrl params:(NSDictionary *)params
    success:(HDResponseSuccess)success fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:baseUrl sessionConfiguration:NO];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        
        success(task,dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(void)uploadWithURL:(NSString *)url params:(NSDictionary *)params fileData:(NSData *)filedata name:(NSString *)name fileName:(NSString *)filename mimeType:(NSString *) mimeType progress:(HDProgress)progress success:(HDResponseSuccess)success fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:nil sessionConfiguration:NO];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        success(task,dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(void)uploadWithURL:(NSString *)url
             baseURL:(NSString *)baseurl
              params:(NSDictionary *)params
            fileData:(NSData *)filedata
                name:(NSString *)name
            fileName:(NSString *)filename
            mimeType:(NSString *) mimeType
            progress:(HDProgress)progress
             success:(HDResponseSuccess)success
                fail:(HDResponseFail)fail{
    
    AFHTTPSessionManager *manager = [HDAFNetWork managerWithBaseURL:baseurl sessionConfiguration:YES];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:filedata name:name fileName:filename mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        id dic = [HDAFNetWork responseConfiguration:responseObject];
        
        success(task,dic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(task,error);
    }];
}

+(NSURLSessionDownloadTask *)downloadWithURL:(NSString *)url
                                 savePathURL:(NSURL *)fileURL
                                    progress:(HDProgress )progress
                                     success:(void (^)(NSURLResponse *, NSURL *))success
                                        fail:(void (^)(NSError *))fail{
    AFHTTPSessionManager *manager = [self managerWithBaseURL:nil sessionConfiguration:YES];
    
    NSURL *urlpath = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlpath];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [fileURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            fail(error);
        }else{
            success(response,filePath);
        }
    }];
    
    [downloadtask resume];
    
    return downloadtask;
}

#pragma mark - Private

+(AFHTTPSessionManager *)managerWithBaseURL:(NSString *)baseURL  sessionConfiguration:(BOOL)isconfiguration{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager =nil;
    
    NSURL *url = [NSURL URLWithString:baseURL];
    
    if (isconfiguration) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url sessionConfiguration:configuration];
    }else{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return manager;
}

+(id)responseConfiguration:(id)responseObject{
    
    NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    //将结果转存至可变字典中
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    //检测status字段
    if ([dic[@"code"] isKindOfClass:[NSNumber class]]){
        mDic[@"code"] = [NSString stringWithFormat:@"%ld",[dic[@"code"] integerValue]];
    }else{
        mDic[@"code"] = @"-2000";
    }
    
    //检测message字段
    if (![dic[@"msg"] isKindOfClass:[NSString class]]){
        mDic[@"msg"] = @"";
    }else{
        if ([dic[@"msg"] isEqualToString:@""]) {
            mDic[@"msg"] = @"";
        }else{
            mDic[@"msg"] = dic[@"msg"];
        }
    }
    
    NSMutableDictionary *tmpDic=NULL;
    NSMutableArray *tmpArray=NULL;
    //检测并转换object字段
    if ([dic[@"object"] isKindOfClass:[NSDictionary class]]) {
        int i = 0;
        for (NSString *key in dic[@"object"]) {
            i++;
        }
        if (i>0){
            tmpDic = [NSMutableDictionary dictionaryWithDictionary:dic[@"object"]];
        }else{
            //空对象{}
            tmpDic = NULL;
        }
    }else{
        tmpDic = NULL;
    }

    
    //检测并转换list字段
    if ([dic[@"list"] isKindOfClass:[NSArray class]]) {
        tmpArray = [NSMutableArray arrayWithArray:dic[@"list"]];
    }else{
        tmpArray = NULL;
    }

    if ((tmpArray == NULL || tmpArray.count == 0) && tmpDic!= NULL ) {
        mDic[@"data"] = [NSMutableArray arrayWithObject: dic[@"object"]];
    }else if ((tmpArray != NULL && tmpArray.count > 0)  && tmpDic == NULL ) {
        mDic[@"data"] = dic[@"list"];
    }else{
        mDic[@"data"] = [NSMutableArray new];
    }

    //结果中去掉 list 和 object 统一返回 data
    mDic[@"list"] = NULL;
    mDic[@"object"] = NULL;
    
    return mDic;
    
}

+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
@end
