//
//  GameData.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//
// This class controls and share game data with all classes of project.

#import "CCNode.h"

@interface GameData : CCNode

@property (nonatomic) CGFloat scrollSceneSpeed;
@property (nonatomic) unsigned int numberOfPlays; //number of player play the game


//Scores of the match
@property (nonatomic) unsigned int lastScoreSurvivalTime;
@property (nonatomic) unsigned int lastScoreCapturedBooks;
@property (nonatomic) unsigned int lastScoreWrongAnswer;
@property (nonatomic) unsigned int lastScoreRightAnswer;
@property (nonatomic) int lastScorePointAnswer;

//Scores of all matchs
@property (nonatomic) int totalScoreSurvivalTime;
@property (nonatomic) unsigned int totalScoreWrongAnswer;
@property (nonatomic) unsigned int totalScoreRightAnswer;
@property (nonatomic) int totalScorePointAnswer;


@property (nonatomic) BOOL isCorrectAnswer; //Verify if player tick the correct answer in Quiz
@property (nonatomic) float timeOfAnswer;

+(id)sharedManager;


@end
