//
//  SquidModel.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/17/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "SquidModel.h"

@implementation SquidModel{
    BOOL _resting;
}

//type
static CharacterType _type = SQUID;
-(CharacterType)type{return _type;}

//animation names
typedef enum{
    FLOATING_ANIMATION, ATTACKING_ANIMATION, DYING_ANIMATION
}SquidAnimations;

//animation propperties
static NSString *_spriteSheetName = @"squid-01";
static int _numberOfAnimations = 9;

static int _animationLengths[] = {2, 2, 2, 2,
                                3, 3, 3, 3,
                                3};

static IntPoint _animationOffsets[] = {{0,-10}, {0,-10}, {0,-10}, {0,-10},
                                        {0,-30}, {0,-10}, {0,-10}, {-20,-10},
                                        {0,-10}};

static IntPoint _animationSizes[] = {{40,40}, {40,40}, {40,40}, {40,40},
                                    {40,60}, {60,40}, {40,60}, {60,40},
                                    {40,40},};

static double _animationDurations[] = {0.5, 0.5, 0.5, 0.5,
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
        self.animationNumber = FLOATING_ANIMATION;
    }
    
    return self;
}


-(BOOL)updateWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    CharacterModel *player = characters[0];
    
    //flip resting
    _resting = !_resting;
    
    if (_resting) {
        //loop floating animation
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = FLOATING_ANIMATION;
        return YES;
    }
    
    //if player is ajacent
    if (IntPointDistanceBetweenPoints(player.location, self.location) <= 1) {
        //play attack animation
        self.animationOption = PLAY_ANIMATION;
        self.animationNumber = ATTACKING_ANIMATION;
        self.direction = IntPointDirectionToPoint(self.location, player.location);
        
        //call collision method
        [player respondToCharacter:self withItem:-1 table:table];
        
        return YES;
    }else{
        //loop floating animation
        self.animationOption = LOOP_ANIMATION;
        self.animationNumber = FLOATING_ANIMATION;
        
        //update normally
        return [super updateWithCharacters:characters table:table];
    }
}


-(void)respondToCharacter:(CharacterModel *)character withItem:(ItemType)item table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    //if player
    if ([character type] == SCUBA_GUY) {
        //if spear
        if (item == SPEAR) {
            //play death animation
            self.animationOption = PLAY_ANIMATION;
            self.animationNumber = 2;
            self.direction = UP;
            
            //die
            self.dead = YES;
        }
    }
}

@end
