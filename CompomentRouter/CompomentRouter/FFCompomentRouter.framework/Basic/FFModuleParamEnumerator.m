//
//  FFModuleParamEnumerator.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFModuleParamEnumerator.h"
@interface FFModuleParamEnumerator ()

@property (nonatomic, strong) NSMutableArray *params;
@property (nonatomic) NSInteger index;

@end

@implementation FFModuleParamEnumerator

- (instancetype)init {
    if (self = [super init]) {
        self.params = [NSMutableArray array];
    }
    return self;
}

- (FFModuleParam *)next {
    NSAssert(self.index < self.params.count, @"没有参数可以描述");
    FFModuleParam *param;
    if (self.index < self.params.count) {
        param = self.params[self.index];
        self.index++;
    }
    return param;
}

- (FFModuleParamEnumerator *)enumerate {
    self.index = 0;
    return self;
}

- (BOOL)end {
    return self.index == self.params.count;
}
@end
