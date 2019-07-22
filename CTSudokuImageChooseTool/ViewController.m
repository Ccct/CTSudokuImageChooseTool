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

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photoImgArr;

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
            count = (_photoImgArr.count - 1) / 3 + 1;
            collectH = (WIDTH_SCREEN-24-20)/3 * count + 90;
        }else{
            collectH = 90;
        }
        return collectH + 90;
    }
    return 55;
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
    
    return [[UITableViewCell alloc]init];
}

/// 刷新“广告内容”cell
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


@end