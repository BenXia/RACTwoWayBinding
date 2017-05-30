//
//  Ben_BallView.m
//  TestProject
//
//  Created by Ben on 5/23/14.
//  Copyright (c) 2014 PPTV. All rights reserved.
//

#import "Ben_BallView.h"
@import QuartzCore;

@implementation Ben_BallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.cornerRadius = MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)) / 2.0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        
        UIImageView *football = [[UIImageView alloc] initWithFrame:self.bounds];
        football.image = [UIImage imageNamed:@"Football"];
        [self addSubview:football];
    }
    return self;
}

@end
