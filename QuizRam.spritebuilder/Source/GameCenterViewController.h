//
//  GameCenterViewController.h
//  QuizRam
//
//  Created by Everton Rider on 6/13/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//
//This class controll the Game Center, Login, submit and download scores and archievements

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameData.h"


@interface GameCenterViewController : UIViewController<UIActionSheetDelegate, GKGameCenterControllerDelegate, UITableViewDataSource>


@property (nonatomic) GameData *gameData;

@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) UIViewController* gameCenter;
@property (nonatomic) BOOL readyToLogin;
@property (nonatomic, strong) NSString *leaderboardIdentifier;

//Scores to generate local ranking
@property (nonatomic) NSArray* survivalTimeScores;
@property (nonatomic) NSArray* pointAnswerScores;
@property (nonatomic) NSArray* capturedBooksScore;
@property (nonatomic) NSArray* rightAnswerScores;
@property (nonatomic) NSArray* wrongAnswersScores;


-(void)setupGameCenter;
-(void)reportScore;
-(void)retrieveTopTenScores:(NSArray*)localLeaderbordArray withIdentifier:(NSString*)leaderborderIdentifier; //Download scores of game center
-(void)updateAchievements;

@end
