//
//  FFServiceProtocol.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFModuleDescription.h"
@protocol FFServiceProtocol <NSObject>

/**
 描述模块的作用

 @param description 模块描述
 */
+ (void)moduleDescription:(FFModuleDescription *)description;

@optional

/**
 *  模块名称  英文驼峰式
 *
 *  @return 模块名称
 */
+ (NSString *)moduleName;

/**
 *  描述模块的作用
 *
 *  @return 模块描述
 */
+ (NSString *)moduleDescription;

/**
 *  模块保护方法 只能在native调用
 *
 *  @return 保护方法列表
 */

@end
