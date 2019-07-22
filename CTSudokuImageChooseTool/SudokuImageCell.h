//
//  SudokuImageCell.h
//  CTSudokuImageChooseTool
//
//  Created by Helios on 2019/7/3.
//  Copyright © 2019 Helios. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SudokuImageCell : UITableViewCell

@property (nonatomic, copy) dispatch_block_t addImgBlock;

@property (nonatomic, copy) void (^showImgBlock) (NSInteger showNum);

@property (nonatomic, copy) void (^deleteImgBlock) (NSInteger tag);

-(void)setImageArr:(nullable NSArray *)imgArr;

@end

NS_ASSUME_NONNULL_END
