//
//  MainScene.h
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate,UIGestureRecognizerDelegate>


@property (nonatomic) CCPhysicsNode *physicsNode;

@property (nonatomic) CCSprite *hero;
@property (nonatomic) BOOL heroIsJumping;
@property (nonatomic) int numberOfJumps;


@property (nonatomic) CCNode* groundDown1;
@property (nonatomic) CCNode* groundDown2;
@property (nonatomic) NSArray *groundsDown;


@property (nonatomic) NSMutableArray *obstacles;


-(void)setup;
-(void)setupScene;
-(void)setupGrounds;
-(void)setupHero;

-(void)updateHero:(CCTime)delta;
-(void)updateGround;
-(void)updateObstacle:(CCTime)delta;

-(void)heroJump;
-(void)spawnNewObstacle;


@end
