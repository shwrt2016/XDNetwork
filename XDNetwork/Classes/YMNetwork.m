//
//  YMNetwork.m
//  mxup
//
//  Created by CoolCat.Hero on 2019/3/25.
//  Copyright © 2019 mxit. All rights reserved.
//

#import "YMNetwork.h"
#import "YMNetworkManager.h"

@implementation YMNetwork

+ (void)requstWithMethod:(HttpMethod)method action:(NSString *)action paramDic:(NSMutableDictionary *)paramDic isAlert:(BOOL)isAlert complete:(ComBlock)complete {
    
    YMNetworkManager *manager = [YMNetworkManager shareManager];
//    [manager setSecurityPolicy:[YMNetwork policyWithPinningMode:@""]]; // 加上这行代码，https ssl 验证。
    
    if (!paramDic) paramDic = [NSMutableDictionary dictionary];
    
    switch (method) {
        case POST: {
            [manager POST:action parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [YMNetwork configSuccess:complete isAlert:isAlert responseObject:responseObject serviceName:action paramDic:paramDic];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [YMNetwork configFail:complete error:error isAlert:isAlert serviceName:action paramDic:paramDic];
            }];
        }
            break;
        case GET: {
            [manager GET:action parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [YMNetwork configSuccess:complete isAlert:isAlert responseObject:responseObject serviceName:action paramDic:paramDic];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [YMNetwork configFail:complete error:error isAlert:isAlert serviceName:action paramDic:paramDic];
            }];
        }
            break;
        case PUT: {
            
            [manager PUT:action parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [YMNetwork configSuccess:complete isAlert:isAlert responseObject:responseObject serviceName:action paramDic:paramDic];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [YMNetwork configFail:complete error:error isAlert:isAlert serviceName:action paramDic:paramDic];
            }];
        }
            break;
        case PATCH: {
            
            [manager PATCH:action parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [YMNetwork configSuccess:complete isAlert:isAlert responseObject:responseObject serviceName:action paramDic:paramDic];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [YMNetwork configFail:complete error:error isAlert:isAlert serviceName:action paramDic:paramDic];
            }];
        }
            break;
        case DELETE: {
            
            [manager DELETE:action parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [YMNetwork configSuccess:complete isAlert:isAlert responseObject:responseObject serviceName:action paramDic:paramDic];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [YMNetwork configFail:complete error:error isAlert:isAlert serviceName:action paramDic:paramDic];
            }];
        }
            break;
    }
}

+ (void)requstWithAction:(NSString *)action paramDic:(NSMutableDictionary *)paramDic isAlert:(BOOL)isAlert fileArray:(NSMutableArray<YMNetworkFileModel *> *)fileArray progress:(ProgressBlock)progress complete:(ComBlock)complete {
    
    YMNetworkManager *manager = [YMNetworkManager shareManager];
    if (!paramDic) paramDic = [NSMutableDictionary dictionary];
    
    [manager POST:action parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (YMNetworkFileModel *model in fileArray) {
            [formData appendPartWithFileData:model.fileData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YMNetwork configSuccess:complete isAlert:isAlert responseObject:responseObject serviceName:action paramDic:paramDic];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [YMNetwork configFail:complete error:error isAlert:isAlert serviceName:action paramDic:paramDic];
    }];
}

+ (void)requestDownloadWithDownloadUrl:(NSString *)urlString progress:(ProgressBlock)progress complete:(DownloadComBlock)complete {
    
    YMNetworkManager *manager = [YMNetworkManager shareManager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    }  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (complete) {
            complete(response,filePath,error);
        }
    }];
    [task resume];
}

//处理成功回调
+ (void)configSuccess:(ComBlock)complete isAlert:(BOOL)isAlert responseObject:(id _Nullable)responseObject serviceName:(NSString *)serviceName paramDic:(NSMutableDictionary *)paramDic{
    
    if ([[responseObject objectForKey:@"errcode"] integerValue] == 0) {
        NSLog(@"\n    接口名称---> %@\n    返回数据---> %@",serviceName,responseObject);
        if (complete) {
            complete(YES,responseObject,nil,nil);
        }
    }else{
        NSLog(@"\n    报错接口---> %@\n    报错原因---> %@\n    报错数据---> %@\n    报错传参---> %@",serviceName,[responseObject objectForKey:@"errmsg"],responseObject,paramDic);
//        if (isAlert) [YMAlertView showWithText:[responseObject objectForKey:@"errmsg"] view:nil];
        
        if (complete) {
            complete(NO,responseObject,nil,nil);
        }
    }
}

//处理失败回调
+ (void)configFail:(ComBlock)complete error:(NSError * _Nonnull)error isAlert:(BOOL)isAlert serviceName:(NSString *)serviceName paramDic:(NSMutableDictionary *)paramDic {
    
    NSLog(@"\n    报错接口---> %@\n    报错传参---> %@",serviceName,paramDic);
    NSError *unError = [error.userInfo objectForKey:@"NSUnderlyingError"];
    NSData *data = [unError.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
    NSDictionary *errorDic;
    NSString *errorString;
    if (data) {
        errorDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    } else {
        errorString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    if (errorDic) {
        
        switch ([[errorDic objectForKey:@"status_code"] integerValue]) {
            case 401: {
                //鉴权问题，登出
            }
                break;
            case 500: {
                //服务器异常
//                if (isAlert) [YMAlertView showWithText:@"服务器异常" view:nil];
            }
                break;
            default: {
//                if (isAlert) [YMAlertView showWithText:[errorDic objectForKey:@"errors"] view:nil];
            }
                break;
        }
    } else {
//        if (isAlert) [YMAlertView showWithText:[unError.userInfo[@"NSLocalizedDescription"] length] ? unError.userInfo[@"NSLocalizedDescription"] : error.userInfo[@"NSLocalizedDescription"] ? : @"服务器异常" view:nil];
    }
    
    if (complete) {
        complete(NO,errorDic,error,nil);
    }
}

@end

@implementation YMNetworkFileModel

@end
