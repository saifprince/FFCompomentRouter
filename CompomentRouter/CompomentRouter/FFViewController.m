//
//  FFViewController.m
//  CompomentRouter
//
//  Created by whc on 2020/4/22.
//  Copyright © 2020 whc. All rights reserved.
//

#import "FFViewController.h"
#import <FFCompomentRouter/FFCompomentRouterHeader.h>

@interface FFViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titles;

@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSStringFromClass([self class]);
    self.titles = @[
                    @"页面push跳转",
                    @"Native跨类方法调用（无参数）",
                    @"Native跨类方法调用（有参数）",
                    @"Native跨类调用方法并回调",
                    @"无效跳转页面",
                    @"BOOL返回值",
                    @"BOOL传参调用",
                    @"获取无效模块",
                    @"url获取模块",
                    @"url跳转"
                    ];
    [self.view addSubview: self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.textLabel.text = self.titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //[self.navigationController ff_pushModule:@"TestVC" withParams:@{} animated:YES callback:nil];
        [self.navigationController ff_pushModule:@"TestVC" animated:YES];
    }else if(indexPath.row == 1) {
        NSDictionary *param = [[NSDictionary alloc] init];
        [[FFCompomentRouter router] performServiceWithName:@"testMethod" inModuleName:@"TestVC" withParams:param callback:nil];
    }else if (indexPath.row == 2) {
        NSDictionary *param = @{
                                @"param":@{@"key":@"value"},
                                @"string":@"test string"
                                };
        [[FFCompomentRouter router] performServiceWithName:@"testMethodWithParam" inModuleName:@"TestVC" withParams:param callback:^(NSDictionary *moduleInfo) {
            
        }];
    }else if (indexPath.row == 3) {
        NSDictionary *param = @{
                                @"param":@{@"key":@"value"},
                                @"string":@"test string"
                                };
        [[FFCompomentRouter router] performServiceWithName:@"testMethodWithBlock" inModuleName:@"TestVC" withParams:param callback:^(NSDictionary *moduleInfo) {
            NSLog(@"block:%@", moduleInfo);
        }];
    }else if (indexPath.row == 4) {
        [self.navigationController ff_pushModule:@"XXX" withParams:@{} animated:YES callback:^(NSDictionary * _Nonnull moduleInfo) {
            
        }];
    }else if (indexPath.row == 5) {
        BOOL boolValue = [[FFCompomentRouter router] performServiceWithName:@"testMethodBoolReturn" inModuleName:@"TestVC" withParams:@{@"str": @"123"} callback:nil];
        if (boolValue == YES) {
            NSLog(@"YES");
        }
    }else if (indexPath.row == 6) {
        [[FFCompomentRouter router] performServiceWithName:@"testMethodWithBool" inModuleName:@"TestVC" withParams:@{@"boolValue": [NSNumber numberWithBool:YES]} callback:nil];
    }else if (indexPath.row == 7) {
        id module = [[FFCompomentRouter router] performServiceWithName:@"XXX" inModuleName:@"XXX" withParams:@{} callback:nil];
        NSLog(@"%@", module);
    }else if (indexPath.row == 8) {
        id module = [[FFCompomentRouter router] moduleWithUrl:@"xxx://TestVC"];
        NSLog(@"%@", module);
    }else if (indexPath.row == 9) {
        [self ff_displayUrl:@"xxx://TestVC" animated:YES];
    }
    [[FFCompomentRouter router] setStrongTargetObject: self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
