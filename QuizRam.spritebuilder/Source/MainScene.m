//
//  MainScene.m
//  QuizRam
//
//  Created by Thiago


#import "MainScene.h"




typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderPipes,
    DrawingOrderGround,
    DrawingOrdeHero
};

static const unsigned int gravityTimeMax = 100;

@implementation MainScene

-(void)didLoadFromCCB {
    
    [self setup];
    
    
}
-(void)onExit{
    NSArray *grs = [[[CCDirector sharedDirector] view] gestureRecognizers];
    
    //List all gestures and dealloc from scene
    for (UIGestureRecognizer *gesture in grs){
        if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]){
            [[[CCDirector sharedDirector] view] removeGestureRecognizer:gesture];
        }
        _gameData.scrollSceneSpeed =300;

    }

    [super onExit];
}

-(void)update:(CCTime)delta {
    

    [self updateScene:delta];
        
    [self updateGround];

    [self updateQuestionBook];

}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self heroJump];
    
}

-(void)setup{
    
    
    [self setupScene];
    
    [self setupSwipes];
    
    [self setupGrounds];
    
    [self setupHero];

    [self setupAnswerBook];
    
    
}

-(void)setupScene{
    _gameData = [GameData sharedManager];
    _gameData.lastScoreSurvivalTime = 0;
    _gameData.lastScoreCapturedBooks = 0;
    _gameData.lastScoreRightAnswer = 0;
    _gameData.lastScoreWrongAnswer = 0;
    _gameData.lastScorePointAnswer = 0;
    _gameData.scrollSceneSpeed = 300;
    _gameData.scrollSceneSpeed = 300;
    
    
    
    _gravityY = -500;
    _physicsNode.gravity = ccp(0, _gravityY);
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = NO;
    _physicsNode.iterations = 100;
    
    self.userInteractionEnabled = YES;
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
    CGPoint backGround1Speed = ccp(0.5, 0.5);
    CGPoint backGround2Speed = ccp(1, 1);
    [_backgroundNode addChild:_background1 z:0 parallaxRatio:backGround1Speed positionOffset:ccp(0,_background1.position.y)];
    [_backgroundNode addChild:_background2 z:0 parallaxRatio:backGround1Speed positionOffset:ccp(_background1.boundingBox.size.width,_background2.position.y)];
    [_backgroundNode addChild:_background3 z:1 parallaxRatio:backGround2Speed positionOffset:ccp(0,_background3.position.y)];
    [_backgroundNode addChild:_background4 z:1 parallaxRatio:backGround2Speed positionOffset:ccp(_background3.boundingBox.size.width,_background4.position.y)];
    [self addChild:_backgroundNode z:-1];
    
    [self schedule:@selector(countTimeinGame:) interval:0.05];

    
}
-(void)setupSwipes{
    
    UISwipeGestureRecognizer* swipeUpRecognizer =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleSwipeUp:)];
    [swipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [[[CCDirector sharedDirector] view]
     addGestureRecognizer:swipeUpRecognizer];
    
    UISwipeGestureRecognizer* swipeDownRecognizer =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleSwipeDown:)];
    [swipeDownRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [[[CCDirector sharedDirector] view]
     addGestureRecognizer:swipeDownRecognizer];
    
    UISwipeGestureRecognizer* swipeRightRecognizer =
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(handleSwipeRight:)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [[[CCDirector sharedDirector] view]
     addGestureRecognizer:swipeRightRecognizer];

    
}
-(void)setupGrounds{
    _changedGround = _groundDown1;
    _groundDown3.physicsBody.collisionType = @"groundDownSpecial";
    
    _lamps = @[_lamp1,_lamp2];
    
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
    _heroAnimation = _hero.userObject;
    
    _heroIsJumping = NO;
    _hero.physicsBody.collisionType = @"hero";
    _hero.zOrder = DrawingOrdeHero;
    _jumpVelocityY = 200.0f;
    
    _gravityTimer = 0;

    CCProgressNode *bound = [CCProgressNode progressWithSprite:_bootTimerSprite];
    bound.type = CCProgressNodeTypeBar;
    bound.scaleX = 5;
    bound.scaleY = 2.2;
    bound.midpoint = ccp(0.0f, 0.0f);
    bound.barChangeRate = ccp(1.0f, 0.0f);
    bound.percentage = 100;
    bound.positionType = CCPositionTypeNormalized;
    bound.position = ccp(0.9f, 0.72f);
    bound.opacity = 0.3;
    
    [self addChild:bound];
    
    
    _bootTimerProgressBar = [CCProgressNode progressWithSprite:_bootTimerSprite];
    _bootTimerProgressBar.type = CCProgressNodeTypeBar;
    _bootTimerProgressBar.scaleX = 6;
    _bootTimerProgressBar.scaleY = 2.2;
    _bootTimerProgressBar.midpoint = ccp(0.0f, 0.0f);
    _bootTimerProgressBar.barChangeRate = ccp(1.0f, 0.0f);
    _bootTimerProgressBar.percentage =_gravityTimer;
    _bootTimerProgressBar.positionType = CCPositionTypeNormalized;
    _bootTimerProgressBar.position = ccp(0.9f, 0.72f);
    
    [self addChild:_bootTimerProgressBar];

    
}
-(void)setupAnswerBook{
    _timeOfSpawnBooks = 0;
    _capturedBooks = 0;
    _questionBookBlue.zOrder = DrawingOrderGround;
    _questionBookBlue.physicsBody.collisionType = @"answerBook";
    _questionBookBlue.physicsBody.sensor = YES;
    
}

