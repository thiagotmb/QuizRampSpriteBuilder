//
//  MainScene.m
//  QuizRam
//
//  Created by Thiago


#import "MainScene.h"
#import "CCParallaxNode-Extras.h"




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

    [self updateAnswerBook];

}
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [self heroJump];
    
}

-(void)setup{
    
    
    [self setupScene];
    
    [self setupSwipes];
    
    [self setupGrounds];
    
    [self setupHero];

    [self setupAnswerBook];
    
    
}
-(void)setupGameCenter{
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"";
    //Chamar o authenticateLocalPlayer
    //EVERTON
    [self authenticateLocalPlayer];
    
}
-(void)setupScene{
    _physicsNode.collisionDelegate = self;
    _physicsNode.debugDraw = NO;
    _physicsNode.iterations = 100;
    
    self.userInteractionEnabled = YES;
    _gravityY = -500;
    _scrollSpeed = 200;
    _physicsNode.gravity = ccp(0, _gravityY);
    
    _screenLimitDown.physicsBody.sensor = YES;
    _screenLimitDown.physicsBody.collisionType = @"screenDown";
    _screenLimitLeft.physicsBody.sensor = YES;
    _screenLimitLeft.physicsBody.collisionType = @"screenLeft";
    
    _timeInGame = 0;
    _capturedBooks = 0;
    _gravityTimer = 1;

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
    
    _gameTimeCount = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(countTimeinGame:) userInfo:nil repeats:YES];

    
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
    
}
-(void)setupAnswerBook{
    
        _answerBookBlue.zOrder = DrawingOrderGround;
        _answerBookBlue.physicsBody.collisionType = @"answerBook";
        _answerBookBlue.physicsBody.sensor = YES;
    
}

-(void)updateScene:(CCTime)delta{
    _hero.position = ccp(_hero.position.x + delta * _scrollSpeed, _hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (_scrollSpeed *delta), _physicsNode.position.y);
    _screenLimitLeft.position = ccp(_screenLimitLeft.position.x + (_scrollSpeed * delta), _screenLimitLeft.position.y);
    _screenLimitDown.position = ccp(_screenLimitDown.position.x + (_scrollSpeed * delta), _screenLimitDown.position.y);
    
        //Update Parallax background
    _backgroundNode.position = ccp(_backgroundNode.position.x - (_scrollSpeed *delta), _backgroundNode.position.y);
    
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
-(void)updateAnswerBook{

    
        
        CGPoint bookWolrdPosition = [_physicsNode convertToWorldSpace:_answerBookBlue.position];
        CGPoint bookScreenPosition = [self convertToNodeSpace:bookWolrdPosition];
        
        // if the left corner is one complete width off the screen, move it to the right
        if (bookScreenPosition.x <= (-self.boundingBox.size.width)){
            NSLog(@"2ok");
            int random = 100 + arc4random() % (200 - 100);
            if(random == 150){
                CCNode *groundDown =  [_groundsDown objectAtIndex:1];
                _answerBookBlue.visible = YES;
                _answerBookBlue.position = ccp(groundDown.position.x+_groundRandomPositionX + self.boundingBox.size.width, _groundRandomPositionY);
            }
        }
        

}



-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDown:(CCNode *)groundDown {
    
    [_heroAnimation runAnimationsForSequenceNamed:@"Run"];

    
    if(_gravityY < 0){
        _heroIsJumping=NO;
        _numberOfJumps = 0;

    }
    
    return YES;
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundUp {
    
    [_heroAnimation runAnimationsForSequenceNamed:@"Run"];

    
    if(_gravityY > 0){
        _heroIsJumping=YES;
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
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDownSpecial:(CCNode *)groundDownSpecial {
    
    [_heroAnimation runAnimationsForSequenceNamed:@"Run"];

    if(_gravityY < 0){
        _heroIsJumping=NO;
        _numberOfJumps = 0;
    }
    return YES;
    
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero answerBook:(CCNode *)answerBook{
    
    _answerBookBlue.visible = NO;
    _capturedBooks++;
    
    return YES;
    
}

//Autenticar o jogador
//EVERTON
-(void)authenticateLocalPlayer{
    //Pega o usuario que esta jogando no GameCenter
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    /*
     Parametros do bloco
     The first one regards a view controller, which actually is the login
     view controller that will automatically appear if the user is not already authenticated.
     O segundo é o ponteiro de erro.
     */
    //EVERTON
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        /*
         Se não for nulo o usuario nao está autenticado
         */
        //EVERTON
        if (viewController != nil) {
            [[CCDirector sharedDirector] presentViewController:viewController animated:YES completion:nil];
        }else{
            /*
             Se se o jogador esta autenticado sera feita duas coias.
             1- Para poder usar os recursos do Game Center, simplismente alterando gameCenterEnable
             para sim.
             2- Pegar o identificador do laederboard que foi criado anteriomente.
             Nao foi usado direto no leaderboard ID pois o metodo loadDefaultLeaderboardIdentifierWithCompletionHandler é mais formal e correto.
             */
            //EVERTON

            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled=YES;
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier,NSError *error){
                    /*
                     Se der erro no proximo if, sera mandado o NSError para o terminal.
                     Se nao vamos manter o leaderboardIdentifier
                     */
                    if(error!=nil){
                        NSLog(@"%@",[error localizedDescription]);
                    }else{
                        _leaderboardIdentifier =leaderboardIdentifier;
                    }
                }];
                /*
                 Se o usuario nao esta autenticado e a view de login é nil simplismente cancela
                 o processo de login e desativa o gameCenterEnable
                 */
            }else{

                _gameCenterEnabled=NO;
            }
        }

    };
    
}
-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY < 0)
        if(_gravityTimer ==500)
            [self heroRotate];
    
}
-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer{
    
    if(_gravityY > 0)
        [self heroRotate];
    
}
-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    
    if(_capturedBooks>0){
        
        _capturedBooks--;
        
        [[CCDirector sharedDirector] pause];
        [self addChild:[CCBReader loadAsScene:@"QuizScene"]];
        
    }
    
}

