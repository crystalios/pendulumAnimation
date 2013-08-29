//
//  YZSViewController.m
//  pendulumAnimation
//
//  Created by 岳宗申 on 13-8-29.
//  Copyright (c) 2013年 岳宗申. All rights reserved.
//

#import "YZSViewController.h"
#import "QuartzCore/QuartzCore.h"
#define DegreesToRadians(x) (M_PI * x / 180.0)

@interface YZSViewController ()

@end

@implementation YZSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *ImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yue"]];
    ImageV.userInteractionEnabled = YES;
    ImageV.center = self.view.center;
    [self.view addSubview:ImageV];
    [ImageV release];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gogo:)];
    [ImageV addGestureRecognizer:pan];
    [pan release];
    CALayer *layer = [ImageV layer];
    layer.anchorPoint = CGPointMake(0.5, 0.0);
    layer.position = CGPointMake(layer.position.x + layer.bounds.size.width * (layer.anchorPoint.x - 0.5), layer.position.y + layer.bounds.size.height * (layer.anchorPoint.y - 0.5));
}
- (void)gogo:(UIPanGestureRecognizer *)panGesture
{
    UIImageView *imageV = (UIImageView *)panGesture.view;
    CGFloat translation = [panGesture translationInView:self.view].x;
    NSLog(@"translation = %f",translation);
    if (translation>90) {
        translation = 90;
    }
    else if (translation <-90)
    {
        translation = -90;
    }
    
    if (panGesture.state == UIGestureRecognizerStateChanged)
    {
        CGAffineTransform swingTransform =CGAffineTransformMakeRotation(DegreesToRadians(-translation));
        imageV.transform = swingTransform;
    }
    else if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        int m = fabs(translation)/10;
        NSLog(@"m = %d",m);
        if (fabs(translation)<10) {
            translation = 0;
            CGAffineTransform swingTransform =CGAffineTransformMakeRotation(DegreesToRadians(translation));
            [UIView animateWithDuration:1.0 animations:^{
                imageV.transform = swingTransform;
            }
                             completion:^(BOOL finished)
             {
                 
             }];
        }
        else
        {
            int d = 0;
            if (translation<0) {
                d = 10;
            }
            else
            {
                d = -10;
            }
            //            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (int i = 0; i<m; i++) {
                translation = translation +d;
                d = -d;
                if (fabs(translation) < 10) {
                    translation = 0;
                }
                CGAffineTransform swingTransform =CGAffineTransformMakeRotation(DegreesToRadians(translation));
                
                __block BOOL done = NO;
                [UIView animateWithDuration:1.0 animations:^{
                    imageV.transform = swingTransform;
                    while (!done)
                    {
                        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:nil];
                    }
                    
                }
                                 completion:^(BOOL finished)
                 {
                     done = YES;
                 }];
                
                translation = -translation;
            }
            //            });
            
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
