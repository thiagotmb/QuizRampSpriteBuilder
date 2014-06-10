//
//  CCParallaxNode-Extras.h
//  QuizRam
//
//  Created by Thiago



#import "cocos2d.h"

@interface CCParallaxNode (Extras) 

-(void) incrementOffset:(CGPoint)offset forChild:(CCNode*)node;

@end
