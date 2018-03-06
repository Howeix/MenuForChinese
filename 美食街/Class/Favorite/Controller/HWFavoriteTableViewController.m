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
#import "HWMenuOfLocationViewController.h"
#import <UIImageView+WebCache.h>

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
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.allowsSelection = NO;
    //从data.plist 中获取数组保存到当前控制器的items数组中
//    self.items = [[NSMutableArray alloc] initWithContentsOfFile:dataFullPathFromCaches];
    
    // 'mj_objectArrayWithFile' 方法可以传入一个 .plist 的全路径,并返回一个模型数组
    self.items = [HWMenuDetailItem mj_objectArrayWithFile:dataFullPathFromCaches];
    
    
    UINib *nib = [UINib nibWithNibName:@"HWMenuDetailCell" bundle:nil];
    
    //注册cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"chuancaicell"];
    
    
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_items.count) {
        UIView *v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        UILabel *l = [[UILabel alloc] init];
        l.HW_Width = 200;
        l.HW_Height = 200;
        
        l.text = @"空空如也~~~";
        l.center = v.center;
        [v addSubview:l];
        [self.tableView addSubview:v];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    
    // 'mj_objectArrayWithFile' 方法可以传入一个 .plist 的全路径,并返回一个模型数组
    self.items = [HWMenuDetailItem mj_objectArrayWithFile:dataFullPathFromCaches];
    [self.tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:YES animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除?" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//修改编辑按钮文字
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//设置进入编辑状态时,cell不会缩进
-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

/*
 @property (weak, nonatomic) IBOutlet UIImageView *iconView;
 @property (weak, nonatomic) IBOutlet UILabel *nameLabel;
 @property (weak, nonatomic) IBOutlet UILabel *tagLabel;
 
 */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWMenuDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chuancaicell"];
    HWMenuDetailItem *item = self.items[indexPath.row];
    
    NSLog(@"%zd --- %p",indexPath.row,cell);
    cell.nameLabel.text = item.name;
    cell.tagLabel.text = item.tag;
//    cell.iconView.image = [UIImage imageNamed:item.pic];
    [cell.iconView sd_setImageWithURL:[NSURL URLWithString:item.pic]];
    return cell;
}

//点击具体一行创建
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([HWMenuOfLocationViewController class]) bundle:nil];
    HWMenuOfLocationViewController *locationMenuVC = [storyboard instantiateInitialViewController];
    
    //从这里把数据传进去
    
    locationMenuVC.item = self.items[indexPath.row];
    locationMenuVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:locationMenuVC animated:YES];
    
}


@end
