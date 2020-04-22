//
//  FFModuleURL.h
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFModuleURL : NSURL

- (NSString *)moduleName;

- (NSString *)moduleAction;

@end

NS_ASSUME_NONNULL_END
