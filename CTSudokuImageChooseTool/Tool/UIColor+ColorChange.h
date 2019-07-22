
#import <UIKit/UIKit.h>

@interface UIColor (ColorChange)

/**
 根据色值获取对应Color

 @param color 标注图色值
 @return 对应Color
 */
+ (UIColor *) colorWithHexString:(NSString *)color;


/**
 根据色值和透明度要求获取颜色

 @param color 色值
 @param alpha 透明度
 @return 对应颜色
 */
+ (UIColor *) colorWithHexString:(NSString *)color andAlpha:(CGFloat)alpha;

@end
