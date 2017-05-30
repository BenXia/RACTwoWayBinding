//
//  Ben_CustomiseView.m
//  TestProject
//
//  Created by Ben on 5/23/14.
//  Copyright (c) 2014 PPTV. All rights reserved.
//

#import "Ben_CustomiseView.h"

@implementation Ben_CustomiseView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self initSubviews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self initSubviews];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* mmFill = [UIColor blackColor];
    
    //// Frames
    CGRect frame = self.bounds;
    
    //// draw step by step
    {
        UIBezierPath* bodyPath = [UIBezierPath bezierPath];
        CGPoint leftPoint = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) * 0.1, CGRectGetMinY(frame) + CGRectGetHeight(frame) * 0.9);
        CGPoint midDownPoint = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) * 0.5, CGRectGetMinY(frame) + CGRectGetHeight(frame) * 0.9);
        CGPoint midTopPoint = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) * 0.5, CGRectGetMinY(frame) + CGRectGetHeight(frame) * 0.1);
        CGPoint rightPoint = CGPointMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) * 0.9, CGRectGetMinY(frame) + CGRectGetHeight(frame) * 0.1);
        
        
        [bodyPath moveToPoint:CGPointMake(leftPoint.x - 2, leftPoint.y + 2)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 2, midDownPoint.y + 2)];
        
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 2, midDownPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 1, midDownPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 1, midDownPoint.y + 0)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 0, midDownPoint.y + 0)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 0, midDownPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x + 1, midDownPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x + 1, midDownPoint.y - 2)];
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x + 2, midDownPoint.y - 2)];
        
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 2, midTopPoint.y + 2)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x - 2, rightPoint.y + 2)];
        
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x - 2, rightPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x - 1, rightPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x - 1, rightPoint.y + 0)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x - 0, rightPoint.y + 0)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x - 0, rightPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x + 1, rightPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x + 1, rightPoint.y - 2)];
        [bodyPath addLineToPoint:CGPointMake(rightPoint.x + 2, rightPoint.y - 2)];
        
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 2, midTopPoint.y - 2)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 2, midTopPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 1, midTopPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 1, midTopPoint.y - 0)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 0, midTopPoint.y - 0)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x + 0, midTopPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x - 1, midTopPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x - 1, midTopPoint.y + 2)];
        [bodyPath addLineToPoint:CGPointMake(midTopPoint.x - 2, midTopPoint.y + 2)];
        
        [bodyPath addLineToPoint:CGPointMake(midDownPoint.x - 2, midDownPoint.y - 2)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x + 2, leftPoint.y - 2)];
        
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x + 2, leftPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x + 1, leftPoint.y - 1)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x + 1, leftPoint.y - 0)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x + 0, leftPoint.y - 0)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x + 0, leftPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x - 1, leftPoint.y + 1)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x - 1, leftPoint.y + 2)];
        [bodyPath addLineToPoint:CGPointMake(leftPoint.x - 2, leftPoint.y + 2)];
        
        [bodyPath closePath];
        
        CGContextSaveGState(context);
        CGContextSetBlendMode(context, kCGBlendModeOverlay);
        [mmFill setFill];
        [bodyPath fill];
        
        CGContextRestoreGState(context);
    }
}

- (void)initSubviews
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 220, 168)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"This is a label's text.";
    label.backgroundColor = [UIColor whiteColor];
    [self addSubview:label];
}

@end
