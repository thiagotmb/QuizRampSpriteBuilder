//
//  RankingScene.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/14/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "CCNode.h"
#import "GameCenterViewController.h"

@interface RankingScene : CCNode

@property (nonatomic) GameCenterViewController* gameCenter;

@property (nonatomic) CCNode* clock;
@property (nonatomic) CCNode* right;
@property (nonatomic) CCNode* book;

@property (nonatomic) CCButton* menu;
@property (nonatomic) CCButton* time;
@property (nonatomic) CCButton* point;
@property (nonatomic) CCButton* collectedBooks;

@property (nonatomic) CCLabelTTF* localPlayerAllTimeScore;
@property (nonatomic) CCLabelTTF* localPlayerAllTimePosition;
@property (nonatomic) CCLabelTTF* localPlayerLastWeekScore;
@property (nonatomic) CCLabelTTF* localPlayerLastWeekPosition;
@property (nonatomic) CCLabelTTF* localPlayerTodayScore;
@property (nonatomic) CCLabelTTF* localPlayerTodayPosition;

@property (nonatomic) CCLabelTTF* firstAllTimeScore;
@property (nonatomic) CCLabelTTF* firstAllTimeName;
@property (nonatomic) CCLabelTTF* firstLastWeekScore;
@property (nonatomic) CCLabelTTF* firstLastWeekName;
@property (nonatomic) CCLabelTTF* firstTodayScore;
@property (nonatomic) CCLabelTTF* firstTodayName;

@property (nonatomic) CCLabelTTF* secondAllTimeScore;
@property (nonatomic) CCLabelTTF* secondAllTimeName;
@property (nonatomic) CCLabelTTF* secondLastWeekScore;
@property (nonatomic) CCLabelTTF* secondLastWeekName;
@property (nonatomic) CCLabelTTF* secondTodayScore;
@property (nonatomic) CCLabelTTF* secondTodayName;

@property (nonatomic) CCLabelTTF* thirdAllTimeScore;
@property (nonatomic) CCLabelTTF* thirdAllTimeName;
@property (nonatomic) CCLabelTTF* thirdLastWeekScore;
@property (nonatomic) CCLabelTTF* thirdLastWeekName;
@property (nonatomic) CCLabelTTF* thirdTodayScore;
@property (nonatomic) CCLabelTTF* thirdTodayName;

@property (nonatomic) CCLabelTTF* fourthAllTimeScore;
@property (nonatomic) CCLabelTTF* fourthAllTimeName;
@property (nonatomic) CCLabelTTF* fourthLastWeekScore;
@property (nonatomic) CCLabelTTF* fourthLastWeekName;
@property (nonatomic) CCLabelTTF* fourthTodayScore;
@property (nonatomic) CCLabelTTF* fourthTodayName;

@property (nonatomic) CCLabelTTF* fiveAllTimeScore;
@property (nonatomic) CCLabelTTF* fiveAllTimeName;
@property (nonatomic) CCLabelTTF* fiveLastWeekScore;
@property (nonatomic) CCLabelTTF* fiveLastWeekName;
@property (nonatomic) CCLabelTTF* fiveTodayScore;
@property (nonatomic) CCLabelTTF* fiveTodayName;



-(void)showMenu;
-(void)showTimeRanking;
-(void)showPointRanking;
-(void)showCollectedBooksRanking;

@end
