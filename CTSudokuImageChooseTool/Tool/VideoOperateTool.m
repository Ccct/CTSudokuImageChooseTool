//
//  VideoOperateTool.m
//  SecondVoice
//
//  Created by RLY on 2019/4/24.
//  Copyright © 2019 深圳市最钱沿科技有限公司. All rights reserved.
//

#import "VideoOperateTool.h"

@implementation VideoOperateTool

/**
 获得视频信息
 */
+ (NSMutableDictionary *)getVideoInfoWith:(PHAsset *)videoAsset{
    
    /// 包含该视频的基础信息
    PHAssetResource * resource = [[PHAssetResource assetResourcesForAsset: videoAsset] firstObject];
    
    NSString *string1 = [resource.description stringByReplacingOccurrencesOfString:@"{" withString:@""];
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@", " withString:@","];
    NSMutableArray *resourceArray =  [NSMutableArray arrayWithArray:[string3 componentsSeparatedByString:@" "]];
    [resourceArray removeObjectAtIndex:0];
    [resourceArray removeObjectAtIndex:0];
    
    for (NSInteger index = 0; index<resourceArray.count; index++) {
        NSString *string = resourceArray[index];
        NSString *ret = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        resourceArray[index] = ret;
    }
    
    NSMutableDictionary *videoInfo = [[NSMutableDictionary alloc] init];
    
    for (NSString *string in resourceArray) {
        NSArray *array = [string componentsSeparatedByString:@"="];
        videoInfo[array[0]] = array[1];
    }
    
    NSLog(@"视频信息: %@",videoInfo);
    
    return videoInfo;
}

/**
 将视频转换为mp4格式
 */
+(void)convertVideoToMP4Format:(PHAsset *)videoAsset Compelete:(void(^)(NSURL *fileUrl))fileUrlHandler{
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:videoAsset
                            options:options
                      resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                          
                          [VideoOperateTool convertMovToMp4FromAVURLAsset:(AVURLAsset *)asset andCompeleteHandler:^(NSURL * _Nonnull fileUrl) {
                              
                              fileUrlHandler(fileUrl);
                          }];
                      }];
}

/**
 执行 将mov格式转化为mp4操作
 */
+ (void)convertMovToMp4FromAVURLAsset:(AVURLAsset*)urlAsset andCompeleteHandler:(void(^)(NSURL *fileUrl))fileUrlHandler{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:urlAsset.URL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        
        //  在Documents目录下创建一个名为FileData的文件夹
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/VideoData"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
        if(!(isDirExist && isDir)) {
            BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if(!bCreateDir){
                NSLog(@"创建文件夹失败！%@",path);
            }
            NSLog(@"创建文件夹成功，文件路径%@",path);
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"]; //每次启动后都保存一个新的日志文件中
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        
        __block NSString *resultPath = [path stringByAppendingFormat:@"/%@.mp4",dateStr];
        
        NSLog(@"初始化转化为mp4后，文件地址:%@",resultPath);
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        exportSession.outputFileType = AVFileTypeMPEG4; //mp4
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            int exportStatus = exportSession.status;
            switch (exportStatus) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"AVAssetExportSessionStatusFailed");
                    fileUrlHandler(nil);
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"AVAssetExportSessionStatusCompleted");
                    fileUrlHandler(exportSession.outputURL);
                    break;
            }
        }];
    }
}

@end
