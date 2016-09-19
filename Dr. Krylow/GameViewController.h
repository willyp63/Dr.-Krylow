//
//  ViewController.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 10/28/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "GameModel.h"

#import "LevelView.h"
#import "TurnTimerView.h"
#import "ItemSelectView.h"
#import "HealthBarView.h"
#import "MenuButtonView.h"


#define BUFFER_SIZE 7.0
#define CORNER_RADIUS 10.0
#define BORDER_WIDTH 2.0

#define TURN_TIME 2.0
#define RESET_TIME 0.5


@interface GameViewController : UIViewController


@property GameModel *gameModel;

@property NSTimer *gameTimer;

@property LevelView *levelView;
@property TurnTimerView *turnTimerView;
@property ItemSelectView *itemSelectView;
@property HealthBarView *healthBarView;
@property MenuButtonView *resetButtonView;
@property UIView *levelBlockingView;

@property AVAudioPlayer *music;


@end

