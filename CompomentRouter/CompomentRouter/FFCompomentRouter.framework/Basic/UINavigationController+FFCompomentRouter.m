//
//  UINavigationController+FFCompomentRouter.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "UINavigationController+FFCompomentRouter.h"
#import "FFCompomentRouter.h"
#import "FFCompomentRouterNotFoundViewController.h"

@implementation UINavigationController (FFCompomentRouter)

//push to vc
- (BOOL)ff_pushModule:(NSString *)moduleName animated:(BOOL)animated {
    UIViewController *moduleVC = [[FFCompomentRouter router] moduleWithName: moduleName];
    if ([moduleVC isKindOfClass:[UIViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushViewController:moduleVC animated:animated];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushViewController:[FFCompomentRouterNotFoundViewController new] animated:animated];
        });
    }
    return YES;
}

//push to vc with param
- (BOOL)ff_pushModule:(NSString *)moduleName withParams:(NSDictionary *)params animated:(BOOL)animated callback:(void(^)(NSDictionary *moduleInfo))callback {
    UIViewController *moduleVC = [[FFCompomentRouter router] openModuleWithName:moduleName withParams:params callback:nil];
    if ([moduleVC isKindOfClass:[UIViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushViewController:moduleVC animated:animated];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushViewController:[FFCompomentRouterNotFoundViewController new] animated:animated];
        });
    }
    return YES;
}

@end
