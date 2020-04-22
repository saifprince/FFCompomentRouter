//
//  FFModuleMethod.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFModuleMethod.h"
#import "FFModuleDescription.h"

@interface FFModuleMethod ()

@property (nonatomic) SEL methodSelector;

@property (nonatomic, copy) NSString *methodName;

@property (nonatomic) BOOL isNativeMethod;

@property (nonatomic) BOOL isClassMethod;

@property (nonatomic) FFModuleParamType methodResultType;

@property (nonatomic, strong) FFModuleParamEnumerator *enumerator;

@end

@implementation FFModuleMethod

- (instancetype)init {
    if (self = [super init]) {
        self.methodName = @"";
        self.isNativeMethod = NO;
        self.isClassMethod = NO;
        self.methodResultType = FFModuleParamTypeEmpty;
    }
    return self;
}

#pragma mark - 设置method相关描述

- (FFModuleMethod *(^)(NSString *))name {
    return ^FFModuleMethod *(NSString *name) {
        NSParameterAssert(name);
        self.methodName = name;
        return self;
    };
}

- (FFModuleMethod *)name:(NSString *)name {
    return self.name(name);
}

- (FFModuleMethod *(^)(SEL))selector {
    return ^FFModuleMethod *(SEL selector) {
        NSParameterAssert(selector);
        self.methodSelector = selector;
        return self;
    };
}

- (FFModuleMethod *)selector:(SEL)selector {
    return self.selector(selector);
}

- (FFModuleMethod *(^)(BOOL))justNative {
    return ^FFModuleMethod *(BOOL justNative) {
        self.isNativeMethod = justNative;
        return self;
    };
}

- (FFModuleMethod *)justNative:(BOOL)justNative {
    return self.justNative(justNative);
}

- (FFModuleMethod *(^)(BOOL))classMethod {
    return ^FFModuleMethod *(BOOL classMethod) {
        self.isClassMethod = classMethod;
        return self;
    };
}

- (FFModuleMethod *)classMethod:(BOOL)classMethod {
    return self.classMethod(classMethod);
}

- (FFModuleMethod *(^)(void (^)(FFModuleParamEnumerator *enumerator)))parameters {
    return ^FFModuleMethod *(void (^paramsDescriptionBlock)(FFModuleParamEnumerator *enumerator)) {
        NSParameterAssert(paramsDescriptionBlock);
        if (paramsDescriptionBlock && self.methodSelector) {
            NSMethodSignature *sig;
            if (self.isClassMethod) {
                sig = [self.module.moduleClass methodSignatureForSelector:self.methodSelector];
            } else {
                sig = [self.module.moduleClass instanceMethodSignatureForSelector:self.methodSelector];
            }
            if (sig) {
                NSUInteger argNum = [sig numberOfArguments];
                for (int i = 2; i < argNum; i++) {
                    FFModuleParam *param = [[FFModuleParam alloc] init];
                    [self.enumerator.params addObject:param];
                }
                paramsDescriptionBlock([self.enumerator enumerate]);
                NSAssert([self.enumerator end], @"请描述所有的参数");
            }
        }
        return self;
    };
}

- (FFModuleMethod *)parameters:(void (^)(FFModuleParamEnumerator *enumerator))paramsDescriptionBlock {
    return self.parameters(paramsDescriptionBlock);
}

- (FFModuleMethod *)resultType:(FFModuleParamType)type {
    return self.resultType(type);
}

- (FFModuleMethod *(^)(FFModuleParamType))resultType {
    return ^FFModuleMethod *(FFModuleParamType returnType) {
        self.methodResultType = returnType;
        return self;
    };
}

#pragma mark - 执行方法

