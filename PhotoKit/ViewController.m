//
//  ViewController.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ViewController.h"
#import "ImageHelper.h"
#import "AlbumListViewController.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageDataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (IBAction)clear:(id)sender {
    [self.imageDataArray removeAllObjects];
    [self.collectionView reloadData];
}

- (IBAction)presentAlbum:(id)sender {
    AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
    albumListVC.maxSelectCount = 5 - self.imageDataArray.count;
    albumListVC.isAscend = YES;
    albumListVC.rightTitle = @"确定";
    
    __weak ViewController *weakSelf = self;
    
    albumListVC.okClickComplete = ^(NSArray<ImageModel *> *images){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [images enumerateObjectsUsingBlock:^(ImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.asset) {
                    [ImageHelper getImageDataWithAsset:obj.asset complete:^(UIImage *image,UIImage*HDImage) {
                        if (image) {
                            [weakSelf.imageDataArray addObject:image];
                            [weakSelf.imageDataArray addObject:HDImage];
                        }
                    }];

                }else{
                    [weakSelf.imageDataArray addObject:obj.thumbImage];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
                
            }];
        });
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:albumListVC];

    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - collectionView delegate &datasource 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageDataArray[indexPath.row]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundView = imageView;
    return cell;
    
}
- (void)createUI{
    
    self.collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = self.view.frame.size;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        collectionView.pagingEnabled = YES;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    
}

- (NSMutableArray*)imageDataArray
{
    if (!_imageDataArray ) {
        _imageDataArray = [NSMutableArray array];
    }
    return _imageDataArray;
}

@end
