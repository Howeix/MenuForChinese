//
//  HWDetailMenuCategoryViewController.m
//  美食街
//
//  Created by 黄炜 on 2018/3/8.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWDetailMenuCategoryViewController.h"
#import <SVProgressHUD.h>
#import <AFNetworking.h>
#import "HWMenuDetailItem.h"
#import "HWMenuDetailCell.h"
#import "HWMenuOfLocationViewController.h"
#import <MJExtension.h>

static NSString * const ID = @"chuancaicell";

@interface HWDetailMenuCategoryViewController ()
/* 数据 */
@property(strong,nonatomic)NSArray *items;

@end

@implementation HWDetailMenuCategoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = [NSString stringWithFormat:@"%@菜谱",self.dataItems.name];
    //注册川菜cell
    [self.tableView registerNib:[UINib nibWithNibName:@"HWMenuDetailCell" bundle:nil] forCellReuseIdentifier:ID];
    //    [self loadData];
}

-(NSArray *)items{
    if (!_items) {
        _items = [NSArray array];
    }
    return _items;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (!_items.count) {
        [self loadDataWithClassID:self.classid];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

-(void)loadDataWithClassID:(NSString *)classid{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"classid" : classid,
                                 @"start" : @"0",
                                 @"num" : @"10",
                                 @"appkey" : APPKEY
                                 };
    //显示hud
    [SVProgressHUD showWithStatus:@"正在帮你加载菜系,请稍后..."];
    
    
    [mgr GET:@"https://way.jd.com/jisuapi/byclass" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //通过指定的classid请求到相对应的菜系菜谱数据(比如:川菜 -> 20个菜谱字典)数组,然后把字典数组转换成模型数组赋值给items数组保存起来
        ;
        
#warning TD:注意这里如果 responseObject[@"result"][@"result"] 返回为空的话要规避掉
        if ([responseObject[@"result"][@"msg"] isEqualToString:@"没有信息"]) {
            [SVProgressHUD showErrorWithStatus:@"出问题了!!!"];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        self.items = [HWMenuDetailItem mj_objectArrayWithKeyValuesArray:responseObject[@"result"][@"result"][@"list"]];
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (!self.items.count) {
            [self loadDataWithClassID:classid];
        }
        [SVProgressHUD dismiss];
    }];
}

//当点击Menu控制器的具体一个cell后,给MenuDetail控制器的模型赋值,然后来到这里
//- (void)setDataItems:(HWMenuStyleOfCookingItem *)dataItems{
//    _dataItems = dataItems;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HWMenuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    HWMenuDetailItem *item = self.items[indexPath.row];
    cell.item = item;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([HWMenuOfLocationViewController class]) bundle:nil];
    HWMenuOfLocationViewController *locationMenuVC = [storyboard instantiateInitialViewController];
    
    //从这里把数据传进去
    
    locationMenuVC.item = self.items[indexPath.row];
    
    [self.navigationController pushViewController:locationMenuVC animated:YES];
}
@end
