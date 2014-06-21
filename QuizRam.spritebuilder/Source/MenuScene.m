//
//  MenuScene.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/10/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "MenuScene.h"

@implementation MenuScene

-(void)playGame{
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5];
    CCScene *gameScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
    
}

-(void)playTutorial{
    
    NSLog(@"play tutorial");
}

-(void)showRanking{
   
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5];
    CCScene *rankingScene = [CCBReader loadAsScene:@"RankingScene"];
    [[CCDirector sharedDirector] replaceScene:rankingScene withTransition:transition];
}







@end
