//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Obstacles.h"

static const CGFloat firstObstaclePosition = 560.0f;


typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderPipes,
    DrawingOrderGround,
    DrawingOrdeHero
};

@implementation MainScene

- (void)didLoadFromCCB {
    
    [self setup];
}
-(void)onExit{
    NSArray *grs = [[[CCDirector sharedDirector] view] gestureRecognizers];
    
    for (UIGestureRecognizer *gesture in grs){
        if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]){
            [[[CCDirector sharedDirector] view] removeGestureRecognizer:gesture];
        }
    }
}


- (void)update:(CCTime)delta {
    
    [self updateScene:delta];

    [self updateGround];
    
    [self updateObstacle:delta];
}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self heroJump];
    
}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDown:(CCNode *)groundDown {
    
    if(_gravityY < 0){
        _heroIsJumping=NO;
        _numberOfJumps = 0;
    }

    return YES;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundDown {
    
    if(_gravityY > 0){
        _heroIsJumping=NO;
        _numberOfJumps = 0;
    }

    return YES;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero screenDown:(CCNode *)screenDown {
    
    [self gameEnds];

    return YES;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero screenLeft:(CCNode *)screenLeft {
        
    [self gameEnds];
    return YES;
    
}

-(void)restart{
        CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
        [[CCDirector sharedDirector] replaceScene:scene];
    
}

-(void)gameEnds{
    if(!_gameOver){
        
        _scrollSpeed = 0;
        _gameOver = YES;
        _restartButtom.visible = YES;
        _hero.rotation = 90.f;
        [_hero stopAllActions];
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-2, 2)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
        
        
        
    }
}
//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundDown {
//            
//            if(_gravityY > 0){
//                _heroIsJumping=NO;
//                _numberOfJumps = 0;
//            }
//            
//            return YES;
//        }
//-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundDown {
//                
//                if(_gravityY > 0){
//                    _heroIsJumping=NO;
//                    _numberOfJumps = 0;
//                }
//                
//                return YES;
//            }
//
-(void)setup{
    [self setupScene];
    
    [self setupSwipes];
    
    [self setupGrounds];
    
    [self setupHero];
    
    _obstacles = [NSMutableArray array];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    [self spawnNewObstacle];



    
}
-(void)setupScene{
    _physicsNode.debugDraw = YES;
    self.userInteractionEnabled = YES;
    _gravityY = -500;
    _scrollSpeed = 800;
    _physicsNode.gravity = ccp(0, _gravityY);
    _physicsNode.collisionDelegate = self;
    
    _screenLimitDown.physicsBody.sensor = YES;
    _screenLimitDown.physicsBody.collisionType = @"screenDown";
    
    _screenLimitUp.physicsBody.sensor = YES;
    _screenLimitUp.physicsBody.collisionType = @"screenUp";
    
    _screenLimitRight.physicsBody.sensor = YES;
    _screenLimitRight.physicsBody.collisionType = @"screenRight";
    
    _screenLimitLeft.physicsBody.sensor = NO;
    _screenLimitLeft.physicsBody.collisionType = @"screenLeft";
    
    _timeInGame = 0;
    
}
-(void)setupSwipes{
    
    UISwipeGestureRecognizer* swipeUpRecognizer =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleSwipeUp:)];
    [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp]; // seconds
    [[[CCDirector sharedDirector] view]
     addGestureRecognizer:swipeUpRecognizer];
    
    UISwipeGestureRecognizer* swipeDownRecognizer =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleSwipeDown:)];
    [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown]; // seconds
    [[[CCDirector sharedDirector] view]
     addGestureRecognizer:swipeDownRecognizer];
    
}
-(void)setupGrounds{
    
    _groundsDown = @[_groundDown1, _groundDown2];
    _groundsUp = @[_groundUp1, _groundUp2];
    
    for (CCNode *ground in _groundsDown) {
        ground.zOrder = DrawingOrderGround;
        ground.physicsBody.collisionType = @"groundDown";
        ground.physicsBody.sensor = NO;
        
    }
    
    for (CCNode *ground in _groundsUp) {
        ground.zOrder = DrawingOrderGround;
        ground.physicsBody.collisionType = @"groundUp";
        ground.physicsBody.sensor = NO;
        
    }
}
-(void)setupHero{
    _heroIsJumping = NO;
    _hero.physicsBody.collisionType = @"hero";
    _hero.zOrder = DrawingOrdeHero;
    _jumpVelocityY = 200.0f;
    
}

