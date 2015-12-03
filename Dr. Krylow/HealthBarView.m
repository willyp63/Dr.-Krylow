//
//  HealthBarView.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/20/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "HealthBarView.h"

@implementation HealthBarView{
    int _health, _maxHealth;
}

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth maxHealth:(int)maxHealth{
    self = [super initWithFrame:frame];
    if (self) {
        _maxHealth = _health = maxHealth;
        
        //init base layer
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = [UIColor grayColor].CGColor;
        
        //inint health layer
        _healthLayer = [CALayer layer];
        _healthLayer.frame = self.bounds;
        _healthLayer.cornerRadius = cornerRadius;
        _healthLayer.borderWidth = borderWidth;
        _healthLayer.borderColor = [UIColor blackColor].CGColor;
        _healthLayer.backgroundColor = [UIColor greenColor].CGColor;
        [self.layer addSublayer:_healthLayer];
        
        //init health label
        _healthLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _healthLabel.textAlignment = NSTextAlignmentCenter;
        _healthLabel.numberOfLines = 0;
        _healthLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _healthLabel.text = @"100%";
        [self addSubview:_healthLabel];
    }
    return self;
}

-(void)setHealth:(int)health{
    _health = health;
    
    //health = 0
    if (_health < 0) {
        //set frame
        _healthLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        
        //set label
        _healthLabel.text = @"0%";
    }else{
        //set frame
        CGFloat healthWidth = self.bounds.size.width * _health / _maxHealth;
        _healthLayer.frame = CGRectMake(0, 0, healthWidth, self.bounds.size.height);
        
        //set label
        _healthLabel.text = [NSString stringWithFormat:@"%d%%", (_health * 100 / _maxHealth)];
    }
    
    [_healthLabel setNeedsDisplay];
}


@end
