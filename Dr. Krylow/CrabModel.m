//
//  CrabModel.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/22/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "CrabModel.h"

@implementation CrabModel{
    BOOL _resting;
}

//type
static CharacterType _type = CRAB;
-(CharacterType)type{return _type;}


//animation names
typedef enum{
    STANDING_ANIMATION, WALKING_ANIMATION, ATTACKING_ANIMATION, DYING_ANIMATION
}CrabAnimations;

//animation propperties
static NSString *_spriteSheetName = @"crab-01";
static int _numberOfAnimations = 13;

static int _animationLengths[] = {2, 2, 2, 2,
                                4, 4, 4, 4,
                                3, 3, 3, 3,
                                3};

static IntPoint _animationOffsets[] = {{0,-10}, {0,-10}, {0,-10}, {0,-10},
                                        {0,-10}, {0,-10}, {0,-10}, {0,-10},
                                        {0,-70}, {0,-10}, {0,-10}, {-60,-10},
                                        {0,-10}};

static IntPoint _animationSizes[] = {{40,40}, {40,40}, {40,40}, {40,40},
                                    {40,40}, {40,40}, {40,40}, {40,40},
                                    {40,100}, {100,40}, {40,100}, {100,40},
                                    {40,40}};

static double _animationDurations[] = {0.5, 0.5, 0.5, 0.5,
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
        //init status
        _resting = YES;
        
        //init animation state
        self.direction = DOWN;
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = STANDING_ANIMATION;
    }
    
    return self;
}

//update method
-(BOOL)updateWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    CharacterModel *player = characters[0];
    
    //flip resting
    _resting = !_resting;
    
    if (_resting) {
        //loop floating animation
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = STANDING_ANIMATION;
        return YES;
    }
    
    //if player is within 2 spaces
    if (IntPointDistanceBetweenPoints(player.location, self.location) <= 2 &&
        (player.location.x == self.location.x || player.location.y == self.location.y)) {
        
        //set attack animation
        self.animationOption = PLAY_ANIMATION;
        self.animationNumber = ATTACKING_ANIMATION;
        self.direction = IntPointDirectionToPoint(self.location, player.location);
        
        //call collision method
        [player respondToCharacter:self withItem:NO_ITEM table:table];
        
        return YES;
    }else{
        //player walking animation
        self.animationOption = PLAY_ANIMATION;
        self.animationNumber = WALKING_ANIMATION;
        
        //update normally
        return [super updateWithCharacters:characters table:table];
    }
}

//collision method
-(void)respondToCharacter:(CharacterModel *)character withItem:(ItemType)item table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    //if player
    if ([character type] == SCUBA_GUY) {
        //if spear
        if (item == SPEAR) {
            //set death animation
            self.animationOption = PLAY_ANIMATION;
            self.animationNumber = DYING_ANIMATION;
            self.direction = UP;
            
            //die
            self.dead = YES;
        }
    }
}


@end
