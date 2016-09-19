//
//  MenuButtonView.m
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/20/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import "MenuButtonView.h"

@implementation MenuButtonView

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth text:(NSString *)text;{
    self = [super initWithFrame:frame];
    if (self) {
        //init base layer
        self.layer.cornerRadius = cornerRadius;
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.backgroundColor = [UIColor grayColor].CGColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.text = text;
        
        [self addSubview:label];
    }
    return self;
}

@end
