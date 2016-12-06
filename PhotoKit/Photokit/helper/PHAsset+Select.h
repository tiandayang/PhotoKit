//
//  PHAsset+Select.h
//  ShopnFriends
//
//  Created by 田向阳 on 16/11/15.
//  Copyright © 2016年 WangSuyan. All rights reserved.
//

#import <Photos/Photos.h>

@interface PHAsset (Select)
@property (nonatomic,assign)BOOL selected;

@property (nonatomic,strong)UIImage *thumbImage;

@end
