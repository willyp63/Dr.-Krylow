//
//  GameModelTypes.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#ifndef GameModelTypes_h
#define GameModelTypes_h

#include "stdlib.h"

#define LEVEL_SIZE 9
#define NUM_ITEMS 2
#define MAX_HEALTH 1000

//direction
typedef enum{
    UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3, NONE = 4
}Direction;

//animationOption
typedef enum{
    LOOP_ANIMATION, PLAY_ANIMATION, DONT_ANIMATE
}AnimationOption;

//itemType
typedef enum{
    NO_ITEM = -1, SHOES = 0, SPEAR = 1
}ItemType;

//characterType
typedef enum{
    SCUBA_GUY = 0, SQUID = 1, WALL = 2, CRAB = 3, SCUBA_POD = 4, CHEST = 5
}CharacterType;

//int point
typedef struct{
    int x;
    int y;
}IntPoint;

IntPoint IntPointMake(int x, int y);

IntPoint IntPointGetSum(IntPoint point1, IntPoint point2);
Direction IntPointDirectionToPoint(IntPoint point1, IntPoint point2);
void IntPointAddPoint(IntPoint *point1, IntPoint point2);
int IntPointDistanceBetweenPoints(IntPoint point1, IntPoint point2);
int IntPointFitsOnGrid(IntPoint point, int gridSize);
void IntPointMoveInDirection(IntPoint *point, Direction direction, int d);


#endif /* GameModelTypes_h */
