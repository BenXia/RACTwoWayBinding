//
//  UIView+Helper.m
//  SportCircles
//
//  Created by Ben on 5/15/14.
//  Copyright (c) 2014 PPTV. All rights reserved.
//

#import "UIView+Helper.h"

static NSMutableString *prefixStr;

@implementation UIView (Helper)

+ (void)initialize
{
    prefixStr = [NSMutableString stringWithFormat:@""];
}

+ (NSArray *)sortedViewsOrderByTag:(NSArray *)views
{
    return [views sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        NSComparisonResult result = NSOrderedSame;
        
        if (obj1.tag > obj2.tag) {
            result = NSOrderedDescending;
        } else if (obj1.tag < obj2.tag) {
            result = NSOrderedAscending;
        }
        
        return result;
    }];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)printSubviewsLayout
{
    UIView *view = self;
    
    NSLog (@"%@Subview of view: %@ %@", prefixStr, [view class], NSStringFromCGRect(view.frame));
    [prefixStr appendString:@"===="];
    
    for (UIView *subview in view.subviews) {
        NSLog (@"%@subview: %@ %@", prefixStr, [subview class], NSStringFromCGRect(subview.frame));
        
        if ([subview isKindOfClass:[UIButton class]]) {
            NSLog (@"%@>>>>>>target: %@", prefixStr, [(UIButton *)subview allTargets]);
        }
        
        if (subview.subviews.count > 0) {
            [subview printSubviewsLayout];
        }
    }
    
    prefixStr = [NSMutableString stringWithString:[prefixStr substringToIndex:prefixStr.length - 4]];
}

- (void)removeSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)resetAllSubviewsByIncrementOriginX:(CGFloat)incrementOriginX
{
    for (UIView *subview in self.subviews) {
        [subview setOriginX:subview.originX + incrementOriginX];
    }
}

- (void)resetAllSubviewsByIncrementWidth:(CGFloat)incrementWidth
{
    for (UIView *subview in self.subviews) {
        [subview setWidth:subview.width + incrementWidth];
    }
}

- (void)resetAllSubviewsByIncrementOriginY:(CGFloat)incrementOriginY
{
    for (UIView *subview in self.subviews) {
        [subview setOriginY:subview.originY + incrementOriginY];
    }
}

- (void)resetAllSubviewsByIncrementHeight:(CGFloat)incrementHeight
{
    for (UIView *subview in self.subviews) {
        [subview setHeight:subview.height + incrementHeight];
    }
}

- (UIImage *)imageByRenderingView
{
    CGFloat oldAlpha = self.alpha;
    
    self.alpha = 1;
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.alpha = oldAlpha;
    
    return resultingImage;
}

@end


@implementation UIView (SPORTSFrame)

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOriginX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setOriginY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setOriginX:(CGFloat)x originY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = width;
    rect.size.height = height;
    self.frame = rect;
}

@end

