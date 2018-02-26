//
//  HWNavController.m
//  美食街
//
//  Created by 黄炜 on 2018/1/17.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWNavController.h"


@interface HWNavController ()

@end

@implementation HWNavController

+(void)initialize{
    //拿到导航条标签
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    //设置项目所有导航栏背景图片
//    [navBar setBackgroundImage:[UIImage imageNamed:@"Nav_Bar"] forBarMetrics:UIBarMetricsDefault];
    //设置导航栏背景颜色
    navBar.backgroundColor = [UIColor colorWithRed:210.0 / 255.0 green:117.0 / 255.0 blue:28.0 / 255.0 alpha:1];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
}



@end
