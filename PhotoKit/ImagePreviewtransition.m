//
//  ImagePreviewtransition.m
//  PhotoPreview
//
//  Created by 田向阳 on 2016/12/8.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImagePreviewtransition.h"
#import "ImageViewController.h"
#define  Duration  0.2
@interface ImagePreviewtransition()
@property (nonatomic,strong)UIImageView *clickView;
@end

@implementation ImagePreviewtransition
#pragma mark - init
- (instancetype)initWithClickView:(UIImageView *)imageView{
    if (self = [super init]) {
        self.clickView = imageView;
    }
    return self;
}


#pragma mark -  transition Protocol
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return  Duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toVC isKindOfClass:[ImageViewController class]]) {
        [self presentVCWithTransition:transitionContext];
    }else{
        [self dismissVCWithTransition:transitionContext];
    }
}

- (void)presentVCWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ImageViewController *imageVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    imageVC.view.alpha = 0;
    self.clickView.hidden = YES;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:imageVC.view];
    CGRect startFrame = [self.clickView convertRect:self.clickView.bounds toView:window];
    CGRect endFrame = [self getImageFrameWithImage:self.clickView.image];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:startFrame];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [containerView addSubview:imageView];
    imageView.image = self.clickView.image;
    CGFloat duration = [self transitionDuration:transitionContext];

    [UIView animateWithDuration:duration animations:^{
        imageView.frame = endFrame;
        imageVC.view.alpha = 1;
    }completion:^(BOOL finished) {
        [imageVC setImageView:imageView];
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissVCWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    ImageViewController *imageVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [imageVC.imageView removeFromSuperview];
    [containerView addSubview:imageVC.imageView];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect endFrame = [self.clickView convertRect:self.clickView.bounds toView:window];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        imageVC.imageView.frame = endFrame;
        imageVC.imageView.layer.cornerRadius = self.clickView.layer.cornerRadius;
        imageVC.view.alpha = 0;
    }completion:^(BOOL finished) {
        self.clickView.hidden = NO;
        [transitionContext completeTransition:YES];
    }];
    
    
}

#pragma mark -  helper
- (CGRect)getImageFrameWithImage:(UIImage*)image
{
    if(!image)
    return CGRectZero;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    CGSize   screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat  screenScale = screenSize.width / screenSize.height;
    CGFloat  imageScale = image.size.width / image.size.height;
    if (imageScale > screenScale) {
        width = screenSize.width;
        height = width / imageScale;
        y = (screenSize.height - height) / 2.0;
    } else {
        height = screenSize.height;
        width = height * imageScale;
        x = (screenSize.width - width) / 2.0;
    }
    return CGRectMake(x, y, width, height);
}

@end
