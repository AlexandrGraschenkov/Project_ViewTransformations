//
//  ViewController.m
//  TestCoreGraphicssdfsdgf
//
//  Created by Alexander on 16.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CALayer *myLayer;
}
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imgView.image = [self drawImageAspectFitWithSize:CGSizeMake(100, 200)];
    CGPoint center = self.imgView.center;
    CATransform3D tranform = self.imgView.layer.transform;
    tranform.m34 = -1.0 / 500.0;
//    tranform = CATransform3DRotate(tranform, M_PI, 1, 0, 0);
    
    CAShapeLayer *shape = [CAShapeLayer new];
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.lineWidth = 10.0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGAffineTransform tr = CGAffineTransformIdentity;
    CGPathMoveToPoint(path, &tr, 100, 0);
    CGPathAddLineToPoint(path, &tr, 0, 100);
    shape.path = path;
    shape.frame = CGRectMake(0, 0, 100, 100);
    shape.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 50);
    
    CAShapeLayer *shape2 = [CAShapeLayer new];
    shape2.strokeColor = [UIColor redColor].CGColor;
    shape2.lineWidth = 10.0;
    path = CGPathCreateMutable();
    tr = CGAffineTransformIdentity;
    CGPathMoveToPoint(path, &tr, 100, 0);
    CGPathAddLineToPoint(path, &tr, 200, 100);
    shape2.path = path;
    shape2.frame = CGRectMake(0, 0, 100, 100);
    shape2.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 100);
    
    myLayer = [CALayer new];
    myLayer.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5].CGColor;
    myLayer.frame = CGRectMake(10, 310, 200, 200);
    [self.view.layer addSublayer:myLayer];
    [myLayer addSublayer:shape];
    [myLayer addSublayer:shape2];
    
//    [self.imgView.layer addSublayer:shape];
//    [UIView animateWithDuration:10.0 animations:^{
        myLayer.sublayerTransform = tranform;
//    }];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:pan];
}


- (void)handlePan:(UIPanGestureRecognizer *)pan {
    static CATransform3D startTransform;
    if (pan.state == UIGestureRecognizerStateBegan) {
        startTransform = myLayer.sublayerTransform;
    } else {
        float x = [pan translationInView:self.view].x;
        myLayer.sublayerTransform = CATransform3DRotate(startTransform, x / 100, 0, 1, 0);
    }
}

- (UIImage *)drawImageAspectFitWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    
    CGFloat diam = MIN(size.width, size.height);
    CGFloat x = (size.width - diam) / 2.0;
    CGFloat y = (size.height - diam) / 2.0;
    CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diam, diam));
    CGContextSaveGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    
    x += 10;
    y += 10;
    diam -= 20;
    CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diam, diam));
    
    CGContextRestoreGState(ctx);
//    CGContextSetBlendMode(ctx, kCGBlendModeNormal);
    
    x += 10;
    y += 10;
    diam -= 20;
    CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diam, diam));
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    return img;
}

@end
