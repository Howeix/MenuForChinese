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
    
    UINib *nib = [UINib nibWithNibName:@"HWMenuDetailCell" bundle:nil];
    
    //注册cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"chuancaicell"];
    
    
    [self.tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}

/*
 @property (weak, nonatomic) IBOutlet UIImageView *iconView;
 @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
 @property (weak, nonatomic) IBOutlet UILabel *cookingTimeLabel;
 
 */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWMenuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chuancaicell"];
    HWMenuDetailItem *item = self.items[indexPath.row];
    
    NSLog(@"%zd --- %p",indexPath.row,cell);
    cell.nameLabel.text = item.name;
    cell.cookingTimeLabel.text = item.cookingtime;
    cell.iconView.image = [UIImage imageNamed:item.pic];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
