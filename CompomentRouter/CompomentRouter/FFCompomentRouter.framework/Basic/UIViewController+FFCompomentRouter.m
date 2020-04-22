//
//  UIViewController+FFCompomentRouter.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "UIViewController+FFCompomentRouter.h"

#import "FFCompomentRouter.h"

@implementation UIViewController (FFCompomentRouter)

//present vc
- (BOOL)ff_presentModule:(NSString *)moduleName withParams:(NSDictionary *)params animated:(BOOL)animated completion:(void (^)(void))completion callback:(void(^)(NSDictionary *moduleInfo))callback {
    BOOL suc = NO;
    UIViewController *moduleVC = [[FFCompomentRouter router] openModuleWithName:moduleName withParams:params callback:nil];
    if ([moduleVC isKindOfClass:[UIViewController class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:moduleVC animated:animated completion:completion];
        });
        suc = YES;
        return suc;
    }
    return suc;
}

//open vc with url
- (BOOL)ff_displayUrl:(NSString *)moduleUrl animated:(BOOL)animated {
    BOOL suc = NO;
    id module = [[FFCompomentRouter router] moduleWithUrl:moduleUrl];
    [self.navigationController pushViewController:module animated:animated];
    return suc;
}

//open vc with url+param
- (BOOL)ff_displayUrl:(NSString *)moduleUrl animated:(BOOL)animated param:(NSDictionary *)params callback:(void(^)(NSDictionary *moduleInfo))callback {
    BOOL suc = NO;
    return suc;
}

@end
