//
//  GameCenterViewController.m
//  QuizRam
//
//  Created by Everton Rider on 6/13/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//
//This class controll the Game Center, Login, submit and download scores and archievements


#import "GameCenterViewController.h"


@interface GameCenterViewController ()

@end

@implementation GameCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _gameData = [GameData sharedManager];

    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

//    UITableView *t = [[UITableView alloc]init];
//    [t registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *t = [[UITableView alloc]init];
    UITableViewCell *cell = [t dequeueReusableCellWithIdentifier:@"cell"];
    //edita
    return cell;
}

- (void) retrieveTopScore:(NSString*)leaderborderIdentifier viewIn:(CCLabelTTF*)label inTime:(GKLeaderboardTimeScope)timeScope forPosition:(NSInteger)position{

    GKLeaderboard *leaderbordRequested = [[GKLeaderboard alloc] init];
    //Verify if the leaderboard is downloaded
    if (leaderbordRequested != nil)
    {
        leaderbordRequested.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderbordRequested.timeScope = GKLeaderboardPlayerScopeGlobal;
        leaderbordRequested.identifier = leaderborderIdentifier;
        leaderbordRequested.range = NSMakeRange(1,10);
        
        [leaderbordRequested loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {

            if (error != nil)
            {
                // Handle the error.
            }
            if (scores != nil)
            {
                if(scores.count < position)
                    label.string = @" ";
                else{
                    GKScore *score= [scores objectAtIndex:position-1];

                    if([label.name isEqual:@"Name"]){
                        label.string = [NSString stringWithFormat:@"%@",score.player.displayName];
                    }else{
                        if([label.name  isEqual: @"TimeScore"])
                            label.string = [NSString stringWithFormat:@"%lld ms",score.value];
                        else
                            label.string = [NSString stringWithFormat:@"%lld",score.value];
                    }
                }
            }
        }];
    }

}

- (void) retrieveLocalPlayerScore:(NSString*)leaderborderIdentifier viewIn:(CCLabelTTF*)label inTime:(GKLeaderboardTimeScope)timeScope{
    
    GKLeaderboard *leaderbordRequested = [[GKLeaderboard alloc] init];
    //Verify if the leaderboard is downloaded
    if (leaderbordRequested != nil)
    {
        leaderbordRequested.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderbordRequested.timeScope = timeScope;
        leaderbordRequested.identifier = leaderborderIdentifier;
        leaderbordRequested.range = NSMakeRange(1,1);
        
        [leaderbordRequested loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            
            if (error != nil)
            {
                // Handle the error.
            }
            if (scores != nil)
            {
                if([label.name isEqual:@"Position"]){
                    label.string = [NSString stringWithFormat:@"%d",leaderbordRequested.localPlayerScore.rank];
                }else{
                    if([label.name  isEqual: @"TimeScore"])
                        label.string = [NSString stringWithFormat:@"%lld ms",leaderbordRequested.localPlayerScore.value];
                    else
                        label.string = [NSString stringWithFormat:@"%lld",leaderbordRequested.localPlayerScore.value];
                }

            }
        }];
    }
    
}


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupGameCenter{
    
    _gameCenterEnabled = NO;
    _leaderboardIdentifier = @"";
    [self authenticateLocalPlayer];

}

