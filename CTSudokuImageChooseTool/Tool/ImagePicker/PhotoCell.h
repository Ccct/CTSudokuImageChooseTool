//
//  PhotoCell.h
//  XO
//
//  Created by 白月光 on 2018/12/6.
//  Copyright © 2018 深圳市XO科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger,PhotoCellType){
    PhotoCellType_add = 0, //添加模式
    PhotoCellType_Image = 1 //展示图片
};

@interface PhotoCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *photoImageView;
@property (nonatomic,strong) UIButton *deleteBtn;
@property (nonatomic,assign) PhotoCellType cellType;

- (void)configDataWithType:(PhotoCellType)type WithImage:(nullable UIImage*)image WithUrl:(nullable NSString*)url;

@end

NS_ASSUME_NONNULL_END
