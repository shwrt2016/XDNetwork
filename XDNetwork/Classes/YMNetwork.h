//
//  XDNetwork.h
//  mxup
//
//  Created by CoolCat.Hero on 2019/3/25.
//  Copyright © 2019 mxit. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    GET,
    POST,
    PUT,
    PATCH,
    DELETE,
} HttpMethod;

/**
 网络请求回调函数
 
 @param success        接口是否成功
 @param responseObject 返回数据
 @param error          错误信息
 @param errorString    错误提示文字
 */
typedef void(^ComBlock)(BOOL success, id responseObject, NSError * error ,NSString * errorString);

/**
 下载回调函数

 @param response  回调实体
 @param filePath  文件路径
 @param error     错误信息
 */
typedef void(^DownloadComBlock)(NSURLResponse *response, NSURL * filePath ,NSError * error);

/**
 上传进度回调
 
 @param progress 进度
 */
typedef void(^ProgressBlock)(NSProgress * progress);

@interface YMNetworkFileModel : NSObject

/**
 文件名称
 */
@property (nonatomic,copy)   NSString  *fileName;
/**
 文件二进制流
 */
@property (nonatomic,strong) NSData    *fileData;
/**
 文件类型
 */
@property (nonatomic,copy)   NSString  *mimeType;
/**
 服务器key
 */
@property (nonatomic,copy)   NSString  *name;

@end

@interface YMNetwork : NSObject


/**
 网络请求
 
 @param method      请求类型
 @param action      请求接口
 @param paramDic    请求参数
 @param isAlert     是否需要提示
 @param complete    回调函数
 */
+ (void)requstWithMethod:(HttpMethod)method
                  action:(NSString *)action
                paramDic:(NSMutableDictionary *)paramDic
                 isAlert:(BOOL)isAlert
                complete:(ComBlock)complete;

/**
 上传文件

 @param action    请求接口
 @param paramDic  请求参数
 @param isAlert   是否需要提示
 @param fileArray 文件模型数组
 @param progress  上传进度
 @param complete  回调函数
 */
+ (void)requstWithAction:(NSString *)action
                paramDic:(NSMutableDictionary *)paramDic
                 isAlert:(BOOL)isAlert
               fileArray:(NSMutableArray <YMNetworkFileModel *>*)fileArray
                progress:(ProgressBlock)progress
                complete:(ComBlock)complete;

/**
 下载请求

 @param urlString 下载链接
 @param progress  下载进度
 @param complete  回调函数
 */
+ (void)requestDownloadWithDownloadUrl:(NSString *)urlString
                              progress:(ProgressBlock)progress
                              complete:(DownloadComBlock)complete;

@end
