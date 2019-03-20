//
//  tabbarViewController.m
//  zdsApp
//
//  Created by 汉德 on 2017/2/15.
//  Copyright © 2017年 中电四公司. All rights reserved.
//

#import "TabbarViewController.h"
#import "Common.h"

@interface TabbarViewController ()
{
    int selectedBar;
    UITabBarItem *indexItem;
    UITabBarItem *resourceItem;
    UITabBarItem *mineItem;
    
}

@property (strong,nonatomic) UILabel *lab;
@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //如果为1 为管理员身份 多显示一个tabbar
//    if([ISADMIN isEqualToString:@"1"]){
//        [self addAllChildViewController];
//    }
    
    
    NSArray *items = self.tabBar.items;
    indexItem = items[0];
    indexItem.tag = 1;
    resourceItem = items[1];
    resourceItem.tag = 2;
    mineItem = items[2];
    mineItem.tag = 3;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTabBadgeHomeItem:) name:@"setTabHomeItemBadge" object:nil];
}

//增加一个或多个tabbar
//- (void)addAllChildViewController {
//    AdminIndexViewController *vc = [[AdminIndexViewController alloc] init];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    [self addChildViewController:vc title:@"管理" imageNamed:@"tabBar_home"];
//}

// 添加某个 childViewController
- (void)addChildViewController:(UIViewController *)vc title:(NSString *)title imageNamed:(NSString *)imageNamed {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:imageNamed];
    
    [self addChildViewController:nav];
}



- (void)setTabBadgeHomeItem:(NSNotification *)notification {
    
    NSString *strBadge = [[notification userInfo] objectForKey:@"badge"];
    if ([strBadge isEqualToString:@"0"]) {
        mineItem.badgeValue = nil;
    }else{
        mineItem.badgeValue = strBadge;
//        persionItem.badgeColor = [UIColor redColor];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)dealloc {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
