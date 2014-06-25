//
//  MenuScene.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/10/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "CCNode.h"
#import "RankingScene.h"

@interface MenuScene : CCNode

@property (nonatomic) CCButton* play;
@property (nonatomic) CCButton* tutorial;
@property (nonatomic) CCButton* ranking;
@property (nonatomic) CCNode *soundConfig;

-(void)playGame;
-(void)playTutorial;
-(void)showRanking;



@end
