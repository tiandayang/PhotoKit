//
//  PHAsset+Select.h
//  ShopnFriends
//
//  Created by 田向阳 on 16/11/15.
//  Copyright © 2016年 WangSuyan. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (Select)
@property (nonatomic,assign)id selected;

@property (nonatomic,assign)id thumbImage;

@property (nonatomic,assign)id imagePath;

@property (nonatomic,assign)id index;

@end
