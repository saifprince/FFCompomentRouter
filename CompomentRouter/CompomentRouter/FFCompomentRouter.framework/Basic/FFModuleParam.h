//
//  FFModuleParam.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FFModuleParamType) {
    FFModuleParamTypeString,//字符串类型,参数会被转为NSString
    FFModuleParamTypeNumber,//数字类型，参数会被转为NSNumber
    FFModuleParamTypeMap,//字典类型，参数对应的name如果无法找到或者参数不是字典类型，模块接收到的所有参数组成的字典会被传入该参数，map支持strict模式
    FFModuleParamTypeArray,//数组类型，
    FFModuleParamTypeBlock,//block类型，模块接收的block会被传入该类型对应的参数
    FFModuleParamTypeObject,//其他对象类型，比如UIImage
    FFModuleParamTypeUnknown,//参数初始化类型
    FFModuleParamTypeEmpty,//函数返回空值类型，默认的函数返回值类型
    FFModuleParamTypeBool,//返回BOOL类型
};

@interface FFModuleParam : NSObject

/**
 参数别名
 */
@property (nonatomic, copy, readonly) NSString *paramName;

/**
 参数类型
 */
@property (nonatomic, readonly) FFModuleParamType paramType;

/**
 是否严格匹配，默认no，开启严格匹配的参数，会在参数列表里寻找对应名称和对应类型的数据，不再有兼容处理，目前只有map支持该模式
 */
@property (nonatomic, readonly) BOOL isStrict;

/**
 设置参数是否name type 严格匹配
 */
- (FFModuleParam *(^)(BOOL))strict;

/**
 设置参数是否name type 严格匹配

 @param isStrict 是否严格匹配
 @return 参数
 */
- (FFModuleParam *)strict:(BOOL)isStrict;

/**
 设置最近一个参数的别名
 */
- (FFModuleParam *(^)(NSString *))name;

/**
 设置最近一个参数的别名

 @param name 别名

 @return 参数
 */
- (FFModuleParam *)name:(NSString *)name;

/**
 设置最近一个参数的类型
 */
- (FFModuleParam *(^)(FFModuleParamType))type;

/**
 设置最近一个参数的类型

 @param type 类型

 @return 参数
 */
- (FFModuleParam *)type:(FFModuleParamType)type;

/**
 返回参数的描述

 @return 参数描述
 */
+ (NSString *)typeDescription:(FFModuleParamType)type;

/**
 返回字典描述

 @return 参数的字典描述
 */
- (NSDictionary *)jsonDescription;
@end
