//
//  YMNetworkManager.m
//  mxup
//
//  Created by CoolCat.Hero on 2019/3/25.
//  Copyright © 2019 mxit. All rights reserved.
//

#import "YMNetworkManager.h"

@implementation YMNetworkManager

+ (instancetype)shareManager {
    
    static YMNetworkManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YMNetworkManager alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        // 请求超时设定
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
        manager.requestSerializer.timeoutInterval = 60.f;
    });
    
    return manager;
}

/**
 支持HTTPS(校验证书，不可以抓包)
 支持HTTPS（不校验证书，可以抓包）
 
 @param certificate 证书名称 校验证书
 @return 返回 manager
 */
+ (AFSecurityPolicy *)policyWithPinningMode:(NSString *)certificate {
    
    //    AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    
    // 客户端是否信任非法证书
    securityPolicy.allowInvalidCertificates = YES;
    // 是否在证书域字段中验证域名
    [securityPolicy setValidatesDomainName:NO];
    
    if (certificate) {
        // 设置证书模式
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificate ofType:@"cer"];
        NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:[[NSSet alloc] initWithObjects:cerData, nil]];
        return securityPolicy;
    }else{
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        return securityPolicy;
    }
}

@end
