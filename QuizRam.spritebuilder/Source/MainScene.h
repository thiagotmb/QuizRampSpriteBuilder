//
//  MainScene.h
//  QuizRam
//
//  Created by Thiago



#import "CCNode.h"
#import "GameData.h"
#import "GameCenterViewController.h"
#import "QuizScene.h"
#import "CCParallaxNode-Extras.h"

@interface MainScene : CCNode <CCPhysicsCollisionDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>


@property (nonatomic) GameData *gameData;

@property (nonatomic) CCPhysicsNode *physicsNode;
@property (nonatomic) CGFloat gravityY;
@property (nonatomic) UISwipeGestureRecognizer* swipeUpGesture;
@property (nonatomic) UISwipeGestureRecognizer* swipeDownGesture;
@property (nonatomic) UISwipeGestureRecognizer* swipeRightGesture;
@property (nonatomic) CCParallaxNode *backgroundNode;
@property (nonatomic) CCNode *background1;
@property (nonatomic) CCNode *background2;
@property (nonatomic) CCNode *background3;
@property (nonatomic) CCNode *background4;
@property (nonatomic) CCNode* screenLimitDown;
@property (nonatomic) CCNode* screenLimitLeft;
@property (nonatomic) CCButton *restartButton;
@property (nonatomic) CCButton *menuButton;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) CCLabelTTF *timeScore;
@property (nonatomic) unsigned int timeInGame;

@property (nonatomic) CCSprite *hero;
@property (nonatomic) CCBAnimationManager* heroAnimation;
@property (nonatomic) CGFloat jumpVelocityY;;
@property (nonatomic) BOOL heroIsJumping;
@property (nonatomic) unsigned int numberOfJumps;
@property (nonatomic) CCLabelTTF* gravityBootTimer;
@property (nonatomic) float gravityTimer;
@property (nonatomic) BOOL bootReadyToReload;
@property (nonatomic) CCSprite *bootTimerSprite;
@property (nonatomic) CCProgressNode *bootTimerProgressBar;
@property (nonatomic) CCNode *runParticle;


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

@property (nonatomic) CCNode* questionBookBlue;
@property (nonatomic) CCLabelTTF* capturedBooksScore;
@property (nonatomic) unsigned int capturedBooks;
@property (nonatomic) unsigned int timeOfSpawnBooks;

@property (nonatomic) QuizScene *quiz;
@property (nonatomic) CCLabelTTF*scoreAnswers;



-(void)setup;
-(void)setupScene;
-(void)setupSwipes;
-(void)setupGrounds;
-(void)setupHero;

-(void)updateScene:(CCTime)delta;
-(void)updateParallaxBackground:(CCTime)delta;
-(void)updateGround;
-(void)updateGroundDown;
-(void)updateGroundUp;
-(void)updateQuestionBook;
-(void)updateHero:(CCTime)delta;


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDown:(CCNode *)groundDown;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundUp:(CCNode *)groundUp;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero screenDown:(CCNode *)screenDown;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero screenLeft:(CCNode *)screenLeft;
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero groundDownSpecial:(CCNode *)groundDownSpecial;

-(void)handleSwipeUp:(UISwipeGestureRecognizer*)recognizer;
-(void)handleSwipeDown:(UISwipeGestureRecognizer*)recognizer;
-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer;

-(void)showQuiz;
-(void)countTimeinGame:(CCTime)theTime;
-(void)randomizeGrounds:(int)random;

-(void)heroJump;
-(void)heroRotate;

-(void)gameEnds;






@end
