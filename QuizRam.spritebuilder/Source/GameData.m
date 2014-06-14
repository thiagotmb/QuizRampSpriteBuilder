//
//  GameData.m
//  QuizRam
//
//  Created by Thiago Bernardes on 6/11/14.
//  Copyright (c) 2014 BEPiD. All rights reserved.
//
// This class controls and share game data with all classes of project.


#import "GameData.h"

@implementation GameData

//Singleton instance to share propertyes with other classes on project
+ (id)sharedManager {
    static GameData *sharedMyManager = nil;
    @synchronized(self) {
        if (sharedMyManager == nil)
            sharedMyManager = [[self alloc] init];
    }
    return sharedMyManager;
}




@end
