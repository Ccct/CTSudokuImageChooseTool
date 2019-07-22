//
//  LXJImagePicker.m
//  SecondVoice
//
//  Created by RLY on 2019/2/18.
//  Copyright © 2019 深圳市最钱沿科技有限公司. All rights reserved.
//

#import "LXJImagePicker.h"
#import "VideoOperateTool.h"

@interface LXJImagePicker()<TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imagesArr;

@property (nonatomic, strong) NSMutableArray *assetsArr;

@end

@implementation LXJImagePicker

+ (instancetype)shareInstance {
    static LXJImagePicker *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[LXJImagePicker alloc] init];
    });
    return instance;
}

- (void)showImagePickerWithMaxCount:(NSInteger)count allowVideo:(BOOL)allow superVC:(UIViewController *)vc {
    
    [self.imagesArr removeAllObjects];
    [self.assetsArr removeAllObjects];
    
    typeof(self) __weak weakSelf = self;
    TZImagePickerController *imagePC=[[TZImagePickerController alloc]initWithMaxImagesCount: count delegate: self];
    imagePC.allowPickingVideo = allow;
    imagePC.allowTakePicture = NO;
    imagePC.allowTakeVideo = NO;
    
    //选择了照片
    [imagePC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        __block int count = 0;
        [weakSelf.assetsArr addObjectsFromArray:assets];
        [weakSelf.imagesArr addObjectsFromArray: photos];
        !weakSelf.mediaResultBlock ? : weakSelf.mediaResultBlock(PHAssetMediaTypeImage,weakSelf.imagesArr.copy, weakSelf.assetsArr.copy, @"");
    }];
    
    //选择了视频
    [imagePC setDidFinishPickingVideoHandle:^(UIImage *coverImage, PHAsset *videoAsset) {

        if(weakSelf.maxVideoSize != 0 ){

            NSMutableDictionary *videoInfoArr = [VideoOperateTool getVideoInfoWith:videoAsset];
            double videoSize = [[videoInfoArr objectForKey:@"fileSize"] doubleValue];
            if(videoSize > weakSelf.maxVideoSize){ //超过最大视频限制
                
                NSLog(@" 所选视频的大小: %f，超过最大视频限制:%f",videoSize,weakSelf.maxVideoSize);
                !weakSelf.mediaResultBlock ? : weakSelf.mediaResultBlock(PHAssetMediaTypeVideo,nil, nil, nil);
            }else{
                [weakSelf handleVideoCoverImg:coverImage VideoAsset:videoAsset];
            }
        }else{
           [weakSelf handleVideoCoverImg:coverImage VideoAsset:videoAsset];
        }
    }];
    [vc presentViewController:imagePC animated:YES completion:nil];//跳转
}

- (void)handleVideoCoverImg:(UIImage *)coverImage VideoAsset:(PHAsset *)videoAsset{
    
    self.imagesArr = [NSMutableArray arrayWithArray:@[coverImage]];
    self.assetsArr = [NSMutableArray arrayWithArray:@[videoAsset]];
    
    !self.isChooseVideoBlock ? : self.isChooseVideoBlock();
    
    typeof(self) __weak weakSelf = self;
    dispatch_async(dispatch_queue_create(0, 0), ^{
        
        [[TZImageManager manager] getVideoOutputPathWithAsset:videoAsset presetName:AVAssetExportPresetMediumQuality success:^(NSString *outputPath) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
                !weakSelf.mediaResultBlock ? : weakSelf.mediaResultBlock(PHAssetMediaTypeVideo,weakSelf.imagesArr, weakSelf.assetsArr, outputPath);
            });
        } failure:^(NSString *errorMessage, NSError *error) {
            
            NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
        }];
    });
}


/// 选择单张照片
- (void)showImagePickerWithSuperVC:(UIViewController *)vc{
    [self showImagePickerWithSuperVC:vc alowCrop:NO circleCrop:NO customCropRect:CGRectZero];
}

/// 单张照片 正方形剪切
- (void)showImagePickerAlowCropWithSuperVC:(UIViewController *)vc{
    [self showImagePickerWithSuperVC:vc alowCrop:YES circleCrop:NO customCropRect:CGRectZero];
}

/// 单张照片 圆形剪切
- (void)showImagePickerAlowCircleCropWithSuperVC:(UIViewController *)vc{
    [self showImagePickerWithSuperVC:vc alowCrop:YES circleCrop:YES customCropRect:CGRectZero];
}

/// 单张照片 自定义矩形剪切 (cropRect:自定义裁剪框的位置、尺寸)
- (void)showImagePickerWithSuperVC:(UIViewController *)vc customCropRect:(CGRect)cropRect{
    [self showImagePickerWithSuperVC:vc alowCrop:YES circleCrop:NO customCropRect:cropRect];
}

/// 单张照片  (vc:控制器 alowCrop:是否允许剪切 circleCrop:是否使用圆形剪切框 cropRect:自定义裁剪框的尺寸)
- (void)showImagePickerWithSuperVC:(UIViewController *)vc alowCrop:(BOOL)alowCrop circleCrop:(BOOL)circleCrop customCropRect:(CGRect)cropRect{
    TZImagePickerController *imagePC = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
 
    if (self.ifFitToNavigationBarColor == YES) {
        //设置imagePC的外观
        imagePC.naviBgColor = vc.navigationController.navigationBar.barTintColor;
        imagePC.naviTitleColor = vc.navigationController.navigationBar.tintColor;
        imagePC.barItemTextColor = vc.navigationController.navigationBar.tintColor;
        imagePC.navigationBar.tintColor = vc.navigationController.navigationBar.tintColor;
    }
    
    imagePC.allowTakePicture = NO;  //隐藏拍照
    imagePC.allowPickingGif = NO;   //不能选择gif
    imagePC.allowPickingVideo = NO; //不能选择video
    imagePC.allowPickingOriginalPhoto = NO;//不能选择原图
    
    imagePC.allowCrop = alowCrop;//允许裁剪
    if (cropRect.size.width > 0) {
        imagePC.cropRect = cropRect;//矩形裁剪框的尺寸
    }
    imagePC.needCircleCrop = circleCrop;//允许圆形裁剪框
    
    //    if (circleCrop == YES) {
    //        imagePC.circleCropRadius = circleCropRadius;//圆形裁剪框半径大小
    //    }
    //showSelectBtn;  在单选模式下，照片列表页中，显示选择按钮,默认为NO
    //cropViewSettingBlock // 自定义裁剪框的其他属性
    typeof(self) __weak weakSelf = self;
    imagePC.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [weakSelf.imagesArr removeAllObjects];
        for (UIImage *image in photos) {
            [weakSelf.imagesArr addObject: image];
        }
        self.resultBlock(weakSelf.imagesArr, photos);
    };
    [vc presentViewController:imagePC animated:YES completion:nil];//跳转
}

- (NSMutableArray *)imagesArr {
    if (!_imagesArr) {
        _imagesArr = [[NSMutableArray alloc]init];
    }
    return _imagesArr;
}
- (NSMutableArray *)assetsArr {
    if (!_assetsArr) {
        _assetsArr = [[NSMutableArray alloc]init];
    }
    return _assetsArr;
}

@end
