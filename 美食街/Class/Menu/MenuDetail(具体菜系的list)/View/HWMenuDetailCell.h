//
//  HWChuanCaiCell.h
//  美食街
//
//  Created by Jerry Huang on 2018/1/19.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWMenuDetailItem.h"


@interface HWMenuDetailCell : UITableViewCell
/* item */
@property(strong,nonatomic)HWMenuDetailItem *item;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookingTimeLabel;
@end
