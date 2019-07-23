//
//  PhotoCell.m
//  XO
//
//  Created by 白月光 on 2018/12/6.
//  Copyright © 2018 深圳市XO科技有限公司. All rights reserved.
//

#import "PhotoCell.h"
#import "UIView+Extension.h"

@implementation PhotoCell

- (id)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.photoImageView];
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (UIImageView*)photoImageView{
    if (!_photoImageView) {
         _photoImageView =[[UIImageView alloc]init];
         _photoImageView.frame = CGRectMake(0, 0, self.frameWidth, self.frameHeight);
//         _photoImageView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
    return _photoImageView;
}

- (UIButton*)deleteBtn
{
    if (!_deleteBtn)
    {
         _deleteBtn =[UIButton buttonWithType:UIButtonTypeCustom];
         _deleteBtn.frame = CGRectMake(self.frameWidth-18, 3, 15, 15);
        [_deleteBtn setImage:[UIImage imageNamed:@"delete_icon_"] forState:0];
    }
    return _deleteBtn;
}

- (void)configDataWithType:(PhotoCellType)type WithImage:(nullable UIImage*)image WithUrl:(nullable NSString*)url;
{
    self.cellType = type;
    
    if (type == PhotoCellType_add ) {
        self.photoImageView.image = [UIImage imageNamed:@"add_photo"];
        self.deleteBtn.hidden = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        if (image) {
            self.photoImageView.image = image;
        }
        self.deleteBtn.hidden = NO;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.layer.masksToBounds = YES;
    }
}



@end
