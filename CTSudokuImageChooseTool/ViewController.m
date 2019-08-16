//
//  ViewController.m
//  CTSudokuImageChooseTool
//
//  Created by Helios on 2019/7/3.
//  Copyright © 2019 Helios. All rights reserved.
//

#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "SudokuImageCell.h"
#import "LXJImagePicker.h"
#import "CTImagePicker.h"
#import "UIView+Extension.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *photoImgArr;

@property (nonatomic,strong) CTImagePicker *photoView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoImgArr = [NSMutableArray array];
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        
        unsigned long int count = 0;
        float collectH = 0;
        if(_photoImgArr.count > 0){
            if(_photoImgArr.count == 9){ //选到了9张的情况，后面没有“+”按钮
                count = (_photoImgArr.count) / 3;
            }else{//还未选到9张的情况，后面有“+”按钮
                count = (_photoImgArr.count) / 3 + 1;
            }
            collectH = (WIDTH_SCREEN-24-20) / 3 * count + 30;
        }else{
            //只有一张图片的时候
            collectH = (WIDTH_SCREEN-24-20) / 3 * 1 + 30;
        }
        return collectH;
    }
    else if(indexPath.row == 1){
        return self.photoView.frameHeight;
    }
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    __weak typeof(self) weakSelf = self;
    if(indexPath.row == 0){
        
        SudokuImageCell *photoCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SudokuImageCell class]) forIndexPath:indexPath];
        //添加图片
        photoCell.addImgBlock = ^{
            
            [LXJImagePicker shareInstance].mediaResultBlock = ^(PHAssetMediaType selectType, NSArray *imageaArr, NSArray<PHAsset *> *assetsArr, NSString *videoPath) {
                
                if(selectType == PHAssetMediaTypeImage){
                    
                    [imageaArr enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        [weakSelf.photoImgArr addObject:obj];
                        if(idx == imageaArr.count - 1){
                            
                            [weakSelf reloadAdvPhotosCell];
                        }
                    }];
                }
            };
            [[LXJImagePicker shareInstance] setIfFitToNavigationBarColor:YES];
            NSInteger selectCount = 9 - weakSelf.photoImgArr.count;
            [[LXJImagePicker shareInstance] showImagePickerWithMaxCount:selectCount allowVideo:NO superVC:self];
        };
        //查看图片
        photoCell.showImgBlock = ^(NSInteger showNum) {
//            NSArray *imgArr = @[weakSelf.photoImgArr[showNum]];
            NSLog(@"查看第 %d 张图片",(short)showNum);
        };
        //删除图片
        photoCell.deleteImgBlock = ^(NSInteger tag) {
            [weakSelf.photoImgArr removeObjectAtIndex:tag];
            [weakSelf reloadAdvPhotosCell];
        };
        [photoCell setImageArr:_photoImgArr];
        return photoCell;
    }
    else if (indexPath.row == 1){
        
        static NSString *cellIdStr = @"cellId";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdStr];
        if(!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font =[UIFont systemFontOfSize:16];
            cell.textLabel.textColor = [UIColor blackColor];
            [cell addSubview:self.photoView];
        }
        return cell;
    }
    return [[UITableViewCell alloc]init];
}

- (void)reloadAdvPhotosCell{
    NSIndexPath *indexPath= [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - lazy load
- (UITableView*)tableView{
    if(!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
        _tableView.backgroundColor =[UIColor whiteColor];
        _tableView.delegate   =self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero]; //去掉多余的下划线
        //优化tableview
        _tableView.delaysContentTouches = NO;
        _tableView.canCancelContentTouches = YES;
        UIView *wrapView = self.tableView.subviews.firstObject;
        if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
            for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
                if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                    gesture.enabled = NO;
                    break;
                }
            }
        }
        [_tableView registerClass:[SudokuImageCell class] forCellReuseIdentifier:NSStringFromClass([SudokuImageCell class])];
    }
    return _tableView;
}

- (CTImagePicker *)photoView{
    if(!_photoView) {
        _photoView = [[CTImagePicker alloc] initWithFrame:CGRectMake(10, 0, WIDTH_SCREEN-20, 200)];
        _photoView.maxSelect = 9;
        _photoView.rowCount  = 3;
        //初始化图片选择器
        [self.photoView relaodWithImageArr:[NSMutableArray array]];
        __weak typeof(self) weakSelf = self;
        self.photoView.reloadHeight = ^(CGFloat newHeight) {
            
            weakSelf.photoView.frameHeight = newHeight;
            [weakSelf.tableView reloadData];
        };
    }
    return _photoView;
}

@end
