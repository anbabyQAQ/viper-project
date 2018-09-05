//
//  TYLBaseViewController.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLBaseViewController.h"

#import "TYLBaseEventHandler.h"
#import "TYLBaseViewDataSource.h"

@interface TYLBaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<TYLBaseEventHandler> eventHandler;
@property (nonatomic, weak) id<TYLBaseViewDataSource> dataSource;


/**
 设置导航栏
 标题和图片的方式任选其一  标题优先
 
 @param title 导航栏标题
 @param image 导航栏图标
 */
- (void)titleViewWithTitle:(NSString *)title image:(NSString *)image;

@end

@implementation TYLBaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshNavBarStyle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self registerNotifications];
    [self customRAC];
}

#pragma mark -
#pragma mark - 注册通知
- (void)registerNotifications {
    @weakify(self);
    // 登录状态改变RAC
    [[NSNotificationCenter defaultCenter] onLoginStatusChange:^{
        @strongify(self);
        if (self && [self respondsToSelector:@selector(loginStatusChanged)]) {
            [self loginStatusChanged];
        }
    }];
    
    // 多点登录
    // 多点登录
    [[NSNotificationCenter defaultCenter] onMultilogin:^{
        @strongify(self);
        if (self) {
            if (self.eventHandler && [self.eventHandler respondsToSelector:@selector(handleMultilogin)]) {
                [self.eventHandler handleMultilogin];
            }
            if ([self respondsToSelector:@selector(multiLoggedIn)]) {
                [self multiLoggedIn];
            }
        }
    }];
}

/**
 页面自适应 -主要针对键盘弹出与消失
 */
- (void)customRAC {
    UITapGestureRecognizer * keyboardTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidChange:)];
    keyboardTapGestureRecognizer.cancelsTouchesInView = NO;
    keyboardTapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:keyboardTapGestureRecognizer];
}

#pragma mark -
#pragma mark - 键盘手势相关的
- (void)tapGestureDidChange:(UITapGestureRecognizer *)tap {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TYLViewControllerStyleProtocol
- (NSString *)preferredNavBarTitle {
    return @"sohunews";
}

- (NSString *)preferredNavBarTitleImageName {
    return nil;
}

- (BOOL)preferredNavBarBackHidden {
    return NO;
}

- (BOOL)preferredNavBarHidden {
    return NO;
}

- (TYLNavBarHiddenAnimation)preferredNavBarHiddenAnimation {
    UIViewController *vc = self.parentViewController;
    if (vc && [vc isKindOfClass:NSClassFromString(@"NPTabBarViewController")]) {
        return [vc.currentURL.host isEqualToString:vc.lastURL.host];
    }
    return eTYLNavBarHiddenAnimationAutomatic;
}

- (void)refreshNavBarStyle {
    // 标题
    [self titleViewWithTitle:[self preferredNavBarTitle] image:[self preferredNavBarTitleImageName]];
    
    // 返回按钮
    if ([self preferredNavBarBackHidden]) {
        self.navigationItem.leftBarButtonItems = nil;
    } else {
        [self leftBarButtomItemWithImage:@"icon_nav_back" selector:NSSelectorFromString(@"goBack") target:self];
    }
    
    // 隐藏
    [self.navigationController setNavigationBarHidden:[self preferredNavBarHidden] animated:[self preferredNavBarHiddenAnimation] != eTYLNavBarHiddenAnimationNone];
    
    // 更新父VC
    [self refreshParentViewController];
}

- (void)refreshParentViewController {
    if ([self.parentViewController isKindOfClass:NSClassFromString(@"NPTabBarViewController")]) {
        if (self.navigationItem.title && [self.navigationItem.title length] > 0) {
            self.parentViewController.navigationItem.title = self.navigationItem.title;
        } else {
            self.parentViewController.navigationItem.titleView = self.navigationItem.titleView;
        }
        self.parentViewController.navigationItem.leftBarButtonItems = self.navigationItem.leftBarButtonItems;
        self.parentViewController.navigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems;
    }
}

#pragma mark - TYLViewControllerBusinessProtocol
- (BOOL)listenLoginStatus {
    return NO;
}

- (BOOL)listenMultiogin {
    return YES;
}

- (BOOL)needLogin {
    return YES;
}

- (BOOL)hasLoggedIn {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hasLoggedIn)]) {
        return [self.dataSource hasLoggedIn];
    }
    return NO;
}

- (TYLViewControllerLogBackStyle)logBackStyle {
    return TYLViewControllerLogBackStyleTop;
}

#pragma mark - Dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

@end
