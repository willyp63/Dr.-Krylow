//
//  ScubaGuyModel.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/17/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "ScubaGuyModel.h"

@implementation ScubaGuyModel


//type
static CharacterType _type = SCUBA_GUY;
-(CharacterType)type{return _type;}


//animation names
typedef enum{
    STANDING_ANIMATION, WALKING_ANIMATION, SPEARING_ANIMATION, DYING_ANIMATION
}ScubaGuyAnimations;

//animation propperties
static NSString *_spriteSheetName = @"scuba_guy-01";
static int _numberOfAnimations = 17;

static int _animationLengths[] = {2, 2, 2, 2,
                                4, 4, 4, 4,
                                3, 3, 3, 3,
                                3, 3, 3, 3,
                                4};

static IntPoint _animationOffsets[] = {{0,-10}, {0,-10}, {0,-10}, {0,-10},
                                    {0,-10}, {0,-10}, {0,-10}, {0,-10},
                                    {0,-30}, {0,-10}, {0,-10}, {-20,-10},
                                    {0,-10}, {0,-10}, {0,-10}, {0,-10},
                                    {0,-10}};

static IntPoint _animationSizes[] = {{40,40}, {40,40}, {40,40}, {40,40},
                                    {40,40}, {40,40}, {40,40}, {40,40},
                                    {40,60}, {60,40}, {40,60}, {60,40},
                                    {40,40}, {40,40}, {40,40}, {40,40},
                                    {40,40}};

static double _animationDurations[] = {0.5, 0.5, 0.5, 0.5,
                                        0.5, 0.5, 0.5, 0.5,
                                        0.5, 0.5, 0.5, 0.5,
                                        0.5, 0.5, 0.5, 0.5,
                                        0.5};

-(NSString *)spriteSheetName{return _spriteSheetName;}
-(int)numberOfAnimations{return _numberOfAnimations;}
-(int *)animationLengths{return _animationLengths;}
-(IntPoint *)animationOffsets{return _animationOffsets;}
-(IntPoint *)animationSizes{return _animationSizes;}
-(double *)animationDurations{return _animationDurations;}


-(id)initWithLocation:(IntPoint)location{
    self = [super initWithLocation:location];
    if (self) {
        //init health
        _health = MAX_HEALTH;
        
        _offLevelDirection = NONE;
        
        //init animation state
        self.direction = DOWN;
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = STANDING_ANIMATION;
    }
    return self;
}


-(BOOL)walkWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table direction:(Direction)direction{
    
    //default move
    if(direction == NONE){
        //loop default animation and return
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = STANDING_ANIMATION;
        return  YES;
    }
    
    //get new location
    IntPoint newLocation = IntPointMake(self.location.x, self.location.y);
    IntPointMoveInDirection(&newLocation, direction, 1);
    
    //play walk animation
    self.direction = direction;
    self.animationOption = PLAY_ANIMATION;
    self.animationNumber = WALKING_ANIMATION;
    
    if (!IntPointFitsOnGrid(newLocation, LEVEL_SIZE)) {
        if (newLocation.y < 0) {
            _offLevelDirection = UP;
        }else if (newLocation.x >= LEVEL_SIZE) {
            _offLevelDirection = RIGHT;
        }else if (newLocation.y >= LEVEL_SIZE) {
            _offLevelDirection = DOWN;
        }else if (newLocation.x < 0) {
            _offLevelDirection = LEFT;
        }
        
        return  YES;
    }
    
    CharacterModel *character = table[newLocation.x][newLocation.y];
    if (character == nil) {
        //move player
        [self setLocation:newLocation];
    }else{
        //call collision method
        [character respondToCharacter:self withItem:SHOES table:table];
    }
    
    return YES;
}

-(BOOL)spearWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table direction:(Direction)direction{
    
    //default move
    if(direction == NONE){
        //loop default animation and return
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = 0;
        return  YES;
    }

    //get spear location
    IntPoint spearLocation = IntPointMake(self.location.x, self.location.y);
    IntPointMoveInDirection(&spearLocation, direction, 1);
    
    //play spear animation
    self.direction = direction;
    self.animationOption = PLAY_ANIMATION;
    self.animationNumber = SPEARING_ANIMATION;
    
    //is move off grid
    if (!IntPointFitsOnGrid(spearLocation, LEVEL_SIZE)) {
        return YES;
    }
    
    //is there a character at new location
    CharacterModel *character = table[spearLocation.x][spearLocation.y];
    if (character != nil) {
        //call collision method
        [character respondToCharacter:self withItem:SPEAR table:table];
    }
    
    return YES;
}

//update method
-(BOOL)updateWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    return YES;
}

//collision method
-(void)respondToCharacter:(CharacterModel *)character withItem:(ItemType)item table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    
    //if squid
    if ([character type] == SQUID) {
        //take damage
        _health -= 100;
        
        [self checkForDeathWithTable:table];
    }
    //if crab
    else if ([character type] == CRAB) {
        //take damage
        _health -= 250;
            
        [self checkForDeathWithTable:table];
    }
}

-(void)checkForDeathWithTable:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    if (_health <= 0) {
        //play death animation
        self.animationOption = PLAY_ANIMATION;
        self.animationNumber = 4;
        self.direction = UP;
        
        //die
        self.dead = YES;
    }
}


@end
