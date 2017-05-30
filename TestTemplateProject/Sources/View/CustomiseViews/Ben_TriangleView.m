//
//  Ben_TriangleView.m
//  TestProject
//
//  Created by Ben on 5/24/14.
//  Copyright (c) 2014 PPTV. All rights reserved.
//

#import "Ben_TriangleView.h"

@implementation Ben_TriangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addLayerTriangleMask];
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

#pragma mark - Private methods

- (void)addLayerTriangleMask
{
    CGSize size = self.frame.size;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, size.width, 0.0);
    CGPathAddLineToPoint(path, NULL, size.width / 2, size.height);
    CGPathAddLineToPoint(path, NULL, 0.0, 0);
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
}

@end
