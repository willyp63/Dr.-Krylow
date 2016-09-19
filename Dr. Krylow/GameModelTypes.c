//
//  GameModelTypes.c
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/5/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#include "GameModelTypes.h"

IntPoint IntPointMake(int x, int y){
    IntPoint point;
    point.x = x;
    point.y = y;
    
    return point;
}

IntPoint IntPointGetSum(IntPoint point1, IntPoint point2){
    IntPoint point;
    point.x = point1.x + point2.x;
    point.y = point1.y + point2.y;
    
    return point;
}

Direction IntPointDirectionToPoint(IntPoint point1, IntPoint point2){
    if (point1.x == point2.x) {
        if (point1.y > point2.y) {
            return UP;
        }else{
            return DOWN;
        }
    }else{
        if (point1.x > point2.x) {
            return LEFT;
        }else{
            return RIGHT;
        }
    }
}

void IntPointAddPoint(IntPoint *point1, IntPoint point2){
    point1->x += point2.x;
    point1->y += point2.y;
}

int IntPointDistanceBetweenPoints(IntPoint point1, IntPoint point2){
    return abs(point1.x - point2.x) + abs(point1.y - point2.y);
}

int IntPointFitsOnGrid(IntPoint point, int gridSize){
    return (point.x >= 0 && point.x < gridSize && point.y >= 0 && point.y < gridSize);
}

void IntPointMoveInDirection(IntPoint *point, Direction direction, int d){
    switch (direction) {
        case UP:
            point->y -= d;
            break;
            
        case RIGHT:
            point->x += d;
            break;
            
        case DOWN:
            point->y += d;
            break;
            
        case LEFT:
            point->x -= d;
            break;
            
        default:
            break;
    }
}






