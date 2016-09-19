//
//  TurnTimerView.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/18/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "TurnTimerView.h"

@implementation TurnTimerView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _timerLayer = [TurnTimerLayer layer];
        _timerLayer.frame = self.bounds;
        [self.layer addSublayer:_timerLayer];
        
        [self.layer setNeedsDisplay];
    }
    return self;
}

-(void)startTimerWithDuration:(CGFloat)duration delegate:(id)delegate{
    CABasicAnimation *reset = [CABasicAnimation animationWithKeyPath:@"angle"];
    reset.fromValue   = @6.28;
    reset.toValue = @0.0;
    reset.duration = duration;
    reset.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    reset.delegate = delegate;
    
    [_timerLayer removeAllAnimations];
    [_timerLayer addAnimation:reset forKey:@"angle"];
}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    // Create the path
    CGPoint center = CGPointMake(layer.bounds.size.width/2, layer.bounds.size.height/2);
    CGFloat radius = MIN(center.x, center.y) - 2.0;
    
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, center.x, center.y, radius, 0,  6.28, NO);
    
    // Color it
    CGContextSetFillColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

-(void)stopTimer{
    [_timerLayer removeAllAnimations];
}

@end
