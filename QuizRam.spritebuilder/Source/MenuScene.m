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
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:1];
    CCScene *gameScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene withTransition:transition];
    
}

-(void)playTutorial{
    
    
}

-(void)showRanking{
   
}







@end
