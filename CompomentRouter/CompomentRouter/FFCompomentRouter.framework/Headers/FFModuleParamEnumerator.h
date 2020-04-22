//
//  FFModuleParamEnumerator.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFModuleParam.h"


NS_ASSUME_NONNULL_BEGIN

@interface FFModuleParamEnumerator : NSObject
@property (nonatomic, strong, readonly) NSMutableArray *params;

- (FFModuleParam *)next;

- (FFModuleParamEnumerator *)enumerate;

- (BOOL)end;

@end

NS_ASSUME_NONNULL_END
