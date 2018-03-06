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
    
    //允许在编辑状态下多选
    self.tableView.allowsSelectionDuringEditing = YES;
    
    UINib *nib = [UINib nibWithNibName:@"HWMenuDetailCell" bundle:nil];
    
    //注册cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"chuancaicell"];
    
    //设置导航栏右侧按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickRightButton) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    [self.tableView reloadData];
    
}

-(void)clickRightButton{
    //如果是在编辑状态
    if (self.tableView.isEditing) {
        [self.tableView beginUpdates];
        NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
        NSMutableIndexSet *indexPaths = [[NSMutableIndexSet alloc] init];
        for (NSIndexPath *path in selectRows) {
            [indexPaths addIndex:path.row];
        }
        [self.items removeObjectsAtIndexes:indexPaths];
        [self.tableView deleteRowsAtIndexPaths:selectRows withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        [self.tableView setEditing:NO animated:YES];
    }else{
        [self.tableView setEditing:YES animated:YES];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 'mj_objectArrayWithFile' 方法可以传入一个 .plist 的全路径,并返回一个模型数组
    self.items = [HWMenuDetailItem mj_objectArrayWithFile:dataFullPathFromCaches];
    [self.tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//先要设Cell可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#warning TODO: 需要添加多选cell, 然后一起删除的功能
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
        //在这里从 data.plist中删除指定项
        //如果是取消星星的话就从data.plist中删除item
        NSMutableArray *arr = [[NSMutableArray alloc] initWithContentsOfFile:dataFullPathFromCaches];
        HWMenuDetailItem *item = self.items[indexPath.row];
        for (NSDictionary *dict in arr) {
            if ([dict[@"pic"] isEqualToString:item.pic]) {
                [arr removeObject:dict];
                [self.items removeObjectAtIndex:indexPath.row];
                [arr writeToFile:dataFullPathFromCaches atomically:YES];
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
                return;
            }
        
        }
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
