//
//  GameModel.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 10/28/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import "GameModel.h"

@implementation GameModel{
    CharacterModel *_characterTable[LEVEL_SIZE][LEVEL_SIZE];
}


-(id)initWithContentsOfFile:(NSString *)filePath playerLocation:(IntPoint)playerLocation{
    self = [super init];
    if (self) {
        _playerItem = 0; //first item
        _playerTurn = NO;
        
        //init characters
        _characters = [[NSMutableArray alloc] initWithCapacity:LEVEL_SIZE*LEVEL_SIZE];
        
        //init empty characterTable
        for (int i = 0; i < LEVEL_SIZE; i++) {
            for (int j = 0; j < LEVEL_SIZE; j++) {
                _characterTable[i][j] = nil;
            }
        }
        
        //init and add player
        ScubaGuyModel *player = [[ScubaGuyModel alloc] initWithLocation:playerLocation];
        [_characters addObject:player];
        _characterTable[playerLocation.x ][playerLocation.y] = player;
        
        //spereate file into lines
        NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *lines = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        //get tile image name from first line
        _tileImageName = lines[0];
        
        //get adjacent levels from next 4 lines
        _adjacentLevels = [NSArray arrayWithObjects:lines[1], lines[2], lines[3], lines[4], nil];
        
        //add a character for each remaining line
        for (int i = 5; i < lines.count; i++) {
            //seperate line into words
            NSString *line = lines[i];
            NSArray *words = [line componentsSeparatedByString:@" "];
            
            //read type and location from words
            int type = [words[0] intValue];
            IntPoint location = IntPointMake([words[1] intValue], [words[2] intValue]);
            
            //init character model
            CharacterModel *model;
            switch (type) {
                case SQUID:
                    model = [[SquidModel alloc] initWithLocation:location];
                    break;
                    
                case WALL:
                    model = [[WallModel alloc] initWithLocation:location spriteSheetNumber:[words[3] intValue]
                                                animationNumber:[words[4] intValue]];
                    break;
                    
                case CRAB:
                    model = [[CrabModel alloc] initWithLocation:location];
                    break;
                    
                case SCUBA_POD:
                    model = [[ScubaPodModel alloc] initWithLocation:location];
                    break;
                    
                case CHEST:
                    model = [[ChestModel alloc] initWithLocation:location];
                    break;
                    
                default:
                    break;
            }
            
            
            if (model != nil) {
                //add character model
                [_characters addObject:model];
                [self addCharacterToTable:model];
            }
        }
    }
    return self;
}


-(void)updatePlayerWithDirection:(Direction)direction{
    ScubaGuyModel *player = (ScubaGuyModel *)_characters[0];
    
    //clear location in table
    [self removeCharacterFromTable:player];
    
    
    //call appropriate update method
    switch (_playerItem) {
        case SHOES:
            [player walkWithCharacters:_characters table:_characterTable direction:direction];
            break;
            
        case SPEAR:
            [player spearWithCharacters:_characters table:_characterTable direction:direction];
            break;
            
        default:
            break;
    }
    
    //set location in table
    [self addCharacterToTable:player];
}


-(void)updateCharacters{
    //holds characters that did not update the first time
    NSMutableArray<CharacterModel *> *reupdateList = [[NSMutableArray alloc] initWithCapacity:_characters.count];
    
    //update characters
    for (int i = 0; i < _characters.count; i++) {
        CharacterModel *character = _characters[i];
        
        //continue if character is dead
        if (character.dead) {
            continue;
        }
        
        //clear location in table
        [self removeCharacterFromTable:character];
        
        //try to update character and add to list if it did not update
        if (![character updateWithCharacters:_characters table:_characterTable]) {
            [reupdateList addObject:character];
        }
        
        //set location in table
        [self addCharacterToTable:character];
    }
    
    //update characters that did not update the first time
    for (int i = 0; i < reupdateList.count; i++) {
        CharacterModel *character = reupdateList[i];
        
        //clear location in table
        [self removeCharacterFromTable:character];
        
        //update
        [character updateWithCharacters:_characters table:_characterTable];
        
        //set location in table
        [self addCharacterToTable:character];
    }
}


-(void)removeDeadCharacters{
    for (int i = 1; i < _characters.count; i++) {
        if (_characters[i].dead) {
            [self removeCharacterFromTable:_characters[i]];
            [_characters removeObjectAtIndex:i--];
        }
    }
}

-(void)removeCharacterFromTable:(CharacterModel *)character{
    for (int x = character.location.x; x < character.location.x + character.size.x; x++) {
        for (int y = character.location.y; y < character.location.y + character.size.y; y++) {
            _characterTable[x][y] = nil;
        }
    }
}

-(void)addCharacterToTable:(CharacterModel *)character{
    for (int x = character.location.x; x < character.location.x + character.size.x; x++) {
        for (int y = character.location.y; y < character.location.y + character.size.y; y++) {
            _characterTable[x][y] = character;
        }
    }
}

-(void)copyPlayerProperties:(ScubaGuyModel *)player{
    self.player.location = player.location;
    self.player.direction = player.direction;
    self.player.health = player.health;
    self.player.animationOption = player.animationOption;
    self.player.animationNumber = player.animationNumber;
}


-(ScubaGuyModel *)player{
    return (ScubaGuyModel *)[_characters objectAtIndex:0];
}

@end