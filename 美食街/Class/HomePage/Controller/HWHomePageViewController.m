//
//  HWHomePageViewController.m
//  美食街
//
//  Created by Jerry Huang on 2018/3/7.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWHomePageViewController.h"
#import "HWMenuDetailItem.h"
#import <MJExtension.h>
#import <AFNetworking.h>
#import <SVProgressHUD.h>

@interface HWHomePageViewController ()

@property(strong,nonatomic)NSArray *items;
@property(weak,nonatomic)UIScrollView *scrollView;
@end

@implementation HWHomePageViewController

-(NSArray *)items{
    if (!_items) {
        _items = [NSArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGrayView];
    //添加一个scrollView
    [self setupScrollView];
    //发送请求 获取数据
    [self loadData];
    
    //在scrollview中添加button 11个
    [self setupCategoryButton];
    
}

-(void)setupCategoryButton{
    CGFloat buttonCenterX = self.view.center.x;
    CGFloat buttonW = HWScreenW;
    CGFloat buttonH = self.scrollView.contentSize.height / self.items.count;
    int i = 0;
    for (NSDictionary *dict in self.items) {
        CGFloat buttonY = buttonH * i;
        //创建button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonCenterX, buttonY, buttonW, buttonH);
        button.backgroundColor = HWRandomColor;
        [self.scrollView addSubview:button];
        i++;
    }
}

-(void)loadData{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
//                                 @"classid" : classid,
//                                 @"start" : @"0",
//                                 @"num" : @"20",
                                 @"appkey" : APPKEY
                                 };
    //显示hud
//    [SVProgressHUD showWithStatus:@"正在帮你加载菜系,请稍后..."];
    
    
    [mgr GET:@"https://way.jd.com/jisuapi/recipe_class" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        [responseObject writeToFile:@"/Users/jerryhuang/Desktop/home.plist" atomically:YES];
        //字典数组
        self.items = responseObject[@"result"][@"result"];
        
        
        //通过指定的classid请求到相对应的菜系菜谱数据(比如:川菜 -> 20个菜谱字典)数组,然后把字典数组转换成模型数组赋值给items数组保存起来
//        self.items = [HWMenuDetailItem mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"result"][@"list"]];
//        [self.tableView reloadData];
        
//        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!self.items.count) {
            [self loadData];
        }
//        [SVProgressHUD dismiss];
    }];
    
}

-(void)setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 64, HWScreenW, HWScreenH - (64 + 49));
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(HWScreenW, 2000);
    
}

-(void)setupGrayView{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homePage"]];
    imageV.frame = self.view.frame;
    [self.view addSubview:imageV];
    self.title = @"首页";
    //    self.tableView.scrollEnabled = NO;
    //    self.tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加一层半透明的view在tableview之上
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:view];
    
}


@end
