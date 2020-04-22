//
//  FFTestModuleViewController.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFTestModuleViewController.h"
#import <FFCompomentRouter/FFCompomentRouterHeader.h>

@interface FFTestModuleViewController ()<FFServiceProtocol>

@end

@implementation FFTestModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor yellowColor];
}

+ (void)moduleDescription:(FFModuleDescription *)description {
    description
    .name(@"TestVC")
    .method(^(FFModuleMethod *method){
        method
        .name(@"testMethod")
        .selector(@selector(testMethod))
        .parameters(^(FFModuleParamEnumerator *enumerator){

        })
        .resultType(FFModuleParamTypeEmpty);
    })
    .method(^(FFModuleMethod *method){
        method
        .name(@"testMethodWithParam")
        .selector(@selector(testMethodWithParam:withString:))
        .parameters(^(FFModuleParamEnumerator *enumerator){
            enumerator.next.name(@"param").type(FFModuleParamTypeMap);
            enumerator.next.name(@"string").type(FFModuleParamTypeString);
        })
        .resultType(FFModuleParamTypeEmpty);
    })
    .method(^(FFModuleMethod *method){
        method
        .name(@"testMethodWithBlock")
        .selector(@selector(testMethodWithParam:withBlock:))
        .parameters(^(FFModuleParamEnumerator *enumerator){
            enumerator.next.name(@"param").type(FFModuleParamTypeMap);
            enumerator.next.name(@"block").type(FFModuleParamTypeBlock);
        })
        .resultType(FFModuleParamTypeEmpty);
    })
    .method(^(FFModuleMethod *method){
        method
        .name(@"open")
        .selector(@selector(open:callback:))
        .classMethod(NO)
        .parameters(^(FFModuleParamEnumerator *enumerator){
            enumerator.next.name(@"param").type(FFModuleParamTypeMap);
            enumerator.next.name(@"callback").type(FFModuleParamTypeBlock);
        })
        .resultType(FFModuleParamTypeObject)
        ;
    })
    .method(^(FFModuleMethod *method){
        method
        .name(@"testMethodBoolReturn")
        .selector(@selector(testMethodBoolReturn:))
        .classMethod(NO)
        .parameters(^(FFModuleParamEnumerator *enumerator){
            enumerator.next.name(@"str").type(FFModuleParamTypeString);
        })
        .resultType(FFModuleParamTypeBool)
        ;
    })
    .method(^(FFModuleMethod *method){
        method
        .name(@"testMethodWithBool")
        .selector(@selector(testMethodWithBool:))
        .classMethod(NO)
        .parameters(^(FFModuleParamEnumerator *enumerator){
            enumerator.next.name(@"boolValue").type(FFModuleParamTypeBool);
        })
        .resultType(FFModuleParamTypeBool)
        ;
    })
    ;
}

//method
- (id)open:(NSDictionary *)params callback:(void (^)(NSDictionary *))callback {
    return self;
}

- (void)testMethod {
    NSLog(@"类名：%@, 方法名：testMethod", NSStringFromClass([self class]));
}

- (void)testMethodWithParam:(NSDictionary *)param withString:(NSString *)string{
    NSLog(@"param:%@", param);
    NSLog(@"string:%@", string);
}

- (void)testMethodWithParam:(NSDictionary *)param withBlock:(void (^)(NSDictionary * moduleInfo))block {
    block(param);
}

- (BOOL)testMethodBoolReturn:(NSString *)str {
    return YES;
}

- (void)testMethodWithBool:(BOOL)boolValue {
    if (boolValue == YES) {
        NSLog(@"YES");
    }else {
        NSLog(@"NO");
    }
}

@end

