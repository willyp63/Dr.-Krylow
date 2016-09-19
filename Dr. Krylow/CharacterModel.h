//
//  CharacterModel.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/1/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "GameModelTypes.h"

@interface CharacterModel : NSObject

//status
@property BOOL dead;

//physical properties
@property IntPoint location;
@property IntPoint size;
@property Direction direction;

//animation properties
@property AnimationOption animationOption;
@property int animationNumber;

//static physical properties
-(CharacterType)type;
-(int)numberOfPossibleMoves;
-(IntPoint *)possibleMoves;

//static animation properties
-(NSString *)spriteSheetName;
-(int)numberOfAnimations;
-(int *)animationLengths;
-(IntPoint *)animationOffsets;
-(IntPoint *)animationSizes;
-(double *)animationDurations;


-(id)initWithLocation:(IntPoint)location;

//update method
-(BOOL)updateWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table;

//collision method
-(void)respondToCharacter:(CharacterModel *)character withItem:(ItemType)item table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table;


@end
