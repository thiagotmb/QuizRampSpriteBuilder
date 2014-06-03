//
//  Obstacle.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacles.h"
@implementation Obstacles {
    CCNode *_topPipe;
    CCNode *_bottomPipe;
}

//TOP GROUND MAXIMUM POSITION ON SCREEN -100 MINIMUM -160
//GROUNDS DISTANCE MAX 240


// visibility on a 3,5-inch iPhone ends a 88 points and we want some meat
static const CGFloat minimumYPositionTopPipe = 100.f;
// visibility ends at 480 and we want some meat
static const CGFloat maximumYPositionBottomPipe = 0.f;
// distance between top and bottom pipe
static const CGFloat pipeDistance = 240.f;
// calculate the end of the range of top pipe
static const CGFloat maximumYPositionTopPipe = maximumYPositionBottomPipe - pipeDistance;

- (void)setupRandomPosition {
    // value between 0.f and 1.f
    int random = 100 + arc4random()% + (160-100);
    CGFloat range = maximumYPositionTopPipe - minimumYPositionTopPipe;
    _topPipe.position = ccp(_topPipe.position.x, -random);
    _bottomPipe.position = ccp(_bottomPipe.position.x, _topPipe.position.y + pipeDistance);
}
@end