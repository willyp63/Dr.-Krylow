//
//  PieSliceLayer.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/18/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "TurnTimerLayer.h"

@implementation TurnTimerLayer

-(id)init{
    self = [super init];
    if (self) {
        self.angle = 0.0;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"angle"]) {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

-(void)drawInContext:(CGContextRef)ctx {
    // Create the path
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = MIN(center.x, center.y) - 2.0;
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, center.x, center.y);
    CGContextAddLineToPoint(ctx, center.x, center.y - radius);
    CGContextAddArc(ctx, center.x, center.y, radius, -1.578, self.angle - 1.578, NO);
    CGContextClosePath(ctx);
    
    // Color it
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