-(void)updateScene:(CCTime)delta{
        
    [self updateHero:delta];
    
    _physicsNode.position = ccp(_physicsNode.position.x - (_gameData.scrollSceneSpeed *delta), _physicsNode.position.y);
    
    _screenLimitLeft.position = ccp(_screenLimitLeft.position.x + (_gameData.scrollSceneSpeed * delta), _screenLimitLeft.position.y);
    _screenLimitDown.position = ccp(_screenLimitDown.position.x + (_gameData.scrollSceneSpeed * delta), _screenLimitDown.position.y);
    
    [self updateParallaxBackground:delta];
    

    
    
}
-(void)updateParallaxBackground:(CCTime)delta{
    
    _backgroundNode.position = ccp(_backgroundNode.position.x - (_gameData.scrollSceneSpeed *delta), _backgroundNode.position.y);
    
    NSArray *backgrounds = [NSArray arrayWithObjects:_background1,_background2, nil];
    for (CCSprite *background in backgrounds) {
        if ([_backgroundNode convertToWorldSpace:background.position].x < -background.boundingBox.size.width) {
            [_backgroundNode incrementOffset:ccp(2*background.boundingBox.size.width,0) forChild:background];
        }
    }
    
    NSArray *objects = [NSArray arrayWithObjects:_background3,_background4, nil];
    for (CCSprite *background in objects) {
        if ([_backgroundNode convertToWorldSpace:background.position].x < -background.boundingBox.size.width) {
            [_backgroundNode incrementOffset:ccp(2*background.boundingBox.size.width,0) forChild:background];
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
        
        
        const int maxYPosition = self.boundingBox.size.height/2.5;
        const int minYPosition = self.boundingBox.size.height - self.boundingBox.size.height/1.1;
        
        const int maxXPosition = 300;
        const int minXPosition = 0;
        
        _groundRandomPositionX = minXPosition + arc4random() % (maxXPosition - minXPosition);
        _groundRandomPositionY = minYPosition + arc4random() % (maxYPosition - minXPosition);
        
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= -ground.boundingBox.size.width){
            

            int randomLuck = 100 - arc4random() % ( 100 - 0);
            
            if(ground == _groundDown2)
            {
                
                ground.position = ccp(_changedGround.position.x +  _groundRandomPositionX + self.boundingBox.size.width,_groundRandomPositionY);
                
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
    
    for (CCNode *ground in _lamps) {
        
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-ground.boundingBox.size.width)){
            
            ground.position = ccp(ground.position.x + 2.2*self.boundingBox.size.width , ground.position.y);
        }
    }

}
-(void)updateQuestionBook{

    
        CGPoint bookWolrdPosition = [_physicsNode convertToWorldSpace:_questionBookBlue.position];
        CGPoint bookScreenPosition = [self convertToNodeSpace:bookWolrdPosition];
        
        // if the left corner is one complete width off the screen, move it to the right
        if (bookScreenPosition.x <= (-self.boundingBox.size.width)){
            int randomPosition = 400 + arc4random() % (2000 - 400);
            if(_timeOfSpawnBooks%5 == 0){
                CCNode *groundDown =  [_groundsDown objectAtIndex:1];
                _questionBookBlue.visible = YES;
                _questionBookBlue.position = ccp(groundDown.position.x+_groundRandomPositionX + self.boundingBox.size.width*2 + randomPosition, _groundRandomPositionY);
            }
        }
        

}
-(void)updateHero:(CCTime)delta{
    
    _hero.position = ccp(_hero.position.x + delta * _gameData.scrollSceneSpeed, _hero.position.y);
    

    //update BOOT LIFE
    if(_heroIsJumping)
        _bootReadyToReload = NO;
    
    if (_bootTimerProgressBar.percentage == 100) {
        _bootTimerProgressBar.opacity = 1;
        [_bootTimerProgressBar setColor:[CCColor greenColor]];
    }else{
        _bootTimerProgressBar.opacity = 0.8;
        [_bootTimerProgressBar setColor:[CCColor redColor]];
    }
    
}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDown:(CCNode *)groundDown {
    
    [_heroAnimation runAnimationsForSequenceNamed:@"Run"];
    
    _bootReadyToReload=YES;
    _heroIsJumping=NO;
    _numberOfJumps = 0;
    
    return YES;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundUp {
    
    [_heroAnimation runAnimationsForSequenceNamed:@"Run"];


        _heroIsJumping=YES;
        _numberOfJumps = 1;

    
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
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDownSpecial:(CCNode *)groundDownSpecial {
    
    [_heroAnimation runAnimationsForSequenceNamed:@"Run"];

    if(_gravityY < 0){
        _heroIsJumping=NO;
        _numberOfJumps = 0;
    }
    return YES;
    
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero answerBook:(CCNode *)answerBook{
    
    _questionBookBlue.visible = NO;
    _capturedBooks++;
    _gameData.lastScoreCapturedBooks++;
    return YES;
    
}

//Autenticar o jogador
//EVERTON
-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY < 0)
        if(_gravityTimer ==gravityTimeMax)
            [self heroRotate];
    
}
-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY > 0)
        [self heroRotate];
    
}
-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    
    if(_capturedBooks>0){
        _capturedBooks--;
        [self showQuiz];
    }
    
}

