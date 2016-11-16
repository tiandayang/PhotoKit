//
//  AlbumListTableViewCell.h
//  PhotoKit
//
//  Created by 田向阳 on 16/11/16.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumListTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *albumDetailLabel;
@end
