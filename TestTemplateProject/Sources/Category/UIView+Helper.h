//
//  UIView+Helper.h
//  SportCircles
//
//  Created by Ben on 5/15/14.
//  Copyright (c) 2014 PPTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Helper)

+ (NSArray *)sortedViewsOrderByTag:(NSArray *)views;

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)printSubviewsLayout;
- (void)removeSubviews;
- (void)resetAllSubviewsByIncrementOriginX:(CGFloat)incrementOriginX;
- (void)resetAllSubviewsByIncrementWidth:(CGFloat)incrementWidth;
- (void)resetAllSubviewsByIncrementOriginY:(CGFloat)incrementOriginY;
- (void)resetAllSubviewsByIncrementHeight:(CGFloat)incrementHeight;

- (UIImage *)imageByRenderingView;

@end

@interface UIView (SPORTSFrame)

- (CGFloat)originX;
- (CGFloat)originY;
- (CGPoint)origin;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;

- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;
- (void)setOrigin:(CGPoint)origin;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;

- (void)setOriginX:(CGFloat)x originY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

@end