-(void)countTimeinGame:(NSTimer *)theTime{
    
    if(!_gameOver)
        _timeInGame +=0.001;
    int time = (int)_timeInGame;
    if(time%5 == 0)
        _scrollSpeed +=0.1;
    
    //SETUP BOOT LIFE
    if(_gravityTimer == 0){
        [self heroRotate];
    }
    if(_gravityY<0)
    {
        if(_gravityTimer<500)
            _gravityTimer ++;
    }else{
        if(_gravityTimer>=0){
            _gravityTimer --;
        }
    }
    
    _timeScore.string = [NSString stringWithFormat:@"%.2f",_timeInGame];
    _capturedBooksScore.string = [NSString stringWithFormat:@"%d",_capturedBooks];
    _gravityBootTimer.string = [NSString stringWithFormat:@"%.0f",_gravityTimer/5];

    
}
-(void)randomizeGrounds:(int)random{
    
    if(random >= 25 && random <=75){
        _changedGround = _groundDown3;
        _groundDown3.physicsBody.type = CCPhysicsBodyTypeDynamic;
        _groundDown3.physicsBody.density = 1;
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

-(void)restart{
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];

    
}
-(void)gameEnds{
    if(!_gameOver){

        _scrollSpeed = 0;
        _gameOver = YES;
        [self setupGameCenter];
        [self reportScore];
        _restartButtom.visible = YES;
        _hero.rotation = 180.0f;
        [_hero stopAllActions];
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-2, 2)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
        
        
        
    }
}
-(void)reportScore{
    /*
     Inicializa o GKScore, especificando no init o identificador do Leaderboard que foi
     traga na autenticação.
     
     The GKScore class is responsible for handling any score-related tasks,
     and in here we’ll use just the basics needed to do our job.
     */
    //EVERTON
    GKScore *score =[[GKScore alloc]initWithLeaderboardIdentifier:@"QuizRamScores"];
    /*
     Logo que o objeto local do score foi inicializado é atribuido
     o valor da propriedade o score atual e amazerna na variavel de membro score
     */
    //EVERTON
    score.value=_timeInGame;
    /*
     Depois é invocada a reportScores:withCompletionHandler: metodo statico do GKScore
     o primeiro parametro espera um NSArray, isso permite relatar multiplos scores,
     por isso foi se seta o @[score], assim se cria o NSArray e coloca o score dentro dele,
     e o bloco de erro ira mostrar no terminal qualquer erro que ocorrer
     
     */
    //EVERTON
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error){
        if(error!=nil){
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}

/*
 Atualiza os Achievements
 */
//EVERTON
-(void)updateAchievements{
//    NSString *achievementIdentifier;
//    float progressPercentage=0.0;
//    BOOL progressInLevelAchievement=NO;
//    
//    
//    /*
//     O objeto dessa classe é inicializado informando o AchievementID
//     */
//    //EVERTON
//    GKAchievement *levelAchievement=nil;
//    GKAchievement *scoreAchievement=nil;
//    progressInLevelAchievement = NO;
//    if (_currentAdditionCounter == 0) {
//        if (_level <= 3) {
//            progressPercentage = _level * 100 / 3;
//            achievementIdentifier = @"Achievement_Level3";
//            progressInLevelAchievement = YES;
//        }
//        else if (_level < 6){
//            progressPercentage = _level * 100 / 5;
//            achievementIdentifier = @"Achievement_Level5Complete";
//            progressInLevelAchievement = YES;
//        }
//    }
//    
//    [levelAchievement setShowsCompletionBanner:YES];
//    if (progressInLevelAchievement) {
//        levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
//        levelAchievement.percentComplete = progressPercentage;
//        
//        [levelAchievement setShowsCompletionBanner:YES];
//    }
//    
//    switch (_score) {
//        case 50:
//            progressPercentage = 100;
//            achievementIdentifier = @"Achievement_50Points";
//            break;
//        case 120:
//            progressPercentage=100;
//            achievementIdentifier = @"Achievement_120Points";
//            break;
//            
//        case 180:
//            progressPercentage=100;
//            achievementIdentifier = @"Achievement_180Points";
//            break;
//        default:
//            progressPercentage=0;
//            break;
//    }
//    
//    
//    
//    
//    /*
//     Aqui se coloca um array de achievements para ser parametro do proximo metodo
//     */
//    //EVERTON
//    scoreAchievement.showsCompletionBanner=YES;
//    scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
//    scoreAchievement.percentComplete = progressPercentage;
//    [scoreAchievement setShowsCompletionBanner:YES];
//    
//    NSArray *achievements = (progressInLevelAchievement) ? @[levelAchievement, scoreAchievement] : @[scoreAchievement];
//    
//    /*
//     O metodo reportAchievement:withCompletionHandler: espera um array de GKAchievement
//     */
//    //EVERTON
//    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
//        if (error != nil) {
//            NSLog(@"%@", [error localizedDescription]);
//        }
//    }];
//    
}


@end
