//
//  CustomSlider.m
//  TestCoreGraphicssdfsdgf
//
//  Created by Alexander on 16.04.15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "CustomSlider.h"

@implementation CustomSlider
{
    CGPoint startPan;
    float startValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSlider];
    CGAffineTransform t;
}

- (void)setupSlider {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

float const smallRadius = 20;
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    float const width = self.bounds.size.width;
    float const height = self.bounds.size.height;
    float const thumbRadius = 24;
    float const thumbMaxRadius = 30;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 10, 0);
    transform = CGAffineTransformScale(transform, (width - 20.0) / width, (width - 20.0) / width); // по Y делаем аналогичное масштабирование чтобы у нас остался круг
    CGContextConcatCTM(context, transform);
    
    // рисуем внешнюю границу
    CGContextMoveToPoint(context, smallRadius, height / 2.0 + smallRadius);
    CGContextAddLineToPoint(context, width - smallRadius, height / 2.0 + smallRadius);
    CGContextAddArc(context, width - smallRadius, height / 2.0, smallRadius, M_PI, -M_PI_2, true);
    CGContextAddLineToPoint(context, smallRadius, height / 2.0 - smallRadius);
    CGContextAddArc(context, smallRadius, height / 2.0, smallRadius, -M_PI_2, M_PI_2, true);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    CGContextSetLineWidth(context, 4.0); // после обрезки будет использоватся 2 внещних пикселя
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextSetLineWidth(context, 2.0);
    
    
    float const valueWidth = [self slideAvaiableWidth];
    float xCenter = (width - valueWidth) / 2.0 + valueWidth * self.value;
    
    // в таком роде контекстах clear mode не работает
//    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(xCenter - thumbMaxRadius, height / 2.0 - thumbMaxRadius, 2 * thumbMaxRadius, 2*thumbMaxRadius));
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextStrokeEllipseInRect(context, CGRectMake(xCenter - thumbMaxRadius, height / 2.0 - thumbMaxRadius, 2 * thumbMaxRadius, 2*thumbMaxRadius));
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    float smallRadius2 = smallRadius - 1.5;
    CGContextMoveToPoint(context, smallRadius, height / 2.0 + smallRadius);
    CGContextAddLineToPoint(context, width - smallRadius, height / 2.0 + smallRadius);
    CGContextAddArc(context, width - smallRadius, height / 2.0, smallRadius, M_PI_2, -M_PI_2, true);
    CGContextAddLineToPoint(context, smallRadius, height / 2.0 - smallRadius);
    CGContextAddArc(context, smallRadius, height / 2.0, smallRadius, -M_PI_2, M_PI_2, true);
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextFillEllipseInRect(context, CGRectMake(xCenter - thumbRadius, height / 2.0 - thumbRadius, 2 * thumbRadius, 2 * thumbRadius));
}

- (void)setValue:(float)value {
    _value = MAX(0, MIN(value, 1));
    [self setNeedsDisplay];
}

- (float)slideAvaiableWidth {
    return self.bounds.size.width - 2 * smallRadius - 4;
}


- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        startPan = [pan locationInView:self];
        startValue = self.value;
    } else if (pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        CGPoint endPan = [pan locationInView:self];
        float avaiableWidth = [self slideAvaiableWidth];
        float dVal = (endPan.x - startPan.x) / avaiableWidth;
        self.value = dVal + startValue;
    }
}

@end
