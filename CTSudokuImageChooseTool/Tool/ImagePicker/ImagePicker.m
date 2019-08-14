//
//  ImagePicker.m
//
//  Created by 白月光 on 2018/12/6.

#import "ImagePicker.h"
#import "PhotoCell.h"
//#import "JGPBBrowserController.h"
//#import "JGPBPhoto.h"
#import <TZImagePickerController.h>

@interface ImagePicker ()<UICollectionViewDelegate,UICollectionViewDataSource,TZImagePickerControllerDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,assign) BOOL isMoveing;
@end

@implementation ImagePicker

- (id)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor clearColor];
        self.deleteArr =[NSMutableArray array];
        if(_maxSelect == 0){
            _maxSelect = 9;
        }
    }
    return self;
}

#pragma mark - CollectionView

- (UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //设置CollectionView的属性
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, self.frameHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [self addSubview:self.collectionView];
        //注册Cell
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
        
        //添加长按手势
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMoving:)];
        [_collectionView addGestureRecognizer:_longPress];
    }
    return _collectionView;
}

#pragma mark  CollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArr.count == _maxSelect)
    {
        return _maxSelect;
    }
    else{
       return self.imageArr.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    cell.deleteBtn.tag = 1314+indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:1<<6];
    if (indexPath.row >= self.imageArr.count && self.imageArr.count <9) {
        [cell configDataWithType:PhotoCellType_add WithImage:nil WithUrl:nil];
    }else{
        id obj = self.imageArr[indexPath.row];
        if ([obj isKindOfClass:[UIImage class]]) {
            [cell configDataWithType:PhotoCellType_Image WithImage:self.imageArr[indexPath.row] WithUrl:nil];
        }
    }
    return cell;
}

//设置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((self.frameWidth-60)/5,((self.frameWidth-60)/5));
}

//item之间的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);//（上、左、下、右）
}

//定义每个item的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//定义每个item的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

//交换
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    if (sourceIndexPath.item < self.imageArr.count && destinationIndexPath.item < self.imageArr.count) {
        id objc = [self.imageArr objectAtIndex:sourceIndexPath.item];
        [self.imageArr removeObject:objc];
        [self.imageArr insertObject:objc atIndex:destinationIndexPath.item];
    }
}

//允许移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
     return YES;
}

#pragma mark - longPresss

- (void)longPressMoving:(UILongPressGestureRecognizer *)longPress{
    //筛选长按手势状态
    switch (_longPress.state) {
            //开始
        case UIGestureRecognizerStateBegan: {
            {
                if (@available(iOS 9.0, *)) {
                    // 手势作用的位置
                    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                    // 找到当前的cell
                    PhotoCell *cell = (PhotoCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
                    //最后一个不能移动
                    if (cell.cellType == PhotoCellType_add) {
                        return;
                    }
                    // 拽起变大动画效果
                    [UIView animateWithDuration:0.1 animations:^{
                        [cell setTransform:CGAffineTransformMakeScale(1.2, 1.2)];
                    }];
                    //开始移动
                    [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                }
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (@available(iOS 9.0, *)) {
                // 手势作用的位置
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                // 找到当前的cell
                PhotoCell *cell = (PhotoCell *)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
                //最后一个不能移动
                if (cell.cellType == PhotoCellType_add) {
                    return;
                }
                //更新移动的位置
                [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (@available(iOS 9.0, *)) {
                //结束移动
                [self.collectionView endInteractiveMovement];
            }
            break;
        }
        default://取消移动
            if (@available(iOS 9.0, *)) {
                [self.collectionView cancelInteractiveMovement];
            }
            break;
    }
}

#pragma mark - Click

//设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//点击item触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    //选择图片
    if (indexPath.row == self.imageArr.count && self.imageArr.count < _maxSelect) {
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxSelect delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        [[self currentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray *imageArr, NSArray *array,BOOL success) {
            
            for(NSInteger i = 0; i < array.count; i++) {
                
                UIImage *tempImage = imageArr[i];
                if (self.imageArr.count < weakSelf.maxSelect) {
                
                   [self.imageArr addObject:tempImage];
                }
            }
            [self relaodWithImageArr:self.imageArr];
        }];
    }
    //查看大图
    else{

    }
}

//删除图片
- (void)deleteBtnClick:(UIButton*)button{
    if(button.tag - 1314 < self.imageArr.count) {
      [self.imageArr removeObjectAtIndex:button.tag-1314];//删除当前图片列表中该数据对象
      [self relaodWithImageArr:self.imageArr];
    }
}

#pragma mark - Pub

//刷新展示
- (void)relaodWithImageArr:(NSMutableArray*)arr;
{
     self.imageArr = arr;
     self.collectionView.frameHeight = [ImagePicker getMyHeightWithCount:(int)arr.count WithWidth:self.frameWidth];
    [self.collectionView reloadData];
    
     if(self.reloadHeight) {
        self.reloadHeight(self.collectionView.frameHeight);
     }
}

//获取自身高度
+ (CGFloat)getMyHeightWithCount:(int)count WithWidth:(CGFloat)width;
{
    if (count < 9) {
        count = count+1;
    }
    int lineCount = (count - 1) / 5 + 1 ;// 计算得到行数
    CGFloat resultWidth = (width-40)/5;
    return lineCount*resultWidth + (lineCount+1)*10;
}


#pragma mark - Tool

-(UIViewController*) currentViewController{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

- (UIViewController*) findBestViewController:(UIViewController*)vc{
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}


@end




