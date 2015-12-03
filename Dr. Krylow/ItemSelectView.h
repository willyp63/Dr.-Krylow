//
//  ItemSelectView.h
//  Dr. Krylow
//
//  Created by Wil Pirino on 11/18/15.
//  Copyright © 2015 My Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemSelectView : UIView

@property CALayer *selectionLayer;

- (id)initWithFrame:(CGRect)frame cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth numItems:(int)numItems itemImagePath:(NSString *)imagePath;

-(void)selectItem:(int)item;

@end
