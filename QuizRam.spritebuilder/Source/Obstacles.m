//
//  Obstacle.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacles.h"
@implementation Obstacles
#define ARC4RANDOM_MAX      0x100000000

static const CGFloat maximumYPositionBottomPipe = 440.f;
// distance between top and bottom pipe
static const CGFloat pipeDistance = 142.f;
// calculate the end of the range of top pipe
- (void)setupRandomPosition {
    // value between 0.f and 1.f
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    _bottomPipe.position = ccp(_bottomPipe.position.x, 370);
}
@end