/*
Created by Rob Mayoff on 3/7/14.
Copyright (c) 2014 Rob Mayoff. All rights reserved.
*/

#import <UIKit/UIKit.h>

@interface SpotlightsView : UIView

@property (nonatomic, strong) UIImage *image;

- (void)addDraggableSpotlightWithCenter:(CGPoint)center radius:(CGFloat)radius;

@end
