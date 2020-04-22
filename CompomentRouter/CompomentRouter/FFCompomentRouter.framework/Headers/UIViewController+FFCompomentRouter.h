//
//  UIViewController+FFCompomentRouter.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (FFCompomentRouter)

/**
 *  采用present的方式打开一个模块，自动通过当前VC的navigationController获取导航的VC
 *
 *  @param moduleName           模块名
 *  @param animated             打开动画
 *  @param params               模块参数
 *  @param completion           打开完成回调
 *  @param callback             模块回调
 *
 *  @return 是否成功调用
 */
- (BOOL)ff_presentModule:(NSString *)moduleName withParams:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(void))completion callback:(void(^)(NSDictionary *moduleInfo))callback;

/**
 *  url打开页面
 *
 *  @param moduleUrl           模块url
 *  @param animated            是否动画
 *
 *  @return 是否成功调用
 */
- (BOOL)ff_displayUrl:(NSString *)moduleUrl animated:(BOOL)animated;

- (BOOL)ff_displayUrl:(NSString *)moduleUrl animated:(BOOL)animated param:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback;


@end

NS_ASSUME_NONNULL_END
