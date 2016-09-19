//
//  ScubaGuyModel.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/17/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "CharacterModel.h"

@interface ScubaGuyModel : CharacterModel

@property int health;
@property Direction offLevelDirection;

//update methods
-(BOOL)walkWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table direction:(Direction)direction;

-(BOOL)spearWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table direction:(Direction)direction;

@end
