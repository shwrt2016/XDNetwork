//
//  YMNetworkManager.h
//  mxup
//
//  Created by CoolCat.Hero on 2019/3/25.
//  Copyright © 2019 mxit. All rights reserved.
//

#import "AFHTTPSessionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YMNetworkManager : AFHTTPSessionManager

/**
 初始化API管理器
 
 @return        API管理器
 */
+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END
