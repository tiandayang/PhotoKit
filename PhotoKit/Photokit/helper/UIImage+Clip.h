//
//  UIImage+Clip.h
//  PhotoKit
//
//  Created by 田向阳 on 2016/12/6.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clip)
    //  压缩图片
-(UIImage *) imageCompressForTargetSize:(CGSize)size;
    // 压缩到指定大小
+ (UIImage *)clipImage:(UIImage*)image;

@end
