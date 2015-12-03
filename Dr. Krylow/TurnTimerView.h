//
//  TurnTimerView.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/18/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TurnTimerLayer.h"

@interface TurnTimerView : UIView

@property TurnTimerLayer *timerLayer;

-(void)startTimerWithDuration:(CGFloat)duration delegate:(id)delegate;
-(void)stopTimer;

@end
