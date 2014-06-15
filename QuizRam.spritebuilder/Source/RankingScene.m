//
//  RankingScene.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/14/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "RankingScene.h"

@implementation RankingScene

-(void)didLoadFromCCB{
    
    _gameCenter = [[GameCenterViewController alloc] init];
    [_gameCenter setupGameCenter];
    [self showPointRanking];
}

-(void)showMenu{
    
    CCTransition *transition = [CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5];
    CCScene *menuScene = [CCBReader loadAsScene:@"MenuScene"];
    [[CCDirector sharedDirector] replaceScene:menuScene withTransition:transition];
}

-(void)showTimeRanking{
    
    _book.visible = NO;
    _right.visible = NO;
    _clock.visible = YES;
    
    
    [_gameCenter retrieveLocalPlayerScore:@"SurvivalTime" viewIn:_localPlayerAllTimePosition inTime:GKLeaderboardTimeScopeAllTime];
    [_gameCenter retrieveLocalPlayerScore:@"SurvivalTime" viewIn:_localPlayerLastWeekPosition inTime:GKLeaderboardTimeScopeWeek];
    [_gameCenter retrieveLocalPlayerScore:@"SurvivalTime" viewIn:_localPlayerTodayPosition inTime:GKLeaderboardTimeScopeToday];
    _localPlayerAllTimeScore.name = @"TimeScore";
    [_gameCenter retrieveLocalPlayerScore:@"SurvivalTime" viewIn:_localPlayerAllTimeScore inTime:GKLeaderboardTimeScopeAllTime];
    _localPlayerLastWeekScore.name = @"TimeScore";
    [_gameCenter retrieveLocalPlayerScore:@"SurvivalTime" viewIn:_localPlayerLastWeekScore inTime:GKLeaderboardTimeScopeWeek];
    _localPlayerTodayScore.name = @"TimeScore";
    [_gameCenter retrieveLocalPlayerScore:@"SurvivalTime" viewIn:_localPlayerTodayScore inTime:GKLeaderboardTimeScopeToday];

    
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_firstAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:1];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_firstLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:1];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_firstTodayName inTime:GKLeaderboardTimeScopeToday forPosition:1];
    _firstAllTimeScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_firstAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:1];
    _firstLastWeekScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_firstLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:1];
    _firstTodayScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_firstTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:1];



    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_secondAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:2];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_secondLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:2];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_secondTodayName inTime:GKLeaderboardTimeScopeToday forPosition:2];
    _secondAllTimeScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_secondAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:2];
    _secondLastWeekScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_secondLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:2];
    _secondTodayScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_secondTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:2];
    
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_thirdAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:3];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_thirdLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:3];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_thirdTodayName inTime:GKLeaderboardTimeScopeToday forPosition:3];
    _thirdAllTimeScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_thirdAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:3];
    _thirdLastWeekScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_thirdLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:3];
    _thirdTodayScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_thirdTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:3];
    
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fourthAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:4];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fourthLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:4];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fourthTodayName inTime:GKLeaderboardTimeScopeToday forPosition:4];
    _fourthAllTimeScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fourthAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:4];
    _fourthLastWeekScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fourthLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:4];
    _fourthTodayScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fourthTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:4];
    
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fiveAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:5];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fiveLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:5];
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fiveTodayName inTime:GKLeaderboardTimeScopeToday forPosition:5];
    _fiveAllTimeScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fiveAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:5];
    _fiveLastWeekScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fiveLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:5];
    _fiveTodayScore.name = @"TimeScore";
    [_gameCenter retrieveTopScore:@"SurvivalTime" viewIn:_fiveTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:5];
    
}

