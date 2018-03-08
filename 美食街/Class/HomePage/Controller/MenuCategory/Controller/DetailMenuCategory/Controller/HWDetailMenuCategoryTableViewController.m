//
//  HWDetailMenuCategoryTableViewController.m
//  美食街
//
//  Created by 黄炜 on 2018/3/8.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWDetailMenuCategoryTableViewController.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import "HWMenuStyleOfCookingCell.h"
#import "HWMenuStyleOfCookingItem.h"
#import <SVProgressHUD.h>
#import "HWMenuDetailVC.h"
#import "HWMenuDetailItem.h"



static NSString * const ID = @"styleOfCookingCell";

@interface HWDetailMenuCategoryTableViewController ()
/* dataArr */
@property(strong,nonatomic)NSMutableArray *items;
/* mgr */
@property(strong,nonatomic)AFHTTPSessionManager *mgr;

@end

@implementation HWDetailMenuCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    self.tableView.backgroundColor = [UIColor grayColor];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HWMenuStyleOfCookingCell" bundle:nil] forCellReuseIdentifier:ID];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homePage"]];
    //    imageV.frame = self.view.frame;
    
    //    self.tableView.backgroundView = imageV;
    //    [self loadData];
    self.title = @"菜谱";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果数组里存在内容就返回不用每次显示菜谱view就loadData
    if (_items.count) return;
    [self loadDataWithClassid:_classid];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [SVProgressHUD dismiss];
    
    
}

-(void)setClassid:(NSString *)classid{
    _classid = classid;
    
    [self loadDataWithClassid:classid];
    
}

-(void)loadDataWithClassid:(NSString *)classid{
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //    _mgr = mgr;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"classid"] = classid;
    parameters[@"start"] = @"0";
    parameters[@"num"] = @"10";
    parameters[@"appkey"] = APPKEY;
    
    //显示hud
    [SVProgressHUD showWithStatus:@"正在为您加载菜谱..."];
    
    
    
    [mgr GET:@"https://way.jd.com/jisuapi/byclass" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //如果数据不能获得到,那么再次发送请求获取数据
        //        if (!self.items.count) {
        //            [self loadDataWithClassid:_classid];
        //        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //字典数组
        NSArray *arr = responseObject[@"result"][@"result"][@"list"];
        //字典数组转模型数组
        self.items = [HWMenuDetailItem mj_objectArrayWithKeyValuesArray:arr];
        HWMenuDetailItem *item = self.items[0];
        
        [responseObject writeToFile:@"/Users/huangwei/Desktop/categoryDetail.plist" atomically:YES];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        if (!self.items.count) {
        [self loadDataWithClassid:_classid];
        //        }
        [SVProgressHUD dismiss];
        
    }];
    
    
}

-(NSMutableArray *)dataArr{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}



-(void)loadData{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //    _mgr = mgr;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //    parameters[@"menu"] = @"白菜";
    parameters[@"appkey"] = APPKEY;
    
    //显示hud
    [SVProgressHUD showWithStatus:@"正在为您加载菜谱..."];
    
    
    //添加门板在window上
    //    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //    UIView *v = [UIView new];
    //    v.frame = window.frame;
    //    v.backgroundColor = XMGColor(66, 66, 66);
    //    self.v = v;
    //    [window addSubview:v];
    
    
    
    [mgr GET:@"https://way.jd.com/jisuapi/recipe_class" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //如果数据不能获得到,那么再次发送请求获取数据
        if (!self.items.count) {
            [self loadData];
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        /* 收费接口
         NSDictionary *dict = responseObject[@"result"];
         NSArray *dataArr = dict[@"result"];
         dataArr = dataArr[4][@"list"];
         _items = [HWMenuStyleOfCookingItem mj_objectArrayWithKeyValuesArray:dataArr];
         //将获取到的菜系数据保存入数组
         
         [SVProgressHUD dismiss];
         [self.tableView reloadData];
         */
        
        //免费接口
        //获取菜系的数据列表
        NSMutableArray *dataArr = responseObject[@"result"][@"result"][4][@"list"];
        
        //模型数组
        _items = [HWMenuStyleOfCookingItem mj_objectArrayWithKeyValuesArray:dataArr];
        
        [_items removeObjectsInRange:NSMakeRange(33, 11)];
        [_items removeObjectAtIndex:28];
        [_items removeObjectAtIndex:29];
        
        [SVProgressHUD dismiss];
        
        //            [self.v removeFromSuperview];
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!self.items.count) {
            [self loadData];
        }
        [SVProgressHUD dismiss];
        
    }];
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HWMenuStyleOfCookingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    HWMenuStyleOfCookingItem *item = self.dataArr[indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}

//点击菜谱控制器中的cell来到这里
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HWMenuDetailVC *vc = [HWMenuDetailVC new];
    vc.hidesBottomBarWhenPushed = YES;
    //当点击Menu控制器具体哪一行时会来到这里\
    根据具体点击的行数来判断创建的模型
    //    HWMenuStyleOfCookingItem *item = self.items[indexPath.row];
    
    //self.items为模型数组, 取出指定行的模型赋值给控制器的模型dataItems
    vc.dataItems = self.items[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

@end
