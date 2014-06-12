//
//  MenuScene.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/10/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene
-(void)didLoadFromCCB{
    
    _gameData = [GameData sharedManager];
}

-(void)playGame{
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1];
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"MainScene"] withTransition:transition];
    
}

-(void)showTutorial{
    
    
}

-(void)showRanking{
    _quiz = [QuizScene alloc];
    _quiz.quizScene = [CCBReader loadAsScene:@"QuizScene"];
    [[CCDirector sharedDirector] pause];
    [self addChild:_quiz.quizScene];
}

-(void)resumeScene{
    
}

-(void)update:(CCTime)delta{
    
    if(_gameData.answerSelectined){
            NSLog(@" certo = %d no tempo %.2f",_gameData.correctAnswer, _gameData.timeOfAnswer);
        [self removeChild:_quiz.quizScene cleanup:YES];
        
        _gameData.answerSelectined = NO;
    }
}



@end
