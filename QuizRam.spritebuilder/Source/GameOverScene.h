//
//  GameOverScene.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/12/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "CCNode.h"
#import "GameData.h"
#import "GameCenterViewController.h"

@interface GameOverScene : CCNode


@property (nonatomic) GameCenterViewController* gameCenter;
@property (nonatomic) GameData *gameData;
@property (nonatomic) CCLabelTTF *instantTimeScore;
@property (nonatomic) CCLabelTTF *instantAnswerScore;
@property (nonatomic) CCLabelTTF *instantCollectedBooksScore;

@property (nonatomic) CCLabelTTF *bestTimeScore;
@property (nonatomic) CCLabelTTF *bestAnswerScore;
@property (nonatomic) CCLabelTTF *bestCollectedBooksScore;

@property (nonatomic) CCButton *restartButton;
@property (nonatomic) CCButton *menuButton;

-(void)setupScores;
-(void)restartGame;
-(void)showMenu;



@end