-(void)showQuiz{
    
    _quiz = [QuizScene alloc];
    _quiz.quizScene = [CCBReader loadAsScene:@"QuizScene"];
    [[CCDirector sharedDirector] pause];
    [self addChild:_quiz.quizScene];
    
}

-(void)countTimeinGame:(CCTime )theTime{
    
    

    if(_gravityY<0)
    {
        if(_gravityTimer<gravityTimeMax && _bootReadyToReload==YES){
            _gravityTimer+=5;
            _bootTimerProgressBar.percentage+=5;
        }
        
    }else{
        if(_gravityTimer <= 0){
            [self heroRotate];
        }
        if(_gravityTimer>0){
            _gravityTimer-=5;
            _bootTimerProgressBar.percentage-=5;
        }
    }
    
    //If game no ends increment times
    if(!_gameOver){
        _timeInGame +=theTime*100;
        _timeOfSpawnBooks++;
    }
    _gameData.lastScoreSurvivalTime = _timeInGame;
    
    //Increment scroll speed if passed five seconds
    
    if(_timeInGame%5 == 0){
        _gameData.scrollSceneSpeed +=1;
        
    }
    
    _timeScore.string = [NSString stringWithFormat:@"%d",_timeInGame];
    _capturedBooksScore.string = [NSString stringWithFormat:@"%d",_capturedBooks];
    _gameData.lastScorePointAnswer = _gameData.lastScoreRightAnswer - _gameData.lastScoreWrongAnswer ;
    _scoreAnswers.string = [NSString stringWithFormat:@"%d",_gameData.lastScorePointAnswer];

    
}
//
//@random randomLuck to spawn broken ground
//
-(void)randomizeGrounds:(int)random{
    
    if(random >= 35 && random <=75){
        _changedGround = _groundDown3;
        _groundDown3.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _groundDown3.physicsBody.density = 1;
        _groundDown3.physicsBody.affectedByGravity = NO;
        _groundDown3.physicsBody.allowsRotation = NO;
        [_groundDown3.physicsBody setVelocity:CGPointMake(0, 0)];
        _groundsDown = @[_changedGround,_groundDown2];
        
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
        
        [_heroAnimation runAnimationsForSequenceNamed:@"Jump"];
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


-(void)gameEnds{
    if(!_gameOver){

        _gameData.scrollSceneSpeed = 0;
        _gameOver = YES;
        
        
    
        
        _gameData.lastScoreSurvivalTime = _timeInGame;
        
        [self heroRotate];
        [_hero stopAllActions];
        [_physicsNode stopAllActions];
        [self stopAllActions];
        [self addChild:[CCBReader loadAsScene:@"GameOverScene"]];
        
        
    }
}




@end
