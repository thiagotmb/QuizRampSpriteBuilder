//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Obstacles.h"
#import "CCParallaxNode-Extras.h"

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
    _scrollSpeed = 200;
    _physicsNode.gravity = ccp(0, _gravityY);
    _physicsNode.collisionDelegate = self;
    
    _screenLimitDown.physicsBody.sensor = YES;
    _screenLimitDown.physicsBody.collisionType = @"screenDown";
    _screenLimitLeft.physicsBody.sensor = YES;
    _screenLimitLeft.physicsBody.collisionType = @"screenLeft";
    
    _timeInGame = 0;
    
    //Setup Parallax Background
    _backgroundNode = [CCParallaxNode node];
    [_background1 removeFromParent];
    [_background2 removeFromParent];
    [_background3 removeFromParent];
    [_background4 removeFromParent];
    CGPoint backGround1Speed = ccp(0.15, 0.15);
    CGPoint backGround2Speed = ccp(0.2, 0.2);
    CGPoint backGround3Speed = ccp(1, 1);
    [_backgroundNode addChild:_background1 z:0 parallaxRatio:backGround1Speed positionOffset:ccp(0,_background1.position.y)];
    [_backgroundNode addChild:_background2 z:0 parallaxRatio:backGround1Speed positionOffset:ccp(_background1.boundingBox.size.width,_background2.position.y)];
    [_backgroundNode addChild:_background3 z:1 parallaxRatio:backGround2Speed positionOffset:ccp(0,_background3.position.y)];
    [_backgroundNode addChild:_background4 z:1 parallaxRatio:backGround3Speed positionOffset:ccp(0,_background4.position.y)];
    [self addChild:_backgroundNode z:-1];

    
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
    _changedGround = _groundDown1;
    _groundDown3.physicsBody.collisionType = @"groundDown";

    _groundsDown = @[_changedGround,_groundDown2];
    for (CCNode *ground in _groundsDown) {
        ground.zOrder = DrawingOrderGround;
        ground.physicsBody.collisionType = @"groundDown";
        ground.physicsBody.sensor = NO;
        
    }
    
    _groundsUp = @[_groundUp1, _groundUp2];
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
-(void)setupObstacle{
    
//    for (CCNode* obstacle in _obstacles){
//    obstacle.zOrder = DrawingOrderGround;
//    obstacle.physicsBody.collisionType = @"groundUp";
//    obstacle.physicsBody.sensor = NO;
//    }
} //TO IMPLEMENT

-(void)updateScene:(CCTime)delta{
    _hero.position = ccp(_hero.position.x + delta * _scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    _screenLimitLeft.position = ccp(_screenLimitLeft.position.x + (_scrollSpeed * delta), _screenLimitLeft.position.y);
    _screenLimitDown.position = ccp(_screenLimitDown.position.x + (_scrollSpeed * delta), _screenLimitDown.position.y);
    
    if(!_gameOver)
        _timeInGame++;
    _timeScore.string = [NSString stringWithFormat:@"Time Score: %d",_timeInGame];
    
    
    //Update Parallax background
    CGPoint backgroundScrollVel = ccp(-_scrollSpeed, 0);
    _backgroundNode.position = ccpAdd(_backgroundNode.position, ccpMult(backgroundScrollVel, delta));
    
    NSArray *backgrounds = [NSArray arrayWithObjects:_background1,_background2, nil];
    for (CCSprite *background in backgrounds) {
        if ([_backgroundNode convertToWorldSpace:background.position].x < -background.boundingBox.size.width) {
            [_backgroundNode incrementOffset:ccp(2*background.boundingBox.size.width,0) forChild:background];
        }
    }
    
    NSArray *objects = [NSArray arrayWithObjects:_background3,_background4, nil];
    for (CCSprite *background in objects) {
        if ([_backgroundNode convertToWorldSpace:background.position].x < -background.boundingBox.size.width) {
            [_backgroundNode incrementOffset:ccp(2*self.boundingBox.size.width,0) forChild:background];
        }
    }

    
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
        const int minYPosition = self.boundingBox.size.height - self.boundingBox.size.height*1.1;
        
        const int maxXPosition = 250;
        const int minXPosition = 0;
        
        _groundRandomPositionX = minXPosition + arc4random() % (maxXPosition - minXPosition);
        _groundRandomPositionY = minYPosition + arc4random() % (maxYPosition - minXPosition);
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= -ground.boundingBox.size.width){
            

            int randomLuck = 100 - arc4random() % ( 100 - 0);
            
            if(ground == _groundDown2)
            {
                
                ground.position = ccp(_changedGround.position.x +  _groundRandomPositionX + self.boundingBox.size.width, _groundRandomPositionY);
                [self randomizeGrounds:randomLuck];
            
            }else{
                
                ground.position = ccp(_groundDown2.position.x + _groundRandomPositionX +  self.boundingBox.size.width, _groundRandomPositionY);

            }
            
        }
        
    }
}
-(void)updateGroundUp{
    for (CCNode *ground in _groundsUp) {
        
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
    
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-ground.boundingBox.size.width)){

            ground.position = ccp(ground.position.x + 2.2*self.boundingBox.size.width , ground.position.y);
            
        }
    }
}