-(void)authenticateLocalPlayer{
    //Pega o usuario que esta jogando no GameCenter
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    /*
     Parametros do bloco
     The first one regards a view controller, which actually is the login
     view controller that will automatically appear if the user is not already authenticated.
     O segundo é o ponteiro de erro.
     */
    //EVERTON
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        /*
         Se não for nulo o usuario nao está autenticado
         */
        //EVERTON
        
        if (viewController != nil){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Game Center" message:@"Logue para obter Conquistas e acesso ao ranking mundial!" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Logar", nil];
            
            [alert show];
            _gameCenter = viewController;
            
            
        }else{
            /*
             Se se o jogador esta autenticado sera feita duas coias.
             1- Para poder usar os recursos do Game Center, simplismente alterando gameCenterEnable
             para sim.
             2- Pegar o identificador do laederboard que foi criado anteriomente.
             Nao foi usado direto no leaderboard ID pois o metodo loadDefaultLeaderboardIdentifierWithCompletionHandler é mais formal e correto.
             */
            //EVERTON
            
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled=YES;
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier,NSError *error){
                    /*
                     Se der erro no proximo if, sera mandado o NSError para o terminal.
                     Se nao vamos manter o leaderboardIdentifier
                     */
                    if(error!=nil){
                        NSLog(@"%@",[error localizedDescription]);
                    }else{
                        _leaderboardIdentifier =leaderboardIdentifier;
                    }
                }];
                /*
                 Se o usuario nao esta autenticado e a view de login é nil simplismente cancela
                 o processo de login e desativa o gameCenterEnable
                 */
            }else{
                
                _gameCenterEnabled=NO;
            }
        }
        
    };
    
}
-(void)reportScore{
    /*
     Inicializa o GKScore, especificando no init o identificador do Leaderboard que foi
     traga na autenticação.
     
     The GKScore class is responsible for handling any score-related tasks,
     and in here we’ll use just the basics needed to do our job.
     */
    //EVERTON
    GKScore *survivalScore =[[GKScore alloc]initWithLeaderboardIdentifier:@"SurvivalTime"];
    survivalScore.value=_gameData.lastScoreSurvivalTime;
    NSLog(@" ultimo score %u",_gameData.lastScoreSurvivalTime);

    
    GKScore *capturedBooks =[[GKScore alloc]initWithLeaderboardIdentifier:@"CapturedBooks"];
    capturedBooks.value=_gameData.lastScoreCapturedBooks;
    
    GKScore *rightAnswer =[[GKScore alloc]initWithLeaderboardIdentifier:@"RightAnswer"];
    rightAnswer.value=_gameData.lastScoreRightAnswer;
    
    GKScore *wrongAnswer =[[GKScore alloc]initWithLeaderboardIdentifier:@"WrongAnswer"];
    wrongAnswer.value=_gameData.lastScoreWrongAnswer;
    
    GKScore *pointAnswer =[[GKScore alloc]initWithLeaderboardIdentifier:@"PointAnswer"];
    pointAnswer.value=_gameData.lastScorePointAnswer;
    
    
    /*
     Depois é invocada a reportScores:withCompletionHandler: metodo statico do GKScore
     o primeiro parametro espera um NSArray, isso permite relatar multiplos scores,
     por isso foi se seta o @[score], assim se cria o NSArray e coloca o score dentro dele,
     e o bloco de erro ira mostrar no terminal qualquer erro que ocorrer
     
     */
    //EVERTON
    [GKScore reportScores:@[survivalScore,capturedBooks,rightAnswer,wrongAnswer,pointAnswer] withCompletionHandler:^(NSError *error){
        if(error!=nil){
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex ==1)
        [[CCDirector sharedDirector] presentViewController:_gameCenter animated:YES completion:nil];

}





-(void)updateAchievements{
    //    NSString *achievementIdentifier;
    //    float progressPercentage=0.0;
    //    BOOL progressInLevelAchievement=NO;
    //
    //
    //    /*
    //     O objeto dessa classe é inicializado informando o AchievementID
    //     */
    //    //EVERTON
    //    GKAchievement *levelAchievement=nil;
    //    GKAchievement *scoreAchievement=nil;
    //    progressInLevelAchievement = NO;
    //    if (_currentAdditionCounter == 0) {
    //        if (_level <= 3) {
    //            progressPercentage = _level * 100 / 3;
    //            achievementIdentifier = @"Achievement_Level3";
    //            progressInLevelAchievement = YES;
    //        }
    //        else if (_level < 6){
    //            progressPercentage = _level * 100 / 5;
    //            achievementIdentifier = @"Achievement_Level5Complete";
    //            progressInLevelAchievement = YES;
    //        }
    //    }
    //
    //    [levelAchievement setShowsCompletionBanner:YES];
    //    if (progressInLevelAchievement) {
    //        levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    //        levelAchievement.percentComplete = progressPercentage;
    //
    //        [levelAchievement setShowsCompletionBanner:YES];
    //    }
    //
    //    switch (_score) {
    //        case 50:
    //            progressPercentage = 100;
    //            achievementIdentifier = @"Achievement_50Points";
    //            break;
    //        case 120:
    //            progressPercentage=100;
    //            achievementIdentifier = @"Achievement_120Points";
    //            break;
    //
    //        case 180:
    //            progressPercentage=100;
    //            achievementIdentifier = @"Achievement_180Points";
    //            break;
    //        default:
    //            progressPercentage=0;
    //            break;
    //    }
    //
    //
    //
    //
    //    /*
    //     Aqui se coloca um array de achievements para ser parametro do proximo metodo
    //     */
    //    //EVERTON
    //    scoreAchievement.showsCompletionBanner=YES;
    //    scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    //    scoreAchievement.percentComplete = progressPercentage;
    //    [scoreAchievement setShowsCompletionBanner:YES];
    //
    //    NSArray *achievements = (progressInLevelAchievement) ? @[levelAchievement, scoreAchievement] : @[scoreAchievement];
    //
    //    /*
    //     O metodo reportAchievement:withCompletionHandler: espera um array de GKAchievement
    //     */
    //    //EVERTON
    //    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
    //        if (error != nil) {
    //            NSLog(@"%@", [error localizedDescription]);
    //        }
    //    }];
    //    
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    
}

@end
