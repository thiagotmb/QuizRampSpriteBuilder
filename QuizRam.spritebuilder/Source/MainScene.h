//
//  MainScene.h
//  QuizRam
//
//  Created by Thiago



#import "CCNode.h"
#import <GameKit/GameKit.h>
#import "GameData.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate,UIGestureRecognizerDelegate,GKGameCenterControllerDelegate>


// A flag indicating whether the Game Center features can be used after a user has been authenticated.
@property (nonatomic) BOOL gameCenterEnabled;
// This property stores the default leaderboard's identifier.
@property (nonatomic, strong) NSString *leaderboardIdentifier;

@property (nonatomic) CCPhysicsNode *physicsNode;
@property (nonatomic) UISwipeGestureRecognizer* swipeUpGesture;
@property (nonatomic) UISwipeGestureRecognizer* swipeDownGesture;
@property (nonatomic) UISwipeGestureRecognizer* swipeRightGesture;
@property (nonatomic) CGFloat gravityY;
@property (nonatomic) CGFloat scrollSpeed;
@property (nonatomic) CCParallaxNode *backgroundNode;
@property (nonatomic) CCNode *background1;
@property (nonatomic) CCNode *background2;
@property (nonatomic) CCNode *background3;
@property (nonatomic) CCNode *background4;
@property (nonatomic) CCNode* screenLimitDown;
@property (nonatomic) CCNode* screenLimitLeft;
@property (nonatomic) CCButton *restartButtom;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) CCLabelTTF *timeScore;
@property (nonatomic) double timeInGame;
@property (nonatomic) NSTimer *gameTimeCount;
@property (nonatomic) CCLabelTTF* capturedBooksScore;
@property (nonatomic) unsigned int capturedBooks;
@property (nonatomic) CCLabelTTF* gravityBootTimer;
@property (nonatomic) double gravityTimer;


@property (nonatomic) CCSprite *hero;
@property (nonatomic) CCBAnimationManager* heroAnimation;
@property (nonatomic) CCParticleBatchNode *runSmoke;
@property (nonatomic) CGFloat jumpVelocityY;;
@property (nonatomic) BOOL heroIsJumping;
@property (nonatomic) int numberOfJumps;


@property (nonatomic) CCNode* lamp2;
@property (nonatomic) CCNode* lamp1;
@property (nonatomic) NSArray* lamps;
@property (nonatomic) CCNode* groundDown1;
@property (nonatomic) CCNode* groundDown2;
@property (nonatomic) CCNode* groundDown3;
@property (nonatomic) NSArray *groundsDown;
@property (nonatomic) CCNode* groundUp1;
@property (nonatomic) CCNode* groundUp2;
@property (nonatomic) NSArray *groundsUp;
@property (nonatomic) int groundRandomPositionX;
@property (nonatomic) int groundRandomPositionY;
@property (nonatomic) CCNode* changedGround;


@property (nonatomic) CCNode* answerBookBlue;
@property (nonatomic) int distanceBetweenObstacles;



-(void)setup;
-(void)setupGameCenter;
-(void)setupScene;
-(void)setupSwipes;
-(void)setupGrounds;
-(void)setupHero;

-(void)updateScene:(CCTime)delta;
-(void)updateGround;
-(void)updateGroundDown;
-(void)updateGroundUp;
-(void)updateAnswerBook;


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDown:(CCNode *)groundDown;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundUp;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero screenDown:(CCNode *)screenDown;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero screenLeft:(CCNode *)screenLeft;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDownSpecial:(CCNode *)groundDownSpecial;

-(void)authenticateLocalPlayer;
-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer;
-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer;
-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer;

-(void)countTimeinGame:(NSTimer*)theTime;
-(void)randomizeGrounds:(int)random;

-(void)heroJump;
-(void)heroRotate;

-(void)gameEnds;
-(void)restart;





@end
