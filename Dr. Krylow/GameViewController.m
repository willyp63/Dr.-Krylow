//
//  ViewController.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 10/28/15.
//  Copyright (c) 2015 My Organization. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController


static NSString *initLevelName = @"Level_1-01";
static IntPoint initPlayerLocation = {2, 3};


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //start new game
    [self startNewGameWithLevelName:initLevelName playerLocation:initPlayerLocation];
}


-(void)startNewGameWithLevelName:(NSString *)levelName playerLocation:(IntPoint)playerLocation{
    //stop timer from firing
    if(_gameTimer){ [_gameTimer invalidate];}
    
    //get level file path
    NSString *levelPath = [[NSBundle mainBundle] pathForResource:levelName ofType:@"txt"];
    
    //set up model
    _gameModel = [[GameModel alloc] initWithContentsOfFile:levelPath playerLocation:playerLocation];
    
    //break down ui then set up ui
    [self breakDownUI];
    [self setUpUI];
    
    //start game timer
    [self startTimer];
}


-(void)setUpUI{
    //get screen deminsions
    CGSize deminsions = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    
    //calc level width and height
    int levelViewSize = deminsions.width - 2*BUFFER_SIZE;
    levelViewSize -= levelViewSize % LEVEL_SIZE; //make multiple of LEVEL_SIZE
    
    //calc cell size
    int cellSize = levelViewSize / LEVEL_SIZE;
    
    
    //view frames
    CGRect levelRect = CGRectMake(BUFFER_SIZE, deminsions.height - levelViewSize - BUFFER_SIZE, levelViewSize, levelViewSize);
    CGRect turnTimerRect = CGRectMake(BUFFER_SIZE + levelViewSize/2, statusBarHeight + BUFFER_SIZE, levelViewSize/2, levelViewSize/2);
    CGRect itemSelectRect = CGRectMake(BUFFER_SIZE, levelRect.origin.y - BUFFER_SIZE - cellSize*2, levelViewSize, cellSize);
    CGRect healthBarRect = CGRectMake(BUFFER_SIZE, itemSelectRect.origin.y - BUFFER_SIZE - cellSize, levelViewSize/2, cellSize);
    CGRect quitButtonRect = CGRectMake(BUFFER_SIZE, BUFFER_SIZE + statusBarHeight, levelViewSize/4, cellSize);
    CGRect levelBlockingRect = CGRectMake(0, 0, deminsions.width, itemSelectRect.origin.y + cellSize/2);
    
    
    //resource paths
    NSString *itemImagePath = [[NSBundle mainBundle] pathForResource:@"items-01" ofType:@"png"];
    NSURL *soundUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bitbeat1" ofType:@"mp3"]];
    
    
    //init views
    _levelView = [self getLevelViewWithFrame:levelRect model:_gameModel];
    _turnTimerView = [[TurnTimerView alloc] initWithFrame:turnTimerRect];
    _itemSelectView = [[ItemSelectView alloc] initWithFrame:itemSelectRect cornerRadius:CORNER_RADIUS borderWidth:BORDER_WIDTH numItems:NUM_ITEMS itemImagePath:itemImagePath];
    _healthBarView = [[HealthBarView alloc] initWithFrame:healthBarRect cornerRadius:CORNER_RADIUS borderWidth:BORDER_WIDTH maxHealth:MAX_HEALTH];
    _resetButtonView = [[MenuButtonView alloc] initWithFrame:quitButtonRect cornerRadius:CORNER_RADIUS borderWidth:BORDER_WIDTH text:@"RESET"];
    _levelBlockingView = [[UIView alloc] initWithFrame:levelBlockingRect];
    _levelBlockingView.backgroundColor = [UIColor whiteColor];
    
    //select item
    [_itemSelectView selectItem:_gameModel.playerItem];
    
    
    //init audio player to loop music
    _music = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    _music.numberOfLoops = -1;
    
    
    //add views
    [self.view addSubview:_levelBlockingView];
    [self.view addSubview:_levelView];
    [self.view addSubview:_turnTimerView];
    [self.view addSubview:_itemSelectView];
    [self.view addSubview:_healthBarView];
    [self.view addSubview:_resetButtonView];
    
    //loop music
    [_music play];
    
    
    //tap recognizer
    UITapGestureRecognizer *tapResetButton = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleResetButtonTap:)];
    UITapGestureRecognizer *tapItemSelect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleItemSelectTap:)];
    [_resetButtonView addGestureRecognizer:tapResetButton];
    [_itemSelectView addGestureRecognizer:tapItemSelect];
}

