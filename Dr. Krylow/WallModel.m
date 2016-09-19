//
//  WallModel.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/17/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "WallModel.h"


@implementation WallModel{
    int _spriteSheetNumber;
}

//type
static CharacterType _type = WALL;
-(CharacterType)type{return _type;}

//animation propperties

static int _numberOfAnimations = 4;
static int _animationLengths[] = {2, 1, 2, 1};
static IntPoint _animationOffsets[] = {{0,-30}, {0,-30}, {0,-30}, {0,-30}};
static IntPoint _animationSizes[] = {{40,60}, {40,60}, {40,60}, {40,60}};
static double _animationDurations[] = {1.0, 1.0, 1.0, 1.0};


-(int)numberOfAnimations{return _numberOfAnimations;}
-(int *)animationLengths{return _animationLengths;}
-(IntPoint *)animationOffsets{return _animationOffsets;}
-(IntPoint *)animationSizes{return _animationSizes;}
-(double *)animationDurations{return _animationDurations;}


-(id)initWithLocation:(IntPoint)location spriteSheetNumber:(int)spriteSheetNumber animationNumber:(int)animationNumber{
    self = [super initWithLocation:location];
    if (self) {
        //set animation number
        self.direction = animationNumber % 4;
        self.animationNumber = animationNumber / 4;
        
        _spriteSheetNumber = spriteSheetNumber;
    }
    return self;
}


-(BOOL)updateWithCharacters:(NSMutableArray<CharacterModel *> *)characters table:(__strong CharacterModel *[LEVEL_SIZE][LEVEL_SIZE])table{
    self.animationOption = DONT_ANIMATE;
    return YES;
}

-(NSString *)spriteSheetName{
    switch (_spriteSheetNumber) {
        case 0:
            return @"sea-walls-01";
            break;
            
        case 1:
            return @"temple-walls-01";
            break;
            
        default:
            return @"";
            break;
    }
}


@end
