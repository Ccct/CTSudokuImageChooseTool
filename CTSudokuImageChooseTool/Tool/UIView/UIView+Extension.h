//
//  UIView+Extension.h
//
//

#import <UIKit/UIKit.h>

#define ScrW [UIScreen mainScreen].bounds.size.width
#define ScrH [UIScreen mainScreen].bounds.size.height


@interface UIView (Extension)

/** UIView 的坐标X点 两种写法，兼容新旧 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat originX;
/** UIView 的坐标Y点 两种写法，兼容新旧 */
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat originY;


/** UIView 的中心点X值 */
@property (nonatomic, assign) CGFloat centerX;
/** UIView 的中心点Y值 */
@property (nonatomic, assign) CGFloat centerY;

/** UIView的最大X值 */
@property (assign, nonatomic) CGFloat maxX;
/** UIView的最大Y值 */
@property (assign, nonatomic) CGFloat maxY;

/** UIView 的宽度，两种写法，兼容新旧 */
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat frameWidth;
/** UIView 的高度  两种写法，兼容新旧 */
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat frameHeight;

/** UIView 的 size */
@property (nonatomic, assign) CGSize size;
/** UIView 的坐标 */
@property (nonatomic, assign) CGPoint origin;

/** UIView 的宽度 bounds */
@property (nonatomic, assign) CGFloat boundsWidth;

/** UIView 的高度 bounds */
@property (nonatomic, assign) CGFloat boundsHeight;

/**
 *  上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat top;

/**
 *  下 < Shortcut for frame.origin.y + frame.size.height
 *      两种写法，兼容新旧 >
 */
@property (nonatomic) CGFloat bottom;

@property (nonatomic, assign) CGFloat frameBottom;

/**
 *  左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat left;

/**
 *  右 < Shortcut for frame.origin.x + frame.size.width
 *      两种写法，兼容新旧 >
 */
@property (nonatomic) CGFloat right;

@property (nonatomic, assign) CGFloat frameRight;

/**
 判断View子视图中是否包含另外一个View
 
 @param subView 需要判断的子View
 @return 返回判定结果，YES，包含；NO，不包含；
 */
- (BOOL) containsSubView:(UIView *)subView;
/**
 判断View子视图中是否包含另外一个类型的View
 
 @param aClass 需要判断的子View
 @return 返回判定结果，YES，包含；NO，不包含；
 */
- (BOOL) containsSubViewOfClassType:(Class)aClass;

//模糊效果
- (void)blurryWithAlpha:(CGFloat)alpha;


/** 图层渐变
 * colors:桥接过后的CGColor
 * partitionLocations:图层渐变的位置点，注意比colors多一个内容
 * startPoint:开始位置
 * endPoint:结束位置
 */
- (void)gradientWithColors:(NSArray *)colors partitionLocations:(NSArray <NSNumber *> *)partitionLocations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
