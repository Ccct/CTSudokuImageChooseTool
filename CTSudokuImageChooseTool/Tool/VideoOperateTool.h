//
//  VideoOperateTool.h
//  SecondVoice
//
//  Created by RLY on 2019/4/24.
//  Copyright © 2019 深圳市最钱沿科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoOperateTool : NSObject

/**
 获得视频信息
 */
+ (NSMutableDictionary *)getVideoInfoWith:(PHAsset *)videoAsset;

/**
 将视频转换为mp4格式
 */
+(void)convertVideoToMP4Format:(PHAsset *)videoAsset Compelete:(void(^)(NSURL *fileUrl))fileUrlHandler;

@end

NS_ASSUME_NONNULL_END
