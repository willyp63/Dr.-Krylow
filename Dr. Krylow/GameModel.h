//
//  GameModel.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 10/28/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CharacterModel.h"

#import "ScubaGuyModel.h"
#import "SquidModel.h"
#import "WallModel.h"
#import "CrabModel.h"
#import "ScubaPodModel.h"
#import "ChestModel.h"

@interface GameModel : NSObject


@property NSMutableArray<CharacterModel *> *characters;

@property ItemType playerItem;
@property BOOL playerTurn;

@property NSArray<NSString *> *adjacentLevels;
@property NSString *tileImageName;


-(id)initWithContentsOfFile:(NSString *)filePath playerLocation:(IntPoint)playerLocation;

-(void)updatePlayerWithDirection:(Direction)direction;
-(void)updateCharacters;

-(void)removeDeadCharacters;

-(void)copyPlayerProperties:(ScubaGuyModel *)player;

-(ScubaGuyModel *)player;


@end
