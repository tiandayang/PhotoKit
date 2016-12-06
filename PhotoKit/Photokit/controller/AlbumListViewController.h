//
//  AlbumListViewController.h
//  PhotoKit
//
//  Created by 田向阳 on 16/11/16.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageHelper.h"
@interface AlbumListViewController : UIViewController
@property (nonatomic, copy) void(^okClickComplete)(NSArray<ImageModel *> *images);

@property (nonatomic, copy) NSString *rightTitle;

@property (nonatomic,assign) NSInteger maxSelectCount; // 可选的最大数量

@property (nonatomic,assign) AlbumType albumType;      // 相册的类型，用途

@property (nonatomic,assign) BOOL isAscend;            // 是否是升序， 相机的位置是顶部还是底部，默认降序 顶部(NO)
@end