-(void)updateScene:(CCTime)delta{
    _hero.position = ccp(_hero.position.x + delta * _scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    _screenLimitLeft.position = ccp(_screenLimitLeft.position.x + (_scrollSpeed * delta), _screenLimitLeft.position.y);
    _screenLimitRight.position = ccp(_screenLimitRight.position.x + (_scrollSpeed * delta), _screenLimitRight.position.y);
    _screenLimitDown.position = ccp(_screenLimitDown.position.x + (_scrollSpeed * delta), _screenLimitDown.position.y);
    _screenLimitUp.position = ccp(_screenLimitUp.position.x + (_scrollSpeed * delta), _screenLimitUp.position.y);
    
    
    if(!_gameOver)
        _timeInGame++;
    _timeScore.string = [NSString stringWithFormat:@"Time Score: %d",_timeInGame];

    
}
-(void)updateGround{
    [self updateGroundDown];
    [self updateGroundUp];
}

-(void)updateGroundDown{
    for (CCNode *ground in _groundsDown) {
        
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        
        const int maxYPosition = self.boundingBox.size.height/4;
        const int minYPosition = self.boundingBox.size.height - self.boundingBox.size.height*1.4;
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)){
            
            _randomPositionY = minYPosition + arc4random()% + (maxYPosition - minYPosition);

            
            int random = 0 + arc4random() % ( 3 - 0);
            if(random != 2){
                _groundsDown = @[_groundDown2,_groundDown1];
                ground.position = ccp(ground.position.x +  2.2* _groundDown2.contentSize.width, _randomPositionY);

            }else
            {
                _groundsDown = @[_groundDown1,_groundDown2];
                ground.position = ccp(ground.position.x +  2.2* _groundDown1.contentSize.width, _randomPositionY );
            }
        }
        
    }
}
-(void)updateGroundUp{
    for (CCNode *ground in _groundsUp) {
        
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        const int maxYPosition = 450;
        const int minYPosition = 350;
        

        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-ground.scaleX*ground.contentSize.width)){

            _randomPositionY = minYPosition + arc4random()% + (maxYPosition - minYPosition);
            ground.position = ccp(ground.position.x + 1.95*ground.contentSize.width*ground.scaleX , self.boundingBox.size.height*1.1);
            
            
            
        }
    }
}
-(void)updateObstacle:(CCTime)delta{
    //Obstacle
    
        NSMutableArray *offScreenObstacles = nil;
        for (Obstacles *obstacle in _obstacles) {
            
            obstacle.position = ccp(obstacle.position.x - ( _scrollSpeed * delta ), obstacle.position.y);
            CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
            CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];

            if (obstacleScreenPosition.x < -2.2*obstacle.contentSize.width) {
                //CCLOG(@"%f",obstacle.position.x);

                if (!offScreenObstacles) {
                    
                    offScreenObstacles = [NSMutableArray array];
                }
                [offScreenObstacles addObject:obstacle];
            }
        }

        for (CCNode *obstacleToRemove in offScreenObstacles) {
                [obstacleToRemove removeFromParent];
                [_obstacles removeObject:obstacleToRemove];
                [self spawnNewObstacle];

            }

            // for each removed obstacle, add a new one
            // remove the object after spawning a new one, since if there is only one object this logic will not work
    
        

}

-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY < 0)
        [self heroRotate];
    
}
-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY > 0)
        [self heroRotate];
    
}


-(void)heroJump{
    
    if (_numberOfJumps < 2) {
        _heroIsJumping = NO;
    }
    
    if (!_heroIsJumping && _numberOfJumps <= 2) {
        _heroIsJumping = YES;
        [_hero.physicsBody setVelocity:CGPointMake(0,_jumpVelocityY)];
        _numberOfJumps++;
    }
    

}
-(void)heroRotate{
    

    _gravityY = -_gravityY;
    _jumpVelocityY = -_jumpVelocityY;
    _hero.rotation = _hero.rotation-180;
    _hero.scaleX = -_hero.scaleX;
    [self.physicsNode setGravity:CGPointMake(0, _gravityY)];
}
- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleXPosition = previousObstacle.position.x;
    
    if (!previousObstacle) {
        previousObstacleXPosition = firstObstaclePosition;
    }

    CCNode *obstacle = [CCBReader load:@"Obstacles"];
    _distanceBetweenObstacles = 560;
    obstacle.position = ccp(previousObstacleXPosition + _distanceBetweenObstacles, 0);
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
}

@end
