//
//  LevelView.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 10/28/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import "LevelView.h"

@implementation LevelView{
    int _size;
    CGFloat _cornerRadius, _borderWidth;
    UIImage *_tileImage;
}

/*INIT*/
- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth size:(int)size tileImagePath:(NSString *)imagePath{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        _cornerRadius = cornerRadius;
        _borderWidth = borderWidth;
        _size = size;
        
        //get cell size
        _cellSize = self.bounds.size.width / size;
        
        //create border layer
        CALayer *border = [CALayer layer];
        border.frame = self.bounds;
        border.cornerRadius = _cornerRadius;
        border.borderWidth = _borderWidth;
        border.borderColor = [UIColor blackColor].CGColor;
        border.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:border];
        
        //load tile image
        _tileImage = [UIImage imageWithContentsOfFile:imagePath];
        
        //tile background
        [self.layer setNeedsDisplay];
        
        //create character views
        _characters = [[NSMutableArray alloc] initWithCapacity:LEVEL_SIZE*LEVEL_SIZE];
        
        _spritesDictionary = [[NSMutableDictionary alloc] initWithCapacity:LEVEL_SIZE*LEVEL_SIZE];
    }
    return self;
}

-(void)addCharacterViewsForModels:(NSMutableArray<CharacterModel *> *)models{
    for (int i = 0 ; i < models.count; i++) {
        CharacterModel *model = models[i];
        
        //create key
        NSString *key = [NSString stringWithFormat:@"%d", [model type]];
        
        //load sprites and add to dictionary if not already done so
        if (![[_spritesDictionary allKeys] containsObject:key]) {
            NSArray<NSArray<UIImage *> *> *sprites = [self getSpritesArrayForModel:model];
            [_spritesDictionary setValue:sprites forKey:key];
        }
    
        //get views frame
        CGRect frame = CGRectMake(model.location.x * _cellSize, model.location.y * _cellSize, model.size.x * _cellSize, model.size.y * _cellSize);
        
        //create view
        CharacterView *view = [[CharacterView alloc] initWithFrame:frame sprites:[_spritesDictionary valueForKey:key] offsets: [model animationOffsets] animationDurations:[model animationDurations]];
        
        //add view to array
        [_characters addObject:view];
        [self addSubview:view];
    }
    
    [self updateCharacterViewsWithModels:models duration:0.0];
}

/*LOADS SPRITE SHEET FOR A CHARACTER, SEPERATES INTO SPRITES AND RETURNS ARRAY*/
-(NSArray<NSArray<UIImage *> *> *)getSpritesArrayForModel:(CharacterModel *)model{
    //load sprite sheet
    NSString *path = [[NSBundle mainBundle] pathForResource:[model spriteSheetName] ofType:@"png"];
    UIImage *spriteSheet = [UIImage imageWithContentsOfFile:path];
    
    //num animation
    int num = [model numberOfAnimations];
    
    //create c array
    NSArray<UIImage *> *animations[num];
    
    int x = 0, y = 0;
    for (int i = 0; i < num; i++) {
        //get animation length and size
        int length = [model animationLengths][i];
        int width = [model animationSizes][i].x;
        int height = [model animationSizes][i].y;
        
        //reset x
        x = 0;
        
        //create c array
        UIImage *images[length];
        for (int j = 0; j < length; j++) {
            //get sprite image and add to c array
            CGRect cropRect = CGRectMake(x, y, width, height);
            CGImageRef image = CGImageCreateWithImageInRect(spriteSheet.CGImage, cropRect);
            images[j] = [UIImage imageWithCGImage:image];
            CGImageRelease(image);
            
            //increment x
            x += width;
        }
        //make nsarray and add it c array
        NSArray<UIImage *> *imagesArray = [NSArray arrayWithObjects:images count:length];
        animations[i] = imagesArray;
        
        //increment y
        y += height;
    }
    //make nsarray
    NSArray<NSArray<UIImage *> *> *animationsArray = [NSArray arrayWithObjects:animations count:num];
    
    return animationsArray;
}

/*PUBLIC UPDATE METHODS*/
-(void)updateCharacterViewsWithModels:(NSMutableArray<CharacterModel *> *)models duration:(float)duration{
    for (int i = 0; i < models.count; i++) {
        CharacterModel *model = models[i];
        CharacterView *view = _characters[i];
        
        //animate view
        if (model.dead) {
            [view playFinalAnimationNumber:model.animationNumber inDirection:model.direction];
        }else if (model.animationOption == LOOP_ANIMATION) {
            [view loopAnimationNumber:model.animationNumber inDirection:model.direction];
        }else if (model.animationOption == PLAY_ANIMATION){
            [view playAnimationNumber:model.animationNumber inDirection:model.direction];
        }
        
        //move view
        CGRect newFrame = CGRectMake(model.location.x * _cellSize, model.location.y * _cellSize, _cellSize, _cellSize);
        if (newFrame.origin.x != view.frame.origin.x || newFrame.origin.y != view.frame.origin.y) {
            [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                view.frame = newFrame;
            }completion:NULL];
        }
    }
    
    //order views
    [self orderViews];
}

/*REMOVE DEAD VIEWS*/
-(void)removeDeadCharacterViewsWithModels:(NSMutableArray<CharacterModel *> *)models{
    for (int i = 1, j = 1; i < models.count; i++, j++) {
        if (models[i].dead) {
            [_characters removeObjectAtIndex:j--];
        }
    }
}

/*ORDERS VIEWS IN SUBVIEW TREE ACCRODING TO THEIR Y VALUE*/
-(void)orderViews{
    //create sorted views list and remove all from superview
    int order[_characters.count];
    for (int i = 0; i < _characters.count; i++) {
        [_characters[i] removeFromSuperview];
        order[i] = i;
    }
    
    //sort views by y index (bubble sort)
    int swap, index1, index2;
    for (int i = 0; i < ( _characters.count - 1 ); i++){
        for (int j = 0; j < _characters.count - i - 1; j++){
            index1 = order[j];
            index2 = order[j+1];
            if (_characters[index1].frame.origin.y > _characters[index2].frame.origin.y){
                swap = order[j];
                order[j] = order[j+1];
                order[j+1] = swap;
            }
        }
    }
    
    //add views in sorted order
    for (int i = 0; i < _characters.count; i++) {
        int j = order[i];
        [self addSubview:_characters[j]];
    }
}

/*BACKGROUND IMAGE (draws tiled images clipped by border rounded rect)*/
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    //rounded rect points
    CGFloat minx = CGRectGetMinX(layer.bounds), midx = CGRectGetMidX(layer.bounds), maxx = CGRectGetMaxX(layer.bounds);
    CGFloat miny = CGRectGetMinY(layer.bounds), midy = CGRectGetMidY(layer.bounds), maxy = CGRectGetMaxY(layer.bounds);
    CGFloat radius = _cornerRadius;
    
    //make rounded rect path
    CGContextMoveToPoint(ctx, minx, midy);
    CGContextAddArcToPoint(ctx, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, radius);
    CGContextClosePath(ctx);
    
    //clip to path
    CGContextClip(ctx);
    
    //draw tiled images
    for (int i = 0; i < _size; i++) {
        for (int j = 0; j < _size; j++) {
            CGContextDrawImage(ctx, CGRectMake(i * _cellSize, j * _cellSize, _cellSize, _cellSize), _tileImage.CGImage);
        }
    }
}

-(CharacterView *)player{
    return _characters[0];
}

@end
