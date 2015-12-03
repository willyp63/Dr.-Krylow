//
//  CharacterView.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "CharacterView.h"

@implementation CharacterView{
    IntPoint *_animationOffsets;
    CGFloat *_animationDurations;
    int _animationNumber;
}

-(id)initWithFrame:(CGRect)frame sprites:(NSArray<NSArray<UIImage *> *> *)sprites offsets:(IntPoint *)offsets animationDurations:(CGFloat *)durations{
    self = [super initWithFrame:frame];
    if (self) {
        _sprites = sprites;
        _animationOffsets = offsets;
        _animationDurations = durations;
        _animationNumber = 0;
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

-(void)loopAnimationNumber:(int)number inDirection:(Direction)direction{
    //get animation index
    int i = (number * 4) + direction;
    
    //check that index is valid
    if (i < _sprites.count) {
        [self animate:i];
    }
}

-(void)playAnimationNumber:(int)number inDirection:(Direction)direction{
    //get animation index
    int i = (number * 4) + direction;
    
    //check that index is valid
    if (i < _sprites.count) {
        int oldAnimationNumber = _animationNumber;
        
        [self animate:i];
        
        //switch back
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _imageView.animationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self loopAnimationNumber:oldAnimationNumber inDirection:direction];
        });
    }
}

-(void)playFinalAnimationNumber:(int)number inDirection:(Direction)direction{
    //get animation index
    int i = (number * 4) + direction;
    
    //check that index is valid
    if (i < _sprites.count) {
        [self animate:i];
        
        //remove view after animation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _imageView.animationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
}

-(void)animate:(int)i{
    _animationNumber = i / 4;
    
    //stop animating
    if ([_imageView isAnimating]) {
        [_imageView stopAnimating];
    }
    
    //set images and repeat count
    _imageView.frame = CGRectMake(_animationOffsets[i].x, _animationOffsets[i].y, _sprites[i][0].size.width, _sprites[i][0].size.height);
    _imageView.animationImages = _sprites[i];
    _imageView.animationDuration = _animationDurations[i];
    _imageView.animationRepeatCount = 0;
    [_imageView startAnimating];
}

@end
