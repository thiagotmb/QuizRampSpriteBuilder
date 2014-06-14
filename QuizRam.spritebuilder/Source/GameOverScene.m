//
//  GameOverScene.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene

-(void)didLoadFromCCB{
    
    [self setupScores];
}
-(void)setupScores{
    _gameData = [GameData sharedManager];
    _instantTimeScore.string =[NSString stringWithFormat:@"%.2f",_gameData.lastScoreSurvivalTime];
    _instantAnswerScore.string =[NSString stringWithFormat:@"%d",_gameData.lastScorePointAnswer];
    _instantCollectedBooksScore.string =[NSString stringWithFormat:@"%d",_gameData.lastScoreCapturedBooks];
}

-(void)restartGame{
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1];
    CCScene *gameScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
}

-(void)showMenu{
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1];
    CCScene *menuScene = [CCBReader loadAsScene:@"MenuScene"];
    [[CCDirector sharedDirector] replaceScene:menuScene withTransition:transition];
    
}

@end
