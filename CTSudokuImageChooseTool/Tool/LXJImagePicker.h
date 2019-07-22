//
//  LXJImagePicker.h
//  SecondVoice
//
//  Created by RLY on 2019/2/18.
//  Copyright © 2019 深圳市最钱沿科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"


/// 照片管理器—???需要加一个拍照的
@interface LXJImagePicker : NSObject

/// 导航栏的背景颜色和文字颜色与controller保持一致 (默认为NO)
@property (nonatomic, assign) BOOL ifFitToNavigationBarColor;

@property (nonatomic, assign) double maxVideoSize; //视频最大内存限制 单位：B

/// 选择图片回调 files:压缩并转为base64字符串的图片 images:原图片
@property (nonatomic, copy) void (^ resultBlock)(NSArray *files, NSArray *images);

/// 选择资源的回调  images:图片 asset:资源源文件 videoPath:视频的路径,如果是图片就是空@“”
@property (nonatomic, copy) void (^ mediaResultBlock)(PHAssetMediaType selectType, NSArray *imageaArr, NSArray<PHAsset *> *assetArr, NSString *videoPath);

/// 选择了视频的回调
@property (nonatomic, copy) void (^ isChooseVideoBlock)(void);



+ (instancetype)shareInstance;

/// 选择多张照片 count:最多勾选照片数量  allowVideo:是否可以选择视频
- (void)showImagePickerWithMaxCount:(NSInteger)count allowVideo:(BOOL)allow superVC:(UIViewController *)vc;

/// 选择单张照片
- (void)showImagePickerWithSuperVC:(UIViewController *)vc;

/// 单张照片 正方形剪切
- (void)showImagePickerAlowCropWithSuperVC:(UIViewController *)vc;

/// 单张照片 圆形剪切
- (void)showImagePickerAlowCircleCropWithSuperVC:(UIViewController *)vc;

/// 单张照片 自定义矩形剪切 (cropRect:自定义裁剪框的位置、尺寸)
- (void)showImagePickerWithSuperVC:(UIViewController *)vc customCropRect:(CGRect)cropRect;

@end
