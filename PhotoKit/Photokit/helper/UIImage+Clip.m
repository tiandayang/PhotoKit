//
//  UIImage+Clip.m
//  PhotoKit
//
//  Created by 田向阳 on 2016/12/6.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)
-(UIImage *) imageCompressForTargetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (UIImage *)clipImage:(UIImage*)image
{
    image = [image imageCompressForTargetSize:CGSizeMake(image.size.width*0.5,image.size.height * 0.5)];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (imageData.length>300*1024) {
        return [self clipImage:image];
    }
    image = [UIImage imageWithData:imageData];
    return image;
}

@end
