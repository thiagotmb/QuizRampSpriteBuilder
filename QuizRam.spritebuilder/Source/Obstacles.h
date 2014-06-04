//
//  Obstacle.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Obstacles : CCNode
@property (nonatomic) CCNode *bottomPipe;
- (void)setupRandomPosition;

@end
