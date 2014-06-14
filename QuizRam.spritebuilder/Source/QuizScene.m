//
//  QuizScene.m
//  QuizRam
//
//  Created by Augusto Reis on 6/10/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//
//This Class Controll the QuizScene, your database of questions, time acount and presentation.

#import "QuizScene.h"

static const float timeIntervalForCounting = 0.05;

@implementation QuizScene

-(void)didLoadFromCCB{

    [self showQuestion];
    
    _gameData = [GameData sharedManager];



}


-(void)showQuestion{
    

    
    NSString* plistPath = [self setUpDatabase];
    NSMutableArray *questions = [[[NSMutableArray alloc]initWithContentsOfFile:plistPath]mutableCopy];
    
    if([questions count] == 0){
        [self resetQuestionsDatabase];
        questions = [[[NSMutableArray alloc]initWithContentsOfFile:plistPath]mutableCopy];
    }
    
    [self setUpQuestions:questions];
    [self setUpTimer];

    
      
    
}
-(NSString*)setUpDatabase{
    
    NSError *erro;
    NSString *path = [[self searchUserFolderDoc] stringByAppendingString:@"/Questoes.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path]){
        NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:@"Questoes" ofType:@"plist"];
        [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&erro];
    }
    
    NSString *plistPath = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Questoes.plist"];

    return plistPath;
}
-(void)setUpQuestions:(NSMutableArray*)questions{
    _answerSelected = NO;
    _questionNumber = arc4random()% questions.count;
    _chosenQuestion = [[NSMutableDictionary alloc]initWithDictionary:[questions objectAtIndex:_questionNumber]];
    
    _instituitionLabel.string = [_chosenQuestion valueForKey:@"Instituicao"];
    _questionLabel.string = [_chosenQuestion valueForKey:@"Questao"];
    _questionLabel.dimensions = CGSizeMake(self.boundingBox.size.width/2.9, 0);
    
    [_firstLabelAnswer setString:[_chosenQuestion valueForKey:@"Alternativa1"]];
    _firstLabelAnswer.dimensions = CGSizeMake(self.boundingBox.size.width/2.9, self.boundingBox.size.height/4);
    
    [_secondLabelAnswer setString:[_chosenQuestion valueForKey:@"Alternativa2"]];
    _secondLabelAnswer.dimensions = CGSizeMake(self.boundingBox.size.width/2.9, self.boundingBox.size.height/4);
    
    [_thirdLabelAnswer setString:[_chosenQuestion valueForKey:@"Alternativa3"]];
    _thirdLabelAnswer.dimensions = CGSizeMake(self.boundingBox.size.width/2.9, self.boundingBox.size.height/4);
    
    [_fourthLabelAnswer setString:[_chosenQuestion valueForKey:@"Alternativa4"]];
    _fourthLabelAnswer.dimensions = CGSizeMake(self.boundingBox.size.width/2.9, self.boundingBox.size.height/4);
}
-(void)setUpTimer{
    _remainderTime = 180;
    _isTiming = YES;
    _quizTimer = [NSTimer scheduledTimerWithTimeInterval:timeIntervalForCounting target:self selector:@selector(initQuizTimerCounting:) userInfo:nil repeats:YES];
    _timerLabel.string = [NSString stringWithFormat:@"%.0f",_remainderTime];

    
}