-(LevelView *)getLevelViewWithFrame:(CGRect)frame model:(GameModel *)model{
    //get tile image file path
    NSString *tileImagePath = [[NSBundle mainBundle] pathForResource:model.tileImageName ofType:@"png"];
    
    //set up new level view
    LevelView *levelView = [[LevelView alloc] initWithFrame:frame cornerRadius:CORNER_RADIUS borderWidth:BORDER_WIDTH size:LEVEL_SIZE tileImagePath:tileImagePath];
    
    //add characters
    [levelView addCharacterViewsForModels:model.characters];
    
    //swipe recognizers
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    [swipeUp setDirection:(UISwipeGestureRecognizerDirectionUp)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    [swipeDown setDirection:(UISwipeGestureRecognizerDirectionDown)];
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    //tap recognizer
    UITapGestureRecognizer *tapLevel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLevelTap:)];
    
    //add recognizers
    [levelView addGestureRecognizer:swipeUp];
    [levelView addGestureRecognizer:swipeRight];
    [levelView addGestureRecognizer:swipeDown];
    [levelView addGestureRecognizer:swipeLeft];
    [levelView addGestureRecognizer:tapLevel];
    
    return levelView;
}

-(void)breakDownUI{
    //remove views
    if (_levelBlockingView){ [_levelBlockingView removeFromSuperview];}
    if (_healthBarView){ [_healthBarView removeFromSuperview];}
    if (_itemSelectView){ [_itemSelectView removeFromSuperview];}
    if (_turnTimerView){ [_turnTimerView removeFromSuperview];}
    if (_levelView){ [_levelView removeFromSuperview];}
    if (_resetButtonView){ [_resetButtonView removeFromSuperview];}

    //stop music
    if(_music){ [_music stop];}
}


-(void)handleResetButtonTap:(UITapGestureRecognizer *)recognizer {
    //start new game
    [self startNewGameWithLevelName:initLevelName playerLocation:initPlayerLocation];
}

-(void)handleLevelTap:(UITapGestureRecognizer *)recognizer {
    int item = (int)_gameModel.playerItem;
    
    //get tap location in level view
    CGPoint tapLocation = [recognizer locationInView:_levelView];
    
    //if tap is on right side of level view
    if (tapLocation.x > _levelView.bounds.size.width/2) {
        item++;
    }else{
        item--;
    }
    
    //keep item within range
    if (item >= NUM_ITEMS) {
        item -= NUM_ITEMS;
    }else if(item < 0){
        item += NUM_ITEMS;
    }
    
    //update model
    [_gameModel setPlayerItem:(ItemType)item];
    
    //update ui
    [_itemSelectView selectItem:item];
}

-(void)handleItemSelectTap:(UITapGestureRecognizer *)recognizer {
    //get tap location in level view
    CGPoint tapLocation = [recognizer locationInView:_itemSelectView];
    
    //get space for each item
    int space = _itemSelectView.bounds.size.width / NUM_ITEMS;
    
    //get item based on tap location
    int item = (int)tapLocation.x / space;
    
    //update model
    [_gameModel setPlayerItem:(ItemType)item];
    
    //update ui
    [_itemSelectView selectItem:item];
}


- (void)handleSwipeUp:(UISwipeGestureRecognizer *)recognizer {
    [self handleSwipeWithDirection:UP];
}
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    [self handleSwipeWithDirection:RIGHT];
}
- (void)handleSwipeDown:(UISwipeGestureRecognizer *)recognizer {
    [self handleSwipeWithDirection:DOWN];
}
- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    [self handleSwipeWithDirection:LEFT];
}

-(void)handleSwipeWithDirection:(Direction)direction{
    //do nothing if its not players turn
    if(!_gameModel.playerTurn){
        return;
    }
    
    //stop players turn
    [_gameModel setPlayerTurn: NO];
    [_turnTimerView stopTimer];
    
    //start reset timer to be called after animations finish
    if (_gameTimer){ [_gameTimer invalidate];}
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:RESET_TIME target:self selector:@selector(doneAnimating) userInfo:nil repeats:NO];
    
    //update player
    [_gameModel updatePlayerWithDirection:direction];
    //update characters
    [_gameModel updateCharacters];
    
    //check for level transition
    if([_gameModel player].offLevelDirection != NONE){
        [self transitionLevelInDirection:[_gameModel player].offLevelDirection];
        return;
    }
    
    //animate views
    [_levelView updateCharacterViewsWithModels:_gameModel.characters duration:RESET_TIME];
    
    //update healthbar view
    [_healthBarView setHealth:[_gameModel player].health];
    
    //remove dead characters from view and model
    [_levelView removeDeadCharacterViewsWithModels:_gameModel.characters];
    [_gameModel removeDeadCharacters];
}


-(void)startTimer{
    //start players turn
    [_gameModel setPlayerTurn: YES];
    
    //start timer for player turn
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:TURN_TIME target:self selector:@selector(turnsOver) userInfo:nil repeats:NO];
    
    //start timerViews's animation. Calls animationDidStop when finished animating
    [_turnTimerView startTimerWithDuration:TURN_TIME delegate:self];
}


-(void)doneAnimating{
    //check if player is dead
    if ([_gameModel player].dead) {
        //start new game
        [self startNewGameWithLevelName:initLevelName playerLocation:initPlayerLocation];
        return;
    }
    
    //start timer
    [self startTimer];
}


