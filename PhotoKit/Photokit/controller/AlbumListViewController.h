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

@property (nonatomic,assign) NSInteger maxSelectCount;
@end
