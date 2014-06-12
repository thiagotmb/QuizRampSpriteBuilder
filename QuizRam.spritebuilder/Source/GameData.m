//
//  GameData.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//

#import "GameData.h"

@implementation GameData


+ (id)sharedManager {
    static GameData *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}




@end
