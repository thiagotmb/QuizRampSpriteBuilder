//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Obstacles.h"

static const CGFloat scrollSpeed = 200.f;
sdsddasds
static const CGFloat firstObstaclePosition = 10.0f;
static const CGFloat distanceBetweenObstacles = 1280;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderPipes,
    DrawingOrderGround,
    DrawingOrdeHero
};

@implementation MainScene {
    
    CCPhysicsNode *_physicsNode;
    
    CCSprite *_hero;
    
    CCNode *_ground1;
    CCNode *_ground2;
    NSArray *_grounds;
    
    NSMutableArray *_obstacles;
    
    NSTimer *jumpTime;

    
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    _physicsNode.debugDraw = NO;
    _physicsNode.gravity = ccp(0, -500);
    
    _grounds = @[_ground1, _ground2];
    
    
    
    _obstacles = [NSMutableArray array];

    
    
    for (CCNode *ground in _grounds) {
        ground.zOrder = DrawingOrderGround;
    }
    [self spawnNewObstacle];
    _hero.zOrder = DrawingOrdeHero;

}
- (void)update:(CCTime)delta {
    
    //Adjust hero speed
    _hero.position = ccp(_hero.position.x + delta * scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    
    //Loop the ground
    
    for (CCNode *ground in _grounds) {
        
    //GROUND SPAWN
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            //ground.position = ccp(ground.position.x + ground.contentSize.width * 3.7, ground.position.y);
        }
    }
    
    
    NSMutableArray *offScreenObstacles = nil;
    for (CCNode *obstacle in _obstacles) {
        obstacle.position = ccp(obstacle.position.x - ( scrollSpeed * delta ), obstacle.position.y);
        CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
        CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];

        if (obstacleScreenPosition.x < -1*obstacle.contentSize.width) {
             CCLOG(@"Destroy Object!");
            
            if (!offScreenObstacles) {
                offScreenObstacles = [NSMutableArray array];
                 [offScreenObstacles addObject:obstacle];
            }
        }
    }
        for (CCNode *obstacleToRemove in offScreenObstacles) {
            [obstacleToRemove removeFromParent];
            [self spawnNewObstacle];
            

            // for each removed obstacle, add a new one
            // remove the object after spawning a new one, since if there is only one object this logic will not work
            [_obstacles removeObject:obstacleToRemove];
        }
    


}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [_hero.physicsBody setVelocity:CGPointMake(0,250.f)];

    
    //if(_hero.position.y < 100)
        //jumpTime = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(jump) userInfo:nil repeats:NO];
    
}



- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        // this is the first obstacle
        previousObstacleXPosition = firstObstaclePosition;
    }
    Obstacles *obstacle = (Obstacles *)[CCBReader load:@"Obstacles"];
    obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
    [obstacle setupRandomPosition];
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
}


@end
