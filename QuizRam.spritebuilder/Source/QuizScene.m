//
//  QuizScene.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/10/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "QuizScene.h"

@implementation QuizScene

-(void)didLoadFromCCB{

    
    [self showQuestion];
    _quizTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(initQuizTimerCounting:) userInfo:nil repeats:YES];
    _gameData = [GameData sharedManager];



}

-(void)showQuestion{
    _isTiming = YES;
    
    NSError *erro;
    NSString *path = [[self searchUserFolderDoc] stringByAppendingString:@"/Questoes.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:@"Questoes" ofType:@"plist"];
        [fileManager copyItemAtPath:pathToSettingsInBundle toPath:path error:&erro];
    }
    NSString *plistPath = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Questoes.plist"];
    NSMutableArray *disciplines = [[[NSMutableArray alloc]initWithContentsOfFile:plistPath]mutableCopy];\

    _disciplineNumber = arc4random()% disciplines.count;
    NSMutableArray *questions = [[NSMutableArray alloc]initWithArray:[disciplines objectAtIndex:_disciplineNumber]];

    _chosenQuestion = [[NSMutableDictionary alloc]initWithDictionary:[questions objectAtIndex:(arc4random()%(questions.count))]];
    _remainderTime = 5;
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
    _timerLabel.string = [NSString stringWithFormat:@"%.2f",_remainderTime];
    _isTiming = YES;
      
    
}
-(void)storeQuestionAnsweredCorrectly{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistScore = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Score.plist"];
    
    NSMutableArray *capturedQuestions;
    if(![fileManager fileExistsAtPath:plistScore]){
        [fileManager createFileAtPath:plistScore contents:nil attributes:nil];
        capturedQuestions = [[NSMutableArray alloc]init];
    }else{
        capturedQuestions = [[[NSMutableArray alloc]initWithContentsOfFile:plistScore]mutableCopy];
    }
    [capturedQuestions addObject:_chosenQuestion];
    [capturedQuestions writeToFile:plistScore atomically:YES];
    [self deleteQuestionFromShowQuestions];
}

-(void)deleteQuestionFromShowQuestions{
    
    NSString * plistPath = [[self searchUserFolderDoc] stringByAppendingPathComponent:@"Questoes.plist"];
    NSMutableArray *disciplines = [[[NSMutableArray alloc]initWithContentsOfFile:plistPath]mutableCopy];
    [[disciplines objectAtIndex:_disciplineNumber]removeObject:_chosenQuestion];
    [disciplines writeToFile:plistPath atomically:YES];
}

-(NSString *)searchUserFolderDoc{
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docFolders = [folders objectAtIndex:0];
    return docFolders;
}

-(void)initQuizTimerCounting:(NSTimer *)theTimer{
    if(_isTiming) {
        _timerLabel.string = [NSString stringWithFormat:@"%.3f",_remainderTime];
        _remainderTime -= 0.001;
        if(_remainderTime <= 0){
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Tempo Esgotado" message:@"Tempo esgotado para reponder a pergunta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
            [alert show];
            
            _isTiming = NO;
            
        }
        if(_remainderTime <= 0){
            _timerLabel.string = @"Tempo Esgotado";
        }
    }

}

-(void)selectFirstAnswer{
    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa1";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:@"A resposta está errada" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }

}


-(void)selectSecondAnswer{
    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa2";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:@"A resposta está errada" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }
}


-(void)selectThirdAnswer{
    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa3";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:@"A resposta está errada" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }
    
}


-(void)selectFourthAnswer{
    NSString *correctAnswer = [[NSString alloc]initWithString:[_chosenQuestion valueForKey:@"Resposta"]];
    NSString *chosenAnswer = @"Alternativa4";
    if ([chosenAnswer compare:correctAnswer]==NSOrderedSame) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Correto" message:@"A resposta está correta" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
        [self storeQuestionAnsweredCorrectly];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Errado" message:@"A resposta está errada" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Continuar o jogo", nil];
        [alert show];
        _isTiming = NO;
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        _gameData.answerSelectined = YES;
    _gameData.timeOfAnswer = _remainderTime;
    [[CCDirector sharedDirector] resume];
    

}

@end
