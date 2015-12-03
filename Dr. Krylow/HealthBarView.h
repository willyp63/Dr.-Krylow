//
//  HealthBarView.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/20/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthBarView : UIView

@property CALayer *healthLayer;
@property UILabel *healthLabel;

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth maxHealth:(int)maxHealth;

-(void)setHealth:(int)health;

@end
