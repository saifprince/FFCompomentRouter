//
//  FFModuleParam.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFModuleParam.h"

@interface FFModuleParam ()

@property (nonatomic, copy) NSString *paramName;

@property (nonatomic) FFModuleParamType paramType;

@property (nonatomic) BOOL isStrict;
@end

@implementation FFModuleParam

- (instancetype)init {
    if (self = [super init]) {
        self.paramName = @"";
        self.paramType = FFModuleParamTypeUnknown;
        self.isStrict = NO;
    }
    return self;
}
#pragma mark - 参数描述

- (FFModuleParam * _Nonnull (^)(BOOL))strict {
    return ^FFModuleParam *(BOOL isStrict) {
        self.isStrict = isStrict;
        return self;
    };
}

- (FFModuleParam *)strict:(BOOL)isStrict {
    return self.strict(isStrict);
}

- (FFModuleParam *(^)(NSString *))name {
    return ^FFModuleParam *(NSString *name) {
        NSParameterAssert(name);
        self.paramName = name;
        return self;
    };
}

- (FFModuleParam *)name:(NSString *)name {
    return self.name(name);
}

- (FFModuleParam *(^)(FFModuleParamType))type {
    return ^FFModuleParam *(FFModuleParamType type) {
        self.paramType = type;
        return self;
    };
}

- (FFModuleParam *)type:(FFModuleParamType)type {
    return self.type(type);
}

#pragma mark - 参数描述

- (NSString *)description {
    NSString *des = [NSString stringWithFormat:@"%@:%@", self.paramName, [self.class typeDescription:self.paramType]];
    return des;
}

+ (NSString *)typeDescription:(FFModuleParamType)type {
    NSString *des = @"";
    switch (type) {
        case FFModuleParamTypeString:
            des = @"String";
            break;
        case FFModuleParamTypeNumber:
            des = @"Number";
            break;
        case FFModuleParamTypeBlock:
            des = @"Block";
            break;
        case FFModuleParamTypeObject:
            des = @"Object";
            break;
        case FFModuleParamTypeUnknown:
            des = @"Unknown";
            break;
        case FFModuleParamTypeMap:
            des = @"Map";
            break;
        case FFModuleParamTypeArray:
            des = @"Array";
            break;
        case FFModuleParamTypeEmpty:
            des = @"Empty";
            break;
        case FFModuleParamTypeBool:
            des = @"BOOL";
            break;
    }
    return des;
}

- (NSDictionary *)jsonDescription {
    NSDictionary *jsonDic = @{@"paramName": self.paramName,
                              @"paramType": [self.class typeDescription:self.paramType]};
    return jsonDic;
}
@end
