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
static const CGFloat firstObstaclePosition = 10.0f;
static const CGFloat distanceBetweenObstacles = 1280;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderPipes,
    DrawingOrderGround,
    DrawingOrdeHero
};

@implementation MainScene

- (void)didLoadFromCCB {
    
    [self setup];
}
- (void)update:(CCTime)delta {
    
    [self updateHero:delta];

    [self updateGround];
    
    [self updateObstacle:delta];
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self heroJump];
    
}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDown:(CCNode *)groundDown {
    _heroIsJumping=NO;
    _numberOfJumps = 0;
    return YES;
}



-(void)setup{
    [self setupScene];
    
    [self setupGrounds];
    
    [self setupHero];
    
    _obstacles = [NSMutableArray array];
    
}
-(void)setupScene{
    _physicsNode.debugDraw = YES;
    self.userInteractionEnabled = YES;
    _physicsNode.gravity = ccp(0, -500);
    _physicsNode.collisionDelegate = self;
    
}
-(void)setupGrounds{
    _groundsDown = @[_groundDown1, _groundDown2];
    
    for (CCNode *ground in _groundsDown) {
        ground.zOrder = DrawingOrderGround;
        ground.physicsBody.collisionType = @"groundDown";
        ground.physicsBody.sensor = NO;
        
    }
    
}
-(void)setupHero{
    _heroIsJumping = NO;
    _hero.physicsBody.collisionType = @"hero";
    _hero.zOrder = DrawingOrdeHero;
    
}

-(void)updateHero:(CCTime)delta{
    _hero.position = ccp(_hero.position.x + delta * scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
}
-(void)updateGround{
    for (CCNode *ground in _groundsDown) {
        
        //GROUND SPAWN
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {

            //Generate a random Y position
                int randomPositionY = -80 + arc4random()% + (70 - (-80));
            if(randomPositionY < -70)
                randomPositionY = -150;
            
            int randomPositionX = 100 + arc4random()% + (180 - 100);

            ground.position = ccp(ground.position.x +  2* ground.contentSize.width + randomPositionX, randomPositionY);
            


        }
    }
}
-(void)updateObstacle:(CCTime)delta{
    //Obstacle
    {
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
}

-(void)heroJump{
    
    if (_numberOfJumps < 2) {
        _heroIsJumping = NO;
    }
    
    if (!_heroIsJumping && _numberOfJumps <= 2) {
        _heroIsJumping = YES;
        [_hero.physicsBody setVelocity:CGPointMake(0,200.f)];
        _numberOfJumps++;
    }
    

}
- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        // this is the first obstacle
        previousObstacleXPosition = firstObstaclePosition;
    }
    Obstacles *obstacle = (Obstacles *)[CCBReader load:@"Obstacle"];
    obstacle.position = ccp(previousObstacleXPosition + distanceBetweenObstacles, 0);
    [obstacle setupRandomPosition];
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
}

@end
