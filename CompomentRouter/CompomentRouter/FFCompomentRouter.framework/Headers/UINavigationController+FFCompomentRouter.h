//
//  UINavigationController+FFCompomentRouter.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (FFCompomentRouter)

/**
 *  采用push的的方式打开模块
 *
 *  @param moduleName 模块名
 *  @param animated   打开动画
 *
 *  @return 是否成功调用
 */
- (BOOL)ff_pushModule:(NSString *)moduleName animated:(BOOL)animated;

/**
 *  采用push的的方式打开模块(有参数)
 *
 *  @param moduleName 模块名
 *  @param params     模块需要的参数
 *  @param animated   打开动画
 *  @param callback   模块的回调
 *
 *  @return 是否成功调用
 */
- (BOOL)ff_pushModule:(NSString *)moduleName withParams:(NSDictionary *)params animated:(BOOL)animated callback:(void(^)(NSDictionary *moduleInfo))callback;


@end

NS_ASSUME_NONNULL_END
