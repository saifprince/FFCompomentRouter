//
//  FFCompomentRouter.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFCompomentRouter.h"
#import <objc/runtime.h>
#import "FFServiceProtocol.h"
#import "FFModuleDescription.h"
#import "FFCompomentRouterNotFoundViewController.h"
#import "FFModuleURL.h"

@interface FFCompomentRouter()

@property (nonatomic, strong) NSObject *strongObject;
@property (nonatomic, assign) BOOL *configEnble;

@end

@implementation FFCompomentRouter

static NSDictionary<NSString *, FFModuleDescription *> *cache;

#pragma mark - init

+ (void)load {
    [[FFCompomentRouter router] start];
}

+ (instancetype)router {
    static FFCompomentRouter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FFCompomentRouter alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self == [super init]) {
        [self cacheModuleClasses];
    }
    return self;
}

- (void)start {
    //TO DO: 启动缓存模块
}

- (void)cacheModuleClasses {
    if (cache.count) {
        return;
    }
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    Class *classes;
    unsigned int outCount;
    classes = objc_copyClassList(&outCount);
    NSMutableDictionary *tmpCache = [NSMutableDictionary dictionary];
    for (unsigned int i = 0; i < outCount; i++) {
        Class cls = classes[i];
        if (class_conformsToProtocol(cls, @protocol(FFServiceProtocol))) {
            FFModuleDescription *moduleDes;
            if ([cls respondsToSelector:@selector(moduleDescription:)]) {
                moduleDes = [[FFModuleDescription alloc] init].cls(cls);
                [cls moduleDescription:moduleDes];
            }
            if (!moduleDes) {
                return;
            }
            [tmpCache setObject:moduleDes forKey:moduleDes.moduleName];
        }
    }
    free(classes);
    cache = tmpCache;
    NSLog(@"Module Register Time: %f ms", (CFAbsoluteTimeGetCurrent() - startTime)*1000);
}

#pragma mark - Public Method
#pragma mark - sub service method
/**
 * 模块名调用
 */
- (id)moduleWithName:(NSString *)moduleName {
    FFModuleDescription *moduleDes = [self moduleDescriptionWithName:moduleName];
    if (!moduleDes) {
        return [FFCompomentRouterNotFoundViewController new];
    }
    if (!moduleDes.moduleClass) {
        return [FFCompomentRouterNotFoundViewController new];
    }
    return [[moduleDes.moduleClass alloc] init];
}

//perform action in module
//逐步该方法废弃
- (id)performServiceWithSelectorName:(NSString *)selectorName inModuleName:(NSString *)moduleName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    NSParameterAssert(moduleName);
    NSParameterAssert(selectorName);
    id serviceReturnValue;
    FFModuleDescription *moduleDes = [self moduleDescriptionWithName:moduleName];
    FFModuleMethod *method = moduleDes.moduleMethods[selectorName];
    if (method) {
        serviceReturnValue = [method invokeWithParams:params callback:callback];
    }
    self.strongObject = nil;
    return serviceReturnValue;
}

- (id)performServiceWithName:(NSString *)serviceName inModuleName:(NSString *)moduleName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    NSParameterAssert(moduleName);
    NSParameterAssert(serviceName);
    id serviceReturnValue;
    FFModuleDescription *moduleDes = [self moduleDescriptionWithName:moduleName];
    FFModuleMethod *method = moduleDes.moduleMethods[serviceName];
    if (method) {
        serviceReturnValue = [method invokeWithParams:params callback:callback];
    }
    self.strongObject = nil;
    return serviceReturnValue;
}

//open module with param
- (id)openModuleWithName:(NSString *)moduleName withParams:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    if (!moduleName || moduleName.length==0) {
        return [FFCompomentRouterNotFoundViewController new];
    }
    id module;
    module = [self performServiceWithName:@"open" inModuleName:moduleName withParams:params callback:callback];
    return module!=nil ? module : [FFCompomentRouterNotFoundViewController new];
}

#pragma mark - URL调用
/**
 * url获取模块
 */
- (id)moduleWithUrl:(NSString *)url {
    id module;
    FFModuleURL *moduleUrl = [[FFModuleURL alloc] initWithString: url];
    if (url) {
        FFModuleDescription *moduleDes = [self moduleDescriptionWithName: [moduleUrl moduleName]];
        if (!moduleDes) {
            module = [FFCompomentRouterNotFoundViewController new];
        }
        if (!moduleDes.moduleClass) {
            module = [FFCompomentRouterNotFoundViewController new];
        }
        module = [[moduleDes.moduleClass alloc] init];
    }
    return module;
}

/**
* url调用方法-带参数
*/
- (id)performServiceWithUrl:(NSString *)url withParam:(NSDictionary *)param {
    id res;
    FFModuleURL *moduleUrl = [[FFModuleURL alloc] initWithString: url];
    if (moduleUrl) {
        res = [[FFCompomentRouter router] performServiceWithName:[moduleUrl moduleAction] inModuleName:[moduleUrl moduleName] withParams:param callback:nil];
    }
    return res;
}

#pragma mark - get module descripetion
- (FFModuleDescription *)moduleDescriptionWithName:(NSString *)name {
    if (!cache[name]) {
        return nil;
    }
    return cache[name];
}

#pragma mark - strong object method
- (void)setStrongTargetObject:(NSObject *)object {
    if (!object) {
        return;
    }
    self.strongObject = object;
}

#pragma mark - 是否开启配置初始化
- (void)setSDKsConfigEnble:(BOOL)configEnble {
    self.configEnble = configEnble;
}

//to do - shceme 注册

//to do - 路由安全验证模块

//to do - 路由缓存模块+LRU

@end
