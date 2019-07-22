//
//  SudokuImageCell.m
//  CTSudokuImageChooseTool
//
//  Created by Helios on 2019/7/3.
//  Copyright © 2019 Helios. All rights reserved.
//

#import "SudokuImageCell.h"
#import "UIColor+ColorChange.h"
#import "Masonry.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height

@interface SudokuImageCell()

@property (nonatomic,strong) UIView *photoBgView;
@property (nonatomic,strong) UIButton *addImgBtn;

@end

@implementation SudokuImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.photoBgView];
        [self.photoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(self);
            make.bottom.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Load Data

-(void)setImageArr:(nullable NSArray *)imgArr{
    
    if(self.photoBgView){
        
        [self.photoBgView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    CGFloat width = (WIDTH_SCREEN-24-20)/3;
    
    int count = 3;
    
    if(imgArr.count > 0){
        
        for(int m = 0; m < imgArr.count; m++) {
            
            int line = m % count;
            int row  = m / count;
            
            //图片
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(width * line + 10 * line, 10 * row + row * width, width, width);
            btn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
            
            if([imgArr[m] isKindOfClass:[UIImage class]]){
                [btn setImage:(UIImage *)imgArr[m] forState:(UIControlStateNormal)];
            }else{
                [btn sd_setImageWithURL:[NSURL URLWithString:imgArr[m]] forState:(UIControlStateNormal)];
            }
            btn.tag = m;
            [btn addTarget:self action:@selector(buttonClick:) forControlEvents:1<<6];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            btn.imageView.layer.masksToBounds = YES;
            [self.photoBgView addSubview:btn];
            
            //删除按钮
            UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            deleteBtn.layer.cornerRadius = 5;
            deleteBtn.layer.masksToBounds = YES;
            [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:(UIControlStateNormal)];
            [deleteBtn setImage:[UIImage imageNamed:@"delete_icon"] forState:(UIControlStateSelected)];
            [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:(UIControlEventTouchUpInside)];
            deleteBtn.tag = m;
            [self.photoBgView addSubview:deleteBtn];
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(btn.mas_right).offset(-3);
                make.top.mas_equalTo(btn.mas_top).offset(3);
                make.size.mas_equalTo(CGSizeMake(22, 22));
            }];
        }
        if(imgArr.count != 9){
            //"添加"按钮
            int line = (int)imgArr.count % count;
            int row  = (int)imgArr.count / count;
            [self.photoBgView addSubview:self.addImgBtn];
            self.addImgBtn.frame = CGRectMake(width * line + 10 * line, 10 * row + row * width, width, width);
        }
    }else{
        //"添加"按钮
        [self.photoBgView addSubview:self.addImgBtn];
        self.addImgBtn.frame = CGRectMake(10, 10, width, width);
    }
}

#pragma mark - Pravite Methond

- (void)buttonClick:(UIButton *)btn{
    
    NSInteger tag = btn.tag;
    
    if(tag == 1111){
        !_addImgBlock ? : _addImgBlock();
    }else{
        !_showImgBlock ? : _showImgBlock(tag);
    }
}

- (void)deleteClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    !_deleteImgBlock ? : _deleteImgBlock(tag);
}

#pragma mark - Lazyload

- (UIView *)photoBgView{
    if (!_photoBgView) {
        _photoBgView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _photoBgView;
}

- (UIButton *)addImgBtn{
    if(!_addImgBtn){
        _addImgBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _addImgBtn.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [_addImgBtn setBackgroundImage:[UIImage imageNamed:@"add_AdverPhoto"] forState:(UIControlStateNormal)];
        [_addImgBtn setBackgroundImage:[UIImage imageNamed:@"add_AdverPhoto"] forState:(UIControlStateSelected)];
        _addImgBtn.tag = 1111;
        [_addImgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:1<<6];
        _addImgBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        _addImgBtn.imageView.layer.masksToBounds = YES;
    }
    return _addImgBtn;
}

@end
