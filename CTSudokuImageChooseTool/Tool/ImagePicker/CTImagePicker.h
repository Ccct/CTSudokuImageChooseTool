//
//  ImagePicker.h
//
//  Created by 白月光 on 2018/12/6.

#import <Foundation/Foundation.h>
#import "UIView+Extension.h"

NS_ASSUME_NONNULL_BEGIN


@interface CTImagePicker : UIView

@property (nonatomic,strong) NSMutableArray *imageArr;  //当前图片列表

@property (nonatomic,strong) NSMutableArray *deleteArr; //删除的图片

@property (nonatomic,assign) NSUInteger maxSelect;      //最多能选择多少

@property (nonatomic,assign) NSUInteger rowCount;       //每行有多少个

@property (nonatomic,strong) void(^reloadHeight)(CGFloat);

//刷新展示
- (void)relaodWithImageArr:(NSMutableArray *)arr;

@end

NS_ASSUME_NONNULL_END
