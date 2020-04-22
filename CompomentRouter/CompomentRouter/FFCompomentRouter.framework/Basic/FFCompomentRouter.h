//
//  FFCompomentRouter.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFCompomentRouter : NSObject

+ (instancetype)router;

- (void)start;

/**
 *  native获取模块对象
 *
 *  @param moduleName 模块名
 *
 *  @return 模块对象
 */
- (id)moduleWithName:(NSString *)moduleName;

/**
 *  native推荐使用该方法调用模块方法
 *
 *  @param serviceName  模块方法
 *  @param moduleName   模块名
 *  @param params       模块需要的参数
 *  @param callback     模块回调
 *
 *  @return 模块服务返回值
 */
- (id)performServiceWithName:(NSString *)serviceName inModuleName:(NSString *)moduleName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;

/**
 *  native推荐使用该方法调用模块方法<名称问题，逐步废弃>
 *
 *  @param selectorName 模块方法
 *  @param moduleName   模块名
 *  @param params       模块需要的参数
 *  @param callback     模块回调
 *
 *  @return 模块服务返回值
 */
- (id)performServiceWithSelectorName:(NSString *)selectorName inModuleName:(NSString *)moduleName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback ;

/**
 *  native获取模块对象并传参
 *
 *  @param moduleName 模块名
 *  @param params     模块参数
 *  @param callback   模块回调
 *
 *  @return 模块对象
 */
- (id)openModuleWithName:(NSString *)moduleName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;

/**
 *  url获取模块对象
 *
 *  @param moduleUrl 模块url
 *
 *  @return 模块对象
 */
- (id)moduleWithUrl:(NSString *)moduleUrl;

/**
*  url调用方法
*
*  @param url 模块url
*  @param param 模块参数
*
*  @return 模块对象
*/
- (id)performServiceWithUrl:(NSString *)url withParam:(NSDictionary *)param;

/**
 *  针对method调用需要对象强制持有方法
 *
 *  @param object 对象
 *
 */
- (void)setStrongTargetObject:(NSObject *)object;

- (void)setSDKsConfigEnble:(BOOL)configEnble;

@end

NS_ASSUME_NONNULL_END