- (id)invokeWithParams:(NSDictionary *)params callback:(void (^)(NSDictionary *))callback {
    id module;
    id returnOb;
    NSMethodSignature *sig;
    if (self.isClassMethod) {
        module = self.module.moduleClass;
        sig = [self.module.moduleClass methodSignatureForSelector:self.methodSelector];
    } else {
        module = [[self.module.moduleClass alloc] init];
        sig = [module methodSignatureForSelector:self.methodSelector];
    }
    if (sig) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
        inv.selector = self.methodSelector;
        inv.target = module;
        [self.enumerator.params enumerateObjectsUsingBlock:^(FFModuleParam * _Nonnull param, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *paramName = param.paramName;
            if (paramName) {
                id paramValue = params[paramName];
                switch (param.paramType) {
                    case FFModuleParamTypeBlock: {
                        paramValue = nil;
                        [inv setArgument:&callback atIndex:idx + 2];
                        break;
                    }
                    case FFModuleParamTypeMap: {
                        if (![paramValue isKindOfClass:[NSDictionary class]] && !param.isStrict) {
                            paramValue = params;
                        } else if (![paramValue isKindOfClass:[NSDictionary class]] && param.isStrict) {
                            paramValue = nil;
                        }
                        break;
                    }
                    case FFModuleParamTypeString: {
                        if (![paramValue isKindOfClass:[NSString class]]) {
                            paramValue = nil;
                        }
                        break;
                    }
                    case FFModuleParamTypeNumber: {
                        if ([paramValue isKindOfClass:[NSString class]]) {
                            paramValue = [[[NSNumberFormatter alloc] init] numberFromString:paramValue];
                        } else if (![paramValue isKindOfClass:[NSNumber class]]) {
                            paramValue = nil;
                        }
                        break;
                    }
                    case FFModuleParamTypeObject: {
                        break;
                    }
                    case FFModuleParamTypeArray: {
                        if (![paramValue isKindOfClass:[NSArray class]]) {
                            paramValue = nil;
                        }
                        break;
                    }
                    case FFModuleParamTypeBool:{
                        break;
                    }
                    default:
                        paramValue = nil;
                        break;
                }
                if (paramValue) {
                    //兼容BOOL类型
                    if (param.paramType == FFModuleParamTypeBool) {
                        BOOL boolValue = [paramValue boolValue];
                        [inv setArgument:&boolValue atIndex:idx + 2];
                    }else {
                        [inv setArgument:&paramValue atIndex:idx + 2];
                    }
                }
            }
        }];

        [inv retainArguments];
        [inv invoke];
        NSUInteger length = sig.methodReturnLength;
        NSString *type = [NSString stringWithUTF8String:sig.methodReturnType];
        if (length > 0
            && ([type isEqualToString:@"@"] || [type isEqualToString:@"B"])
            && self.methodResultType != FFModuleParamTypeUnknown
            && self.methodResultType != FFModuleParamTypeEmpty) {
            //返回值获取
            if ([type isEqualToString:@"B"]) {
                BOOL res = NO;
                [inv getReturnValue:&res];
                returnOb = [NSNumber numberWithBool: res];
            }else {
                void *buffer;
                [inv getReturnValue:&buffer];
                returnOb = (__bridge id)(buffer);
            }
        }
    }

    return returnOb;
}

#pragma mark - getter

- (FFModuleParamEnumerator *)enumerator {
    if (!_enumerator) {
        _enumerator = [[FFModuleParamEnumerator alloc] init];
    }
    return _enumerator;
}
#pragma mark - 模块方法描述

- (NSString *)description {
    NSMutableString *des = [NSMutableString stringWithFormat:@"\n==============方法==============\n名称：%@ \nSEL：%@ \n支持URL：%@ \n类方法：%@ \n", self.methodName, NSStringFromSelector(self.methodSelector), self.isNativeMethod ? @"false" : @"true", self.isClassMethod ? @"true" : @"false"];
    [self.enumerator.params enumerateObjectsUsingBlock:^(FFModuleParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [des appendString:[NSString stringWithFormat:@"参数%@：%@\n", @(idx), [obj description]]];
    }];
    [des appendString:[NSString stringWithFormat:@"返回值：%@\n", [FFModuleParam typeDescription:self.methodResultType]]];
    [des appendString:@"==================================\n"];
    return des.copy;
}

- (NSDictionary *)jsonDescription {
    NSMutableArray *arr = [NSMutableArray array];
    [self.enumerator.params enumerateObjectsUsingBlock:^(FFModuleParam * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj.jsonDescription];
    }];
    NSDictionary *jsonDic = @{@"methodName": self.methodName,
                              @"methodSEL": NSStringFromSelector(self.methodSelector),
                              @"isNativeMethod": @(self.isNativeMethod),
                              @"isClassMethod": @(self.isClassMethod),
                              @"params": arr.copy,
                              @"return": [FFModuleParam typeDescription:self.methodResultType]};
    return jsonDic;
}
@end
