//
//  UIImage+Common.h
//  HLMagic
//
//  Created by marujun on 13-12-8.
//  Copyright (c) 2013年 chen ying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *)defaultImage;
+ (UIImage *)defaultAvatar;
- (UIImage *)circleAvaterImage;

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageScaledToSize:(CGSize)newSize;
- (UIImage *)imageClipedWithRect:(CGRect)clipRect;

//模糊化图片
- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius;

//黑白图片
- (UIImage*)monochromeImage;

// 获取图片的主要颜色
- (UIColor*)mostColor;

//截取部分图像
- (UIImage*)getSubImage:(CGRect)rect;

//等比例缩放
- (UIImage*)scaleToSize:(CGSize)size;
//  压缩图片 
-(UIImage *) imageCompressForTargetSize:(CGSize)size;
// 压缩到指定大小
+ (UIImage *)clipImage:(UIImage*)image;

@end
