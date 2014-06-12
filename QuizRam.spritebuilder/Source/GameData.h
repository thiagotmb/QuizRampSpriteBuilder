//
//  GameData.h
//  QuizRam
//
//  Created by Thiago Bernardes on 6/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "CCNode.h"

@interface GameData : CCNode

+(id)sharedManager;

@property (nonatomic) float timeOfAnswer;
@property (nonatomic) BOOL correctAnswer;
@property (nonatomic) BOOL answerSelectined;

@end