-(void)turnsOver{
    //make default move for player
    [self handleSwipeWithDirection:NONE];
}

-(void)transitionLevelInDirection:(Direction)direction{
    //stop timer
    if (_gameTimer){ [_gameTimer invalidate];}
    
    
    //get next level file path from old model
    NSString *nextLevelName = _gameModel.adjacentLevels[(int)direction];
    NSString *levelPath = [[NSBundle mainBundle] pathForResource:nextLevelName ofType:@"txt"];
    
    //move player to his location in the new level
    IntPoint newPLayerLocation = _gameModel.player.location;
    IntPointMoveInDirection(&newPLayerLocation, direction, 1 - LEVEL_SIZE);
    [_gameModel.player setLocation:newPLayerLocation];
    
    //set up new game model
    GameModel *newGameModel = [[GameModel alloc] initWithContentsOfFile:levelPath playerLocation:newPLayerLocation];
    
    //copy player properties from old level
    [newGameModel copyPlayerProperties:_gameModel.player];
    
    
    //get frames
    CGRect playerFinalRect = _levelView.player.frame;
    CGRect levelViewFinalRect = _levelView.frame;
    CGRect newLevelViewStartingRect = _levelView.frame;
    CGRect newLevelViewFinalRect = _levelView.frame;
    
    CGFloat levelSize = _levelView.frame.size.width + BUFFER_SIZE;
    switch (direction) {
        case UP:
            playerFinalRect.origin.y += _levelView.cellSize * (LEVEL_SIZE - 1);
            levelViewFinalRect.origin.y += levelSize;
            newLevelViewStartingRect.origin.y -= levelSize;
            break;
        case RIGHT:
            playerFinalRect.origin.x -= _levelView.cellSize * (LEVEL_SIZE - 1);
            levelViewFinalRect.origin.x -= levelSize;
            newLevelViewStartingRect.origin.x += levelSize;
            break;
        case DOWN:
            playerFinalRect.origin.y -= _levelView.cellSize * (LEVEL_SIZE - 1);
            levelViewFinalRect.origin.y -= levelSize;
            newLevelViewStartingRect.origin.y += levelSize;
            break;
        case LEFT:
            playerFinalRect.origin.x += _levelView.cellSize * (LEVEL_SIZE - 1);
            levelViewFinalRect.origin.x += levelSize;
            newLevelViewStartingRect.origin.x -= levelSize;
            break;
        default:
            break;
    }
    
    
    //set up new level view
    LevelView *newLevelView = [self getLevelViewWithFrame:newLevelViewStartingRect model:newGameModel];
    
    //save reference to new player view
    CharacterView *newPlayerView = newLevelView.player;
    
    //remove new player view
    [newPlayerView removeFromSuperview];
    [newLevelView.characters removeObjectAtIndex:0];
    
    //add all other character views from old to new level
    for(int i = 0; i < _levelView.characters.count; i++){
        CharacterView *oldLevelView = _levelView.characters[i];
        
        //remove from old view
        [oldLevelView removeFromSuperview];
        
        //convert rect and add to new view
        oldLevelView.frame = [_levelView convertRect:oldLevelView.frame toView:newLevelView];
        [newLevelView addSubview:oldLevelView];
        
        //add to character array
        [newLevelView.characters addObject:oldLevelView];
    }
    
    //order all views
    [newLevelView orderViews];
    
    //add new level
    [self.view addSubview:newLevelView];
    
    //push level views to back (new in front of old)
    [self.view sendSubviewToBack:newLevelView];
    [self.view sendSubviewToBack:_levelView];
    
    //play walking animation
    [_levelView.player playAnimationNumber:1 inDirection:direction];
    
    //animate level transition and player moving to next level
    [UIView animateWithDuration:RESET_TIME delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        // move player
        _levelView.player.frame = playerFinalRect;
        
        //move new level
        newLevelView.frame = newLevelViewFinalRect;
        
        //move old level
        _levelView.frame = levelViewFinalRect;
        _levelView.alpha = 0.0; // fade out old level
        
    }completion:^(BOOL finished){
        //remove old level characters from new level view
        for(int i = 0; i < _levelView.characters.count; i++){
            [_levelView.characters[i] removeFromSuperview];
            [newLevelView.characters removeObjectAtIndex:newLevelView.characters.count - 1];
        }
        
        //add new player view to new level
        [newLevelView.characters insertObject:newPlayerView atIndex:0];
        [newLevelView addSubview:newPlayerView];
        
        //loop standing animation
        [newLevelView.player loopAnimationNumber:0 inDirection:direction];
        
        //order views
        [newLevelView orderViews];
        
        //remove old level view
        [_levelView removeFromSuperview];
        
        //set reference to new level view and game model
        _levelView = newLevelView;
        _gameModel = newGameModel;
    
        //start timer
        [self startTimer];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
