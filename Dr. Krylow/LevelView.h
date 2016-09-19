//
//  LevelView.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 10/28/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CharacterModel.h"
#import "CharacterView.h"

@interface LevelView : UIView

@property NSMutableDictionary *spritesDictionary;
@property NSMutableArray<CharacterView *> *characters;
@property CGFloat cellSize;

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth size:(int)size tileImagePath:(NSString *)imagePath;
-(void)addCharacterViewsForModels:(NSMutableArray<CharacterModel *> *)models;

-(void)orderViews;
-(void)updateCharacterViewsWithModels:(NSMutableArray<CharacterModel *> *)models duration:(float)duration;

-(void)removeDeadCharacterViewsWithModels:(NSMutableArray<CharacterModel *> *)models;

-(CharacterView *)player;

@end
