//
//  ItemSelectView.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/18/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ItemSelectView.h"

@implementation ItemSelectView{
    CGFloat _space;
    int _numItems;
}

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth numItems:(int)numItems itemImagePath:(NSString *)imagePath;{
    self = [super initWithFrame:frame];
    if (self) {
        _numItems = numItems;
        
        //space between each item
        _space = self.bounds.size.width / (_numItems + 1);
        
        //init base layer
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = [UIColor grayColor].CGColor;
        
        //init selection layer
        CGFloat height = self.bounds.size.height;
        _selectionLayer = [CALayer layer];
        _selectionLayer.frame = CGRectMake(_space - height/2, 0.0, height, height);
        _selectionLayer.cornerRadius = height/2;
        _selectionLayer .borderWidth = borderWidth;
        _selectionLayer.borderColor = [UIColor blackColor].CGColor;
        _selectionLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        //add selection layer
        [self.layer addSublayer:_selectionLayer];
        
        //load sprite sheet for item images
        UIImage *spriteSheet = [UIImage imageWithContentsOfFile:imagePath];
        
        //get create and add a layer for each image
        for (int i = 0; i < _numItems; i++) {
            CGRect cropRect = CGRectMake(i*height, 0.0, height, height);
            CGImageRef image = CGImageCreateWithImageInRect(spriteSheet.CGImage, cropRect);
            
            CALayer *imageLayer = [CALayer layer];
            imageLayer.frame = CGRectMake(_space*(i + 1) - height/2, 0.0, height, height);
            imageLayer.contents = (__bridge id _Nullable)(image);
            [self.layer addSublayer:imageLayer];
            
            CGImageRelease(image);
        }
    }
    return self;
}

-(void)selectItem:(int)item{
    if (item >= 0 && item < _numItems) {
        CGPoint newPosition = CGPointMake(_space * (item + 1), self.bounds.size.height/2);
        
        CABasicAnimation *moveSelection = [CABasicAnimation animationWithKeyPath:@"position"];
        moveSelection.fromValue = [NSValue valueWithCGPoint:_selectionLayer.position];
        moveSelection.toValue = [NSValue valueWithCGPoint:newPosition];
        moveSelection.duration = 0.25;
        moveSelection.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        _selectionLayer.position = newPosition;
        [_selectionLayer removeAllAnimations];
        [_selectionLayer addAnimation:moveSelection forKey:@"position"];
    }
}

@end