-(void)showPointRanking{
    _book.visible = NO;
    _right.visible = YES;
    _clock.visible = NO;
    


    
    [_gameCenter retrieveLocalPlayerScore:@"PointAnswer" viewIn:_localPlayerAllTimePosition inTime:GKLeaderboardTimeScopeAllTime];
    [_gameCenter retrieveLocalPlayerScore:@"PointAnswer" viewIn:_localPlayerLastWeekPosition inTime:GKLeaderboardTimeScopeWeek];
    [_gameCenter retrieveLocalPlayerScore:@"PointAnswer" viewIn:_localPlayerTodayPosition inTime:GKLeaderboardTimeScopeToday];
    _localPlayerAllTimeScore.name = @"PointScore";
    [_gameCenter retrieveLocalPlayerScore:@"PointAnswer" viewIn:_localPlayerAllTimeScore inTime:GKLeaderboardTimeScopeAllTime];
    _localPlayerLastWeekScore.name = @"PointScore";
    [_gameCenter retrieveLocalPlayerScore:@"PointAnswer" viewIn:_localPlayerLastWeekScore inTime:GKLeaderboardTimeScopeWeek];
    _localPlayerTodayScore.name = @"PointScore";
    [_gameCenter retrieveLocalPlayerScore:@"PointAnswer" viewIn:_localPlayerTodayScore inTime:GKLeaderboardTimeScopeToday];
    
    
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_firstAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:1];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_firstLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:1];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_firstTodayName inTime:GKLeaderboardTimeScopeToday forPosition:1];
    _firstAllTimeScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_firstAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:1];
    _firstLastWeekScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_firstLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:1];
    _firstTodayScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_firstTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:1];
    
    
    
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_secondAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:2];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_secondLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:2];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_secondTodayName inTime:GKLeaderboardTimeScopeToday forPosition:2];
    _secondAllTimeScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_secondAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:2];
    _secondLastWeekScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_secondLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:2];
    _secondTodayScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_secondTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:2];
    
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_thirdAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:3];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_thirdLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:3];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_thirdTodayName inTime:GKLeaderboardTimeScopeToday forPosition:3];
    _thirdAllTimeScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_thirdAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:3];
    _thirdLastWeekScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_thirdLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:3];
    _thirdTodayScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_thirdTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:3];
    
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fourthAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:4];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fourthLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:4];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fourthTodayName inTime:GKLeaderboardTimeScopeToday forPosition:4];
    _fourthAllTimeScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fourthAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:4];
    _fourthLastWeekScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fourthLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:4];
    _fourthTodayScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fourthTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:4];
    
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fiveAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:5];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fiveLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:5];
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fiveTodayName inTime:GKLeaderboardTimeScopeToday forPosition:5];
    _fiveAllTimeScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fiveAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:5];
    _fiveLastWeekScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fiveLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:5];
    _fiveTodayScore.name = @"PointScore";
    [_gameCenter retrieveTopScore:@"PointAnswer" viewIn:_fiveTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:5];
    
}

-(void)showCollectedBooksRanking{
    _book.visible = YES;
    _right.visible = NO;
    _clock.visible = NO;
    
    
    [_gameCenter retrieveLocalPlayerScore:@"CapturedBooks" viewIn:_localPlayerAllTimePosition inTime:GKLeaderboardTimeScopeAllTime];
    [_gameCenter retrieveLocalPlayerScore:@"CapturedBooks" viewIn:_localPlayerLastWeekPosition inTime:GKLeaderboardTimeScopeWeek];
    [_gameCenter retrieveLocalPlayerScore:@"CapturedBooks" viewIn:_localPlayerTodayPosition inTime:GKLeaderboardTimeScopeToday];
    _localPlayerAllTimeScore.name = @"BookScore";
    [_gameCenter retrieveLocalPlayerScore:@"CapturedBooks" viewIn:_localPlayerAllTimeScore inTime:GKLeaderboardTimeScopeAllTime];
    _localPlayerLastWeekScore.name = @"BookScore";
    [_gameCenter retrieveLocalPlayerScore:@"CapturedBooks" viewIn:_localPlayerLastWeekScore inTime:GKLeaderboardTimeScopeWeek];
    _localPlayerTodayScore.name = @"BookScore";
    [_gameCenter retrieveLocalPlayerScore:@"CapturedBooks" viewIn:_localPlayerTodayScore inTime:GKLeaderboardTimeScopeToday];
    
    
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_firstAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:1];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_firstLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:1];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_firstTodayName inTime:GKLeaderboardTimeScopeToday forPosition:1];
    _firstAllTimeScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_firstAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:1];
    _firstLastWeekScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_firstLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:1];
    _firstTodayScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_firstTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:1];
    
    
    
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_secondAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:2];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_secondLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:2];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_secondTodayName inTime:GKLeaderboardTimeScopeToday forPosition:2];
    _secondAllTimeScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_secondAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:2];
    _secondLastWeekScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_secondLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:2];
    _secondTodayScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_secondTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:2];
    
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_thirdAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:3];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_thirdLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:3];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_thirdTodayName inTime:GKLeaderboardTimeScopeToday forPosition:3];
    _thirdAllTimeScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_thirdAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:3];
    _thirdLastWeekScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_thirdLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:3];
    _thirdTodayScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_thirdTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:3];
    
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fourthAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:4];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fourthLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:4];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fourthTodayName inTime:GKLeaderboardTimeScopeToday forPosition:4];
    _fourthAllTimeScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fourthAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:4];
    _fourthLastWeekScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fourthLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:4];
    _fourthTodayScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fourthTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:4];
    
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fiveAllTimeName inTime:GKLeaderboardTimeScopeAllTime forPosition:5];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fiveLastWeekName inTime:GKLeaderboardTimeScopeWeek forPosition:5];
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fiveTodayName inTime:GKLeaderboardTimeScopeToday forPosition:5];
    _fiveAllTimeScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fiveAllTimeScore inTime:GKLeaderboardTimeScopeAllTime forPosition:5];
    _fiveLastWeekScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fiveLastWeekScore inTime:GKLeaderboardTimeScopeWeek forPosition:5];
    _fiveTodayScore.name = @"BookScore";
    [_gameCenter retrieveTopScore:@"CapturedBooks" viewIn:_fiveTodayScore inTime:GKLeaderboardTimeScopeToday forPosition:5];
}
@end
