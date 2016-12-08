//
//  ImageViewController.m
//  PhotoPreview
//
//  Created by 田向阳 on 2016/12/8.
//  Copyright © 2016年 田向阳. All rights reserved.
//

#import "ImageViewController.h"
#import "ImagePreviewtransition.h"
#define  kMaxImageScale 2

@interface ImageViewController ()<UIViewControllerTransitioningDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (assign) CGFloat orientationAngle;

@end

@implementation ImageViewController

#pragma mark - lifeCycle
- (instancetype)init{
    if (self = [super init]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    self.pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [self.doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    
    for (UIGestureRecognizer *recognizer in @[self.tapGestureRecognizer, self.pinchGestureRecognizer, self.panGestureRecognizer]) {
        [recognizer setDelegate:self];
    }
    
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceOrientationDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        [self deviceWillRotateTo:orientation];
    }];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
#pragma mark - action
- (void)dismissSelf {
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImageView:(UIImageView *)imageView {
    
    [imageView removeFromSuperview];
    _imageView = imageView;
    [_imageView setUserInteractionEnabled:YES];
    
    [_imageView addGestureRecognizer:self.pinchGestureRecognizer];
    [_imageView addGestureRecognizer:self.panGestureRecognizer];
    [_imageView addGestureRecognizer:self.doubleTapGestureRecognizer];
    
    [self.view addSubview:_imageView];
}

#pragma mark - Gestures

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)resetAnchorPointWithContent:(UIView *)content container:(UIView *)container andDuration:(CGFloat)duration {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
    [anim setFromValue:[NSValue valueWithCGPoint:content.layer.anchorPoint]];
    [anim setToValue:[NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)]];
    [anim setDuration:duration];
    [anim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [content.layer addAnimation:anim forKey:@"anchorPoint"];
    [content.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
}

- (void)tap:(UITapGestureRecognizer *)regognizer {
    
    UIView *content = self.imageView;
    UIView *container = content.superview;
    
    CGFloat horizontalScale = sqrt(pow(content.transform.a, 2) + pow(content.transform.c, 2));
    if (horizontalScale == 1.0) {
        [self dismissSelf];
    } else {
        CGFloat duration = 0.3;
        [self resetAnchorPointWithContent:content container:container andDuration:duration];
        [UIView animateWithDuration:duration animations:^{
            [content setCenter:container.center];
            [content setTransform:CGAffineTransformIdentity];
        }];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer {
    
    UIView *content = self.imageView;
    
    CGFloat horizontalScale = sqrt(pow(content.transform.a, 2) + pow(content.transform.c, 2));
    CGFloat zoomScale = (horizontalScale < 1 ? sqrt(recognizer.scale) : recognizer.scale);
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        [content setTransform:CGAffineTransformScale(content.transform, zoomScale, zoomScale)];
        [recognizer setScale:1.0];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.25 animations:^{
            if (horizontalScale < 1.0) {
                [content setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, self.orientationAngle)];
            } else if (horizontalScale > kMaxImageScale) {
                [content setTransform:CGAffineTransformScale(CGAffineTransformRotate(CGAffineTransformIdentity, self.orientationAngle), kMaxImageScale, kMaxImageScale)];
            }
        } completion:nil];
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    
    UIView *content = self.imageView;
    UIView *container = content.superview;
    
    CGRect acceptableRect = [self acceptableCenterPointRectForImageViewSize:content.frame.size];
    
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:container];
        [content setCenter:CGPointMake(content.center.x + translation.x, content.center.y + translation.y)];
        [recognizer setTranslation:CGPointZero inView:container];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat const inertiaRatio = 0.15;
        
        CGPoint const velocity = [recognizer velocityInView:container];
        CGPoint const destination = CGPointMake(content.center.x + velocity.x * inertiaRatio, content.center.y + velocity.y * inertiaRatio);
        
        CGFloat const linearVelocity = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
        
        CGPoint const acceptableDestination = [self pointClosestToPoint:destination inRect:acceptableRect];
        
        CGFloat destinationDelta = ^CGFloat(){
            CGFloat horizontalDelta = ABS(destination.x - acceptableDestination.x);
            CGFloat verticalDelta = ABS(destination.y - acceptableDestination.y);
            return sqrt(pow(horizontalDelta, 2) + pow(verticalDelta, 2));
        }();
        
        if (linearVelocity >= 200.0) {
            
            CGFloat const duration = MIN(linearVelocity * 0.0004, 0.8);
            CGFloat const dampingMultipiler = 0.1;
            CGFloat const dampingRatio = 1.0 - 0.2 * (dampingMultipiler * destinationDelta) / (dampingMultipiler * destinationDelta + 1.0);
            
            [self resetAnchorPointWithContent:content container:container andDuration:duration];
            [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:dampingRatio initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [content setCenter:acceptableDestination];
            } completion:nil];
            
        } else {
            
            CGFloat const duration = MIN(0.3, 0.001 * destinationDelta + 0.1);
            
            [self resetAnchorPointWithContent:content container:container andDuration:duration];
            [UIView animateWithDuration:duration animations:^{
                [content setCenter:acceptableDestination];
            }];
        }
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    
    UIView *content = self.imageView;
    
    [UIView animateWithDuration:0.3 animations:^{
        if (CGAffineTransformEqualToTransform(content.transform, CGAffineTransformIdentity)) {
            [content setTransform:CGAffineTransformScale(content.transform, kMaxImageScale, kMaxImageScale)];
        }
        else{
            [content setTransform:CGAffineTransformIdentity];
        }
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ((gestureRecognizer == self.tapGestureRecognizer && otherGestureRecognizer == self.panGestureRecognizer) ||
        (gestureRecognizer == self.panGestureRecognizer && otherGestureRecognizer == self.tapGestureRecognizer)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (gestureRecognizer == self.tapGestureRecognizer && otherGestureRecognizer == self.doubleTapGestureRecognizer) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Rotation

- (void)deviceWillRotateTo:(UIDeviceOrientation)orientationMode {
    
    CGFloat newAngle;
    
    if (orientationMode == UIDeviceOrientationLandscapeLeft) {
        newAngle = M_PI_2;
    } else if (orientationMode == UIDeviceOrientationLandscapeRight) {
        newAngle = -M_PI_2;
    } else if (orientationMode == UIDeviceOrientationFaceUp || orientationMode == UIDeviceOrientationFaceDown) {
        newAngle = self.orientationAngle;
    } else {
        newAngle = 0.0;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, newAngle - self.orientationAngle);
    } completion:^(BOOL finished) {
        self.orientationAngle = newAngle;
    }];
}

#pragma mark - helper
- (CGRect)acceptableCenterPointRectForImageViewSize:(CGSize)imageViewSize {
    
    CGSize const screenSize = self.view.frame.size;
    CGFloat const kMargin = 0.0;
    
    CGFloat width = MAX(0.0, imageViewSize.width - screenSize.width - 2 * kMargin);
    CGFloat height = MAX(0.0, imageViewSize.height - screenSize.height - 2 * kMargin);
    CGRect acceptableRect = CGRectMake((screenSize.width - width) / 2.0,
                                       (screenSize.height - height) / 2.0,
                                       width,
                                       height);
    
    return acceptableRect;
}

- (CGPoint)pointClosestToPoint:(CGPoint)point inRect:(CGRect)rect {
    
    if (CGRectContainsPoint(rect, point)) return point;
    
    CGFloat x = 0.0;
    
    if (point.x < CGRectGetMinX(rect)) {
        x = CGRectGetMinX(rect);
    } else if (point.x > CGRectGetMaxX(rect)) {
        x = CGRectGetMaxX(rect);
    } else {
        x = point.x;
    }
    
    CGFloat y = 0.0;
    
    if (point.y < CGRectGetMinY(rect)) {
        y = CGRectGetMinY(rect);
    } else if (point.y > CGRectGetMaxY(rect)) {
        y = CGRectGetMaxY(rect);
    } else {
        y = point.y;
    }
    
    return CGPointMake(x, y);
}



#pragma mark - uiviewTransition protocol
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [[ImagePreviewtransition alloc] initWithClickView:self.clickedView];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[ImagePreviewtransition alloc] initWithClickView:self.clickedView];
}


@end
