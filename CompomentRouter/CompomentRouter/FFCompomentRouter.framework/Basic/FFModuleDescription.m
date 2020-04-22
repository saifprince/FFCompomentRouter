//
//  FFModuleDescription.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFModuleDescription.h"

@interface FFModuleDescription ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, FFModuleMethod *> *moduleMethods;

@property (nonatomic, copy) NSString *moduleName;

@property (nonatomic) Class moduleClass;
@end

@implementation FFModuleDescription

- (instancetype)init {
    if (self = [super init]) {
        self.moduleName = @"";
    }
    return self;
}
#pragma mark - 模块描述方法

- (FFModuleDescription *(^)(Class))cls {
    return ^FFModuleDescription *(Class cls) {
        if (!cls) {
            return nil;
        }
        self.moduleClass = cls;
        return self;
    };
}

- (FFModuleDescription *)cls:(Class)cls {
    return self.cls(cls);
}

- (FFModuleDescription *(^)(NSString *))name {
    return ^FFModuleDescription *(NSString * name) {
        if (!name) {
            return nil;
        }
        self.moduleName = name;
        return self;
    };
}

- (FFModuleDescription *)name:(NSString *)name {
    return self.name(name);
}

- (FFModuleDescription *(^)(void (^)(FFModuleMethod *method)))method {
    return ^FFModuleDescription *(void (^methodDescriptionBlock)(FFModuleMethod *method)) {
        NSParameterAssert(methodDescriptionBlock);
        if (methodDescriptionBlock) {
            FFModuleMethod *method = [[FFModuleMethod alloc] init];
            method.module = self;
            methodDescriptionBlock(method);
            NSAssert(method.methodName.length, @"请给方法设置名称");
            [self.moduleMethods setObject:method forKey:method.methodName];
        }
        return self;
    };
}

- (FFModuleDescription *)method:(void (^)(FFModuleMethod *method))methodDescriptionBlock {
    return self.method(methodDescriptionBlock);
}

- (FFModuleDescription * _Nonnull (^)(void (^ _Nonnull)(FFModuleMethod * _Nonnull)))openMethod {
    return ^FFModuleDescription *(void (^methodDescriptionBlock)(FFModuleMethod *method)) {
        NSParameterAssert(methodDescriptionBlock);
        if (methodDescriptionBlock) {
            FFModuleMethod *method = [[FFModuleMethod alloc] init];
            method.module = self;
            methodDescriptionBlock(method);
            method.name(@"open");
            NSAssert(method.methodName.length, @"请给方法设置名称");
            [self.moduleMethods setObject:method forKey:method.methodName];
        }
        return self;
    };
}

- (FFModuleDescription *)openMethod:(void (^)(FFModuleMethod * _Nonnull))methodDescriptionBlock {
    return self.openMethod(methodDescriptionBlock);
}
#pragma mark - getter

- (NSMutableDictionary *)moduleMethods {
    if (!_moduleMethods) {
        _moduleMethods = [[NSMutableDictionary alloc] init];
    }
    return _moduleMethods;
}

#pragma mark - 模块描述

- (NSString *)description {
    NSMutableString *des = [NSMutableString stringWithFormat:@"\n************** Module **************\nModuleName：%@ \nClassName：%@", self.moduleName, NSStringFromClass(self.moduleClass)];
    [self.moduleMethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FFModuleMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        [des appendString:[obj description]];
    }];
    [des appendString:@"\n************************************\n"];
    return des.copy;
}

- (NSDictionary *)jsonDescription {
    NSMutableArray *arr = [NSMutableArray array];
    [self.moduleMethods enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, FFModuleMethod * _Nonnull obj, BOOL * _Nonnull stop) {
        [arr addObject:obj.jsonDescription];
    }];
    NSDictionary *jsonDic = @{@"moduleName": self.moduleName,
                              @"moduleClass": NSStringFromClass(self.moduleClass),
                              @"moduleMethods": arr.copy};
    return jsonDic;
}
@end
