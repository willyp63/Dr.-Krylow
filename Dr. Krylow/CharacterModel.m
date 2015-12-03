//
//  CharacterModel.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/1/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import "CharacterModel.h"

@implementation CharacterModel

//static update properties
static CharacterType _type = 0;
static int _numberOfPossibleMoves = 4;
static IntPoint _possibleMoves[] = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};

-(id)initWithLocation:(IntPoint)location{
    self = [super init];
    if (self) {
        _location = location;
        _size = IntPointMake(1, 1);
        _direction = UP;
        
        _animationOption = LOOP_ANIMATION;
        _animationNumber = 0;
        
        _dead = NO;
    }
    return self;
}


-(BOOL)updateWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    /*TRY ALL POSSIBLE MOVES AND TAKE ONE IF IT MOVES YOU CLOSER TO PLAYER*/
    
    //get player and calc dist to player
    CharacterModel *player = characters[0];
    int currentDist = IntPointDistanceBetweenPoints(_location, player.location);
    
    //test all possible moves and select the best
    IntPoint *bestMove = NULL;
    if (arc4random()%2 == 0) {
        for (int i = 0; i < [self numberOfPossibleMoves]; i ++) {
            //get new location for move
            IntPoint newLocation = IntPointGetSum(_location, [self possibleMoves][i]);
        
            //make sure location is on grid and is not occupied
            if (!IntPointFitsOnGrid(newLocation, LEVEL_SIZE) || table[newLocation.x][newLocation.y] != nil) {
                continue;
            }
        
            //check if new dist is less than the current one
            int newDist = IntPointDistanceBetweenPoints(newLocation, player.location);
            if (newDist < currentDist) {
                //make this move the new best move
                bestMove = &[self possibleMoves][i];
                currentDist = newDist;
            }
        }
    }else{
        for (int i = [self numberOfPossibleMoves] - 1; i >= 0; i --) {
            //get new location for move
            IntPoint newLocation = IntPointGetSum(_location, [self possibleMoves][i]);
            
            //make sure location is on grid and is not occupied
            if (!IntPointFitsOnGrid(newLocation, LEVEL_SIZE) || table[newLocation.x][newLocation.y] != nil) {
                continue;
            }
            
            //check if new dist is less than the current one
            int newDist = IntPointDistanceBetweenPoints(newLocation, player.location);
            if (newDist < currentDist) {
                //make this move the new best move
                bestMove = &[self possibleMoves][i];
                currentDist = newDist;
            }
        }
    }
    
    //check if a move was found
    if (bestMove != NULL) {
        //get direction
        IntPoint newLocation = IntPointGetSum(_location, *bestMove);
        if (newLocation.x == _location.x) {
            if (newLocation.y > _location.y) {
                _direction = DOWN;
            }else{
                _direction = UP;
            }
        }else{
            if (newLocation.x > _location.x) {
                _direction = RIGHT;
            }else{
                _direction = LEFT;
            }
        }
        
        //make move
        IntPointAddPoint(&_location, *bestMove);
        return YES;
    }else{
        return NO;
    }
}

-(void)respondToCharacter:(CharacterModel *)character withItem:(ItemType)item table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    //do nothing
}

//static update properties
-(CharacterType)type{
    return _type;
}
-(int)numberOfPossibleMoves{
    return _numberOfPossibleMoves;
}
-(IntPoint *)possibleMoves{
    return _possibleMoves;
}

//static animation properties
-(NSString *)spriteSheetName{
    return nil;
}
-(int)numberOfAnimations{
    return 0;
}
-(int *)animationLengths{
    return nil;
}
-(IntPoint *)animationOffsets{
    return nil;
}
-(IntPoint *)animationSizes{
    return nil;
}
-(double *)animationDurations{
    return nil;
}

@end
