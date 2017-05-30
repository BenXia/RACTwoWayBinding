//
//  Ben_CradleView.m
//  TestProject
//
//  Created by Ben on 5/23/14.
//  Copyright (c) 2014 PPTV. All rights reserved.
//

#import "Ben_CradleView.h"
#import "Ben_BallView.h"

static const CGFloat kBallOriginCenterX = 15;
static const CGFloat kBallOriginCenterY = 200;
static const CGFloat kBallWidthHeight = 19;

@interface Ben_CradleView () {
    NSArray *_ballBearings;
    UIDynamicAnimator *_animator;
    UIPushBehavior *_userDragBehavior;
}
@end

@implementation Ben_CradleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBallBearings];
        [self applyDynamicBehaviors];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

#pragma mark - Public methods

- (CGPoint)ballCenter
{
    return ((UIView *)_ballBearings[0]).center;
}

- (void)stopPlay
{
    [_animator removeAllBehaviors];
}

- (void)resetStatus
{
    [_animator removeAllBehaviors];
    Ben_BallView *ball = _ballBearings[0];
    ball.center = CGPointMake(kBallOriginCenterX, kBallOriginCenterY);
    
    [self applyDynamicBehaviors];
}

#pragma mark - Private methods

- (void)createBallBearings
{
    NSMutableArray *ballArray = [NSMutableArray array];
    Ben_BallView *ball = [[Ben_BallView alloc] initWithFrame:CGRectMake(0, 0,  kBallWidthHeight, kBallWidthHeight)];
    // Position it correctly
    ball.center = CGPointMake(kBallOriginCenterX, kBallOriginCenterY);
    
    // Pop the ball bearing in the array and add it as a subview
    [ballArray addObject:ball];
    [self addSubview:ball];

    _ballBearings = [NSArray arrayWithArray:ballArray];
}

- (void)applyDynamicBehaviors
{
    // Create the composite behavior. This will contain the different child behaviors
    UIDynamicBehavior *behavior = [[UIDynamicBehavior alloc] init];
    
    // Apply gravity to the ball bearings
    [behavior addChildBehavior:[self createGravityBehaviorForObjects:_ballBearings]];
    
    // Apply collision behavior to the ball bearings
    [behavior addChildBehavior:[self createDynamicItemBehaviorForObjects:_ballBearings]];

    
    // Create the animator
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    // Add the composite behavior
    [_animator addBehavior:behavior];
    
    UIPushBehavior *_pushRightBehavior = [[UIPushBehavior alloc] initWithItems:_ballBearings
                                                                          mode:UIPushBehaviorModeContinuous];
    _pushRightBehavior.pushDirection = CGVectorMake(0.1, 0);
    [_animator addBehavior:_pushRightBehavior];
}

- (UIDynamicBehavior *)createGravityBehaviorForObjects:(NSArray *)objects
{
    // Create a gravity behavior
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:objects];
    gravity.magnitude = 1.0f;
    return gravity;
}

- (UIDynamicBehavior *)createDynamicItemBehaviorForObjects:(NSArray *)objects
{
    // Apply correct dynamic item behavior
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:objects];
    // Elasticity governs the efficiency of the collisions
    itemBehavior.elasticity = 1.0f;
    itemBehavior.allowsRotation = YES;
    itemBehavior.resistance = 0.5f;
    
    return itemBehavior;
}

#pragma mark - UIGestureRecognizer target method

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if(_userDragBehavior) {
        [_animator removeBehavior:_userDragBehavior];
    }
    _userDragBehavior = [[UIPushBehavior alloc] initWithItems:_ballBearings mode:UIPushBehaviorModeInstantaneous];
    [_animator addBehavior:_userDragBehavior];

    // Set the force to be proportional to distance the gesture has moved
    //_userDragBehavior.pushDirection = CGVectorMake([recognizer translationInView:self].x / 3.f, 0);
    _userDragBehavior.pushDirection = CGVectorMake(0, -0.2f);
}

@end
