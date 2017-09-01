//
//  IWHttpTool.m
//  WeiBo17
//
//  Created by teacher on 15/8/23.
//  Copyright (c) 2015年 itcast. All rights reserved.
//  封装第三方网络访问模型

#import "IWHttpTool.h"
#import "AFNetworking.h"


@implementation IWHttpTool

+ (void)getWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    //添加基础参数
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
//    IWBaseRequest *request = [[IWBaseRequest alloc] init];
//    [param addEntriesFromDictionary:[request keyValues]];
//    
//
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [sessionManager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%lld", downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"%@", responseObject);
        
        if (success) {
            //回调请求结果
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
        if (failure) {
            failure(error);
        }
    }];
    
    
}


+ (void)postWithUrl:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
     sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//   sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];

    [sessionManager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
         NSLog(@"%lld", uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //在回调之前,一定不能忘了判断block是否有值
        if (success) {
            //回调请求结果
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }

    }];
    
}


@end
