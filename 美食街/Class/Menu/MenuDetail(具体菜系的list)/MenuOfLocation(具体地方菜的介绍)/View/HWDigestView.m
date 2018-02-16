//
//  HWDigestView.m
//  美食街
//
//  Created by Jerry Huang on 2018/2/7.
//  Copyright © 2018年 黄炜. All rights reserved.
//

#import "HWDigestView.h"
#import "HWMenuDetailItem.h"


@interface HWDigestView()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cookingtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *preparetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end



@implementation HWDigestView


-(void)setItem:(HWMenuDetailItem *)item{
    _item = item;
    self.nameLabel.text = [NSString stringWithFormat:@"菜名:%@",_item.name];
    self.cookingtimeLabel.text = [NSString stringWithFormat:@"烹制时间约:%@",_item.cookingtime];
    self.preparetimeLabel.text = [NSString stringWithFormat:@"准备时间约:%@",_item.preparetime];
    self.tagLabel.text = [NSString stringWithFormat:@"小贴士🥢:%@",_item.tag];
    
}




@end
