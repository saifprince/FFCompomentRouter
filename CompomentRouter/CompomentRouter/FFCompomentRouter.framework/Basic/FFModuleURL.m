//
//  FFModuleURL.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFModuleURL.h"

@interface FFModuleURL()

@property (nonatomic, copy) NSString *module_scheme;
@property (nonatomic, copy) NSString *module_action;
@property (nonatomic, strong) NSDictionary *module_param;
@property (nonatomic, copy) NSString *module_name;
@property (nonatomic, copy) NSString *module_method;

@end

@implementation FFModuleURL


- (instancetype)initWithString:(NSString *)URLString {
    if (!URLString) {
        return nil;
    }
    if (self = [super initWithString:URLString]) {
        self.module_scheme = [self scheme];
        //module name
        self.module_name = [self host];
        //module action
        self.module_action = [self pathComponents].lastObject;
    }
    return self;
}

- (NSString *)moduleName {
    return self.module_name;
}

- (NSString *)moduleAction {
    return self.module_action;
}



@end
