
    //
//  ImageCollectionViewController.m
//  PhotoKit
//
//  Created by 田向阳 on 16/11/14.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImageCollectionViewController.h"
#import "ImageCollectionViewCell.h"

static NSString * const kCellIdentifier = @"ImageCollectionViewCellIdentifier";
static NSInteger const kItemsOfRow = 3;
static CGFloat   const kItemsSpace = 2.0;
@interface ImageCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray *selectArray;

@property (nonatomic,assign)NSInteger photoIndex;  // 拍照按钮应该显示的索引位置
@end

@implementation ImageCollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maximumNumberOfSelection = 9;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setUpFirstData];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [self addNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeNotification];
}

#pragma mark -  load Data
- (void)setUpFirstData
{
    self.selectArray = [NSMutableArray array];
        if (self.rightItemTitle) {
            [self setRightButtonItemWithTitle:self.rightItemTitle];
    }
}

- (void)loadData
{
    [self changeRightItemState];
    if (self.isAscend) {
        [self scrollsToBottomAnimated:NO];
    }
}

- (void)setAssetResult:(PHFetchResult *)assetResult
{
    _assetResult = assetResult;
    self.photoIndex = self.isAscend?assetResult.count : 0;
}

#pragma mark - action
- (void)didClickNavigationBarViewRightButton
{
    if (self.selectArray.count>0) {
        self.okClickComplete ? self.okClickComplete(self.selectArray) : nil;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)appDidBecomeActive:(NSNotification*)notification
{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - notifications
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetResult.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        if (indexPath.row == self.photoIndex) {
            cell.imageView.image  = [UIImage imageNamed:@"ch_camera_photo"];
            cell.selectImageView.hidden = YES;
            cell.indexLabel.hidden = YES;
        }else{
            PHAsset *asset = nil;
            if (self.isAscend) {
            asset = self.assetResult[indexPath.row];
            }else{
            asset = self.assetResult[indexPath.row - 1];
            }
            cell.selectArray = self.selectArray;
            cell.asset = asset;
        }
        return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (WINDOW_WIDTH - (kItemsOfRow -1) * kItemsSpace) / kItemsOfRow;
    return CGSizeMake(width, width);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photoIndex) {
        if (self.selectArray.count >= self.maximumNumberOfSelection) {
            [ImageHelper showAlertWithTittle:[NSString stringWithFormat:@"最多只能选择%lu张图片",(unsigned long)self.maximumNumberOfSelection] message:nil showController:self isSingleAction:YES complete:nil];
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else{
        
        ImageCollectionViewCell *cell = (ImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.asset.selected) {
            int count = -1;
            for (ImageModel *subItem in self.selectArray.mutableCopy) {
                count ++;
                if ([subItem.asset.localIdentifier isEqualToString:cell.asset.localIdentifier]) {
                    [self.selectArray removeObjectAtIndex:count];
                    break;
                }
            }
        }
        else{
            
            if (self.selectArray.count >= self.maximumNumberOfSelection) {
            [ImageHelper showAlertWithTittle:[NSString stringWithFormat:@"最多只能选择%lu张图片",(unsigned long)self.maximumNumberOfSelection] message:nil showController:self isSingleAction:YES complete:nil];
                return;
            }
            ImageModel *item = [ImageModel new];
            item.asset = cell.asset;
            [self.selectArray addObject:item];
        }
        [self changeCurrentSelectedItemIndexWithCell:cell];
    }
    
}

- (void)changeCurrentSelectedItemIndexWithCell:(ImageCollectionViewCell*)cell
{
    self.collectionView.userInteractionEnabled = NO;
    cell.selectImageView.hidden = !cell.selectImageView.hidden;
    cell.indexLabel.hidden = !cell.indexLabel.hidden;
    cell.asset.selected = !cell.asset.selected;
    cell.indexLabel.text = [NSString stringWithFormat:@"%ld",self.selectArray.count];
    [self changeRightItemState];
    [cell updteImageIsSelected:!cell.selectImageView.hidden complete:^(BOOL isFinish) {
        self.collectionView.userInteractionEnabled = YES;
        [self.collectionView reloadData];
    }];
    
}
#pragma mark -   imagepicker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *theImage;
    if (picker.allowsEditing) {
        theImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    }else{
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
      UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
        ImageModel *item = [ImageModel new];
        item.thumbImage = theImage;
        [self.selectArray addObject:item];
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self didClickNavigationBarViewRightButton];
}

#pragma mark - lazy
- (NSMutableArray*)selectArray
{
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView) {
     
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = kItemsSpace;
        layout.minimumInteritemSpacing = kItemsSpace;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = self.view.backgroundColor;
    }
    
    return _collectionView;
}


#pragma mark - helper
- (void)changeRightItemState
{
    NSUInteger imageCount = self.selectArray.count;
    if (imageCount > 0) {
        if (self.rightItemTitle) {
            [self setRightButtonItemWithTitle:[self.rightItemTitle stringByAppendingString:[NSString stringWithFormat:@"(%@)", [@(imageCount) stringValue]]]];
        }
    }else{
        [self setRightButtonItemWithTitle:@"取消"];
    }
}
- (void)setRightButtonItemWithTitle:(NSString *)titleString
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:titleString style:UIBarButtonItemStylePlain target:self action:@selector(didClickNavigationBarViewRightButton)];
}
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    [self.view layoutIfNeeded];
    CGFloat offset = self.collectionView.contentSize.height - self.collectionView.bounds.size.height;
    if (offset > 0)
    {
        CGFloat width = (WINDOW_WIDTH - (kItemsOfRow -1) * kItemsSpace) / kItemsOfRow;
        [self.collectionView setContentOffset:CGPointMake(0, offset+ width/2.0) animated:animated];
    }
}
@end
