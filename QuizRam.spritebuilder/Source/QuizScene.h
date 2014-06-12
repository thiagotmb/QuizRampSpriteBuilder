//
//  QuizScene.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/10/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "CCNode.h"
#import "GameData.h"

@interface QuizScene : CCNode


@property (nonatomic) CCLabelTTF* questionLabel;
@property (nonatomic) CCLabelTTF* timerLabel;
@property (nonatomic) CCLabelTTF* instituitionLabel;

@property (nonatomic) CCButton* firstButtonAnswer;
@property (nonatomic) CCLabelTTF* firstLabelAnswer;
@property (nonatomic) CCButton* secondButtonAnswer;
@property (nonatomic) CCLabelTTF* secondLabelAnswer;
@property (nonatomic) CCButton* thirdButtonAnswer;
@property (nonatomic) CCLabelTTF* thirdLabelAnswer;
@property (nonatomic) CCButton* fourthButtonAnswer;
@property (nonatomic) CCLabelTTF* fourthLabelAnswer;

@property (nonatomic) CCScene *quizScene;

@property(nonatomic) NSInteger disciplineNumber;
@property(nonatomic) NSDictionary *chosenQuestion;
@property(nonatomic) BOOL isTiming;
@property(nonatomic) NSTimer *quizTimer;
@property (nonatomic) double remainderTime;

@property(nonatomic) GameData *gameData;

-(void)showQuestion;
-(void)selectFirstAnswer;
-(void)selectSecondAnswer;
-(void)selectThirdAnswer;
-(void)selectFourthAnswer;



@end