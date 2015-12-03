//
//  WallModel.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/17/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "CharacterModel.h"

@interface WallModel : CharacterModel

-(id)initWithLocation:(IntPoint)location spriteSheetNumber:(int)spriteSheetNumber animationNumber:(int)animationNumber;

@end