-(void)resetQuestionsDatabase{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistScore = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Score.plist"];
    NSString *plistInit = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Questoes.plist"];
    [fileManager removeItemAtPath:plistInit error:nil];
    [fileManager copyItemAtPath:plistScore toPath:plistInit error:nil];
    [fileManager removeItemAtPath:plistScore error:nil];
    
}
-(void)storeQuestionAnsweredCorrectly{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistScore = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Score.plist"];
    
    NSMutableArray *score;
    if(![fileManager fileExistsAtPath:plistScore]){
        [fileManager createFileAtPath:plistScore contents:nil attributes:nil];
        score = [[NSMutableArray alloc]init];
    }else{
        score = [[[NSMutableArray alloc]initWithContentsOfFile:plistScore]mutableCopy];
    }
    [score addObject:_chosenQuestion];
    [score writeToFile:plistScore atomically:YES];
    [self deleteQuestionFromShowQuestions];
}
-(void)deleteQuestionFromShowQuestions{
    
    NSString * plistPath = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Questoes.plist"];
    NSMutableArray *questions = [[[NSMutableArray alloc]initWithContentsOfFile:plistPath]mutableCopy];
    [questions removeObject:_chosenQuestion];
    [questions writeToFile:plistPath atomically:YES];
}
-(NSString *)searchUserFolderDoc{
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docFolders = [folders objectAtIndex:0];
    return docFolders;
}
-(void)initQuizTimerCounting:(NSTimer *)theTimer{
    if(_isTiming) {
        _remainderTime -= timeIntervalForCounting;
        if(_remainderTime <= 0){
            _answerSelected = YES;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tempo Esgotado" message:@"Tempo esgotado para reponder a pergunta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
            [alert show];
            
            _isTiming = NO;
            _timerLabel.string = @"Tempo Esgotado";

        }else{
            _timerLabel.string = [NSString stringWithFormat:@"%.0f",_remainderTime];
        }

    }
}

-(void)selectFirstAnswer{
    _answerSelected = YES;
    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa1";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        _gameData.isCorrectAnswer = YES;

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        _gameData.isCorrectAnswer = NO;
        
        NSString *showCorrectAnswer = [NSString stringWithFormat:@"A resposta está errada, a resposta correta é: \"%@\"",[_chosenQuestion valueForKey:[ _chosenQuestion valueForKey:@"Resposta"]]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:showCorrectAnswer delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }

}
-(void)selectSecondAnswer{
    _answerSelected = YES;

    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa2";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        _gameData.isCorrectAnswer = YES;

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        _gameData.isCorrectAnswer = NO;
        
        NSString *showCorrectAnswer = [NSString stringWithFormat:@"A resposta está errada, a resposta correta é: \"%@\"",[_chosenQuestion valueForKey:[ _chosenQuestion valueForKey:@"Resposta"]]];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:showCorrectAnswer delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }
}
-(void)selectThirdAnswer{
    _answerSelected = YES;

    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa3";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        _gameData.isCorrectAnswer = YES;

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        _gameData.isCorrectAnswer = NO;
        
        NSString *showCorrectAnswer = [NSString stringWithFormat:@"A resposta está errada, a resposta correta é: \"%@\"",[_chosenQuestion valueForKey:[ _chosenQuestion valueForKey:@"Resposta"]]];

        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:showCorrectAnswer delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }
    
}
-(void)selectFourthAnswer{
    _answerSelected = YES;

    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa4";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        _gameData.isCorrectAnswer = YES;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        _gameData.isCorrectAnswer = NO;
        
        NSString *showCorrectAnswer = [NSString stringWithFormat:@"A resposta está errada, a resposta correta é: \"%@\" ",[_chosenQuestion valueForKey:[ _chosenQuestion valueForKey:@"Resposta"]]];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:showCorrectAnswer delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self setupScores];
    [self removeFromParentAndCleanup:YES];
    
    NSTimer *delayTimeResume;
    delayTimeResume = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(resumeGameScene) userInfo:nil repeats:YES];

}
-(void)setupScores{
    _gameData.timeOfAnswer = _remainderTime;
    
    if(_gameData.isCorrectAnswer){
        _gameData.scrollSceneSpeed-= (_gameData.scrollSceneSpeed/1000*_remainderTime*4);
        _gameData.lastScoreRightAnswer++;
    }else{
        _gameData.lastScoreWrongAnswer++;
        _gameData.scrollSceneSpeed+=_gameData.scrollSceneSpeed/5;
    }
    
}

-(void)resumeGameScene{
    
    if(_answerSelected){
        [[CCDirector sharedDirector] resume];
        _answerSelected = NO;

    }

}

@end
