//
//  ImageViewController.h
//  PhotoPreview
//
//  Created by 田向阳 on 2016/12/8.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UIImageView *clickedView; // 最好把imageView传过来
@property (nonatomic,strong) UIImage *image;          // 要查看的图片
@end
