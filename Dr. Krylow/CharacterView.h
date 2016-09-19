//
//  CharacterView.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameModelTypes.h"

@interface CharacterView : UIView

@property NSArray<NSArray<UIImage *> *> *sprites;
@property UIImageView *imageView;

-(id)initWithFrame:(CGRect)frame sprites:(NSArray<NSArray<UIImage *> *> *)sprites offsets:(IntPoint *)offsets animationDurations:(CGFloat *)durations;

-(void)loopAnimationNumber:(int)number inDirection:(Direction)direction;
-(void)playAnimationNumber:(int)number inDirection:(Direction)direction;
-(void)playFinalAnimationNumber:(int)number inDirection:(Direction)direction;

@end
