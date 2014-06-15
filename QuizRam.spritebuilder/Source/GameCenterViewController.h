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
@property NSInteger test;

//Scores to generate local ranking
@property (nonatomic) NSArray* survivalTimeScores;
@property (nonatomic) NSMutableArray* pointAnswerScores;
@property (nonatomic) NSMutableArray* capturedBooksScore;
@property (nonatomic) NSMutableArray* rightAnswerScores;
@property (nonatomic) NSMutableArray* wrongAnswersScores;

@property (nonatomic) int value;

-(void)setupGameCenter;
-(void)reportScore;
-(void)retrieveTopScore:(NSString*)leaderborderIdentifier viewIn:(CCLabelTTF*)label inTime:(GKLeaderboardTimeScope)timeScope forPosition:(NSInteger)position; //Download scores of game center
-(void)retrieveLocalPlayerScore:(NSString*)leaderborderIdentifier viewIn:(CCLabelTTF*)label inTime:(GKLeaderboardTimeScope)timeScope;
-(void)updateAchievements;

@end