-(void)updateObstacle:(CCTime)delta{
    //Obstacle

//        NSMutableArray *offScreenObstacles = nil;
//        for (CCNode *obstacle in _obstacles) {
//
//            NSLog(@"%@",obstacle.physicsBody.collisionType);
//
//            obstacle.position = ccp(obstacle.position.x - ( _scrollSpeed * delta ), obstacle.position.y);
//            CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
//            CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
//
//            if (obstacleScreenPosition.x < -2.2*obstacle.contentSize.width) {
//                //CCLOG(@"%f",obstacle.position.x);
//
//                if (!offScreenObstacles) {
//                    
//                    offScreenObstacles = [NSMutableArray array];
//                }
//                [offScreenObstacles addObject:obstacle];
//            }
//        }
//
//        for (CCNode *obstacleToRemove in offScreenObstacles) {
//                [obstacleToRemove removeFromParent];
//                [_obstacles removeObject:obstacleToRemove];
//                [self spawnNewObstacle];
//
//            }

            // for each removed obstacle, add a new one
            // remove the object after spawning a new one, since if there is only one object this logic will not work
    
        

} //TO IMPLEMENT

-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY < 0)
        [self heroRotate];
    
}
-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY > 0)
        [self heroRotate];
    
}

-(void)randomizeGrounds:(int)random{
    
    if(random >= 25 && random <=75){
        _changedGround = _groundDown3;
        _groundDown3.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _groundDown3.physicsBody.density = 2;
        _groundDown3.physicsBody.affectedByGravity = NO;
        _groundDown3.physicsBody.allowsRotation = NO;
        [_groundDown3.physicsBody setVelocity:CGPointMake(0, 0)];
        _groundsDown = @[_changedGround,_groundDown2];
        
        NSLog(@"random changed %d", random);
    }else{
        
        _changedGround = _groundDown1;
        _groundsDown = @[_changedGround,_groundDown2];
    }
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
    
//    CCNode *previousObstacle = [_obstacles lastObject];
//    CGFloat previousObstacleXPosition = previousObstacle.position.x;
//    
//    if (!previousObstacle) {
//        previousObstacleXPosition = firstObstaclePosition;
//    }
//
//    _obstacle = [CCBReader load:@"Obstacles"];
//    _obstacle.physicsBody.collisionType = @"obstacle";
//    _obstacle.physicsBody.sensor = YES;
//    _distanceBetweenObstacles = 700;
//    _obstacle.position = ccp(previousObstacleXPosition + _distanceBetweenObstacles, 0);
//    [_physicsNode addChild:_obstacle];
//    [_obstacles addObject:_obstacle];
} // TO IMPLEMENT

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


@end
