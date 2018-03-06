//
//  HWFavoriteTableViewController.m
//  美食街
//
//  Created by 黄炜 on 2018/3/6.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWFavoriteTableViewController.h"
#import <MJExtension.h>
#import "HWMenuDetailItem.h"
#import "HWMenuDetailCell.h"
@interface HWFavoriteTableViewController ()
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation HWFavoriteTableViewController

-(NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏";
    
    //从data.plist 中获取数组保存到当前控制器的items数组中
//    self.items = [[NSMutableArray alloc] initWithContentsOfFile:dataFullPathFromCaches];
    
    
    // 'mj_objectArrayWithFile' 方法可以传入一个 .plist 的全路径,并返回一个模型数组
    self.items = [HWMenuDetailItem mj_objectArrayWithFile:dataFullPathFromCaches];
    
    //注册cell
    [self.tableView registerClass:[HWMenuDetailCell class] forCellReuseIdentifier:@"chuancaicell"];
    
    
    [self.tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWMenuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chuancaicell"];
    
    
    return cell;
}



@end
