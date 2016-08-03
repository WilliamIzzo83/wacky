//
//  ViewController.m
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "ViewController.h"
#import "GameLooper.h"
#import "InputManager.h"
#import "TapEvent.h"
#import "EventBus.h"
#import "ProcessManager.h"
#import "CountDown.h"
#import "MoleGame.h"
#import "GeneratePlayField.h"

@interface ViewController ()
- (void)setupGameUI;
- (void)tapGestureRecognizerDlg:(UITapGestureRecognizer*)tap;
@property (strong, nonatomic) GameLooper* gameLooper;
@property (strong, nonatomic) InputManager* inputManager;
@property (strong, nonatomic) UIView* holesContainerView;
@property (strong, nonatomic) UIView* timeView;
@property (strong, nonatomic) NSMutableArray<UIView*>* holesViews;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapGestureRecognizerDlg:)];
    [self.view addGestureRecognizer:tap];
    self.holesViews = [NSMutableArray<UIView*> array];
    
    [self setupGameUI];
    
    self.gameLooper = [[GameLooper alloc] init];
    self.inputManager = [[InputManager alloc] init];
    
    NSMutableArray<UIView*>* theHoles = self.holesViews;
    
    GeneratePlayField* genPlayField =
    [[GeneratePlayField alloc] initWithGameView:self.holesContainerView
                                andHolesViewRef:theHoles];
    
    CountDown* countDown = [[CountDown alloc] init];
    
    MoleGame* mGame = [[MoleGame alloc] initWithHolesViews:self.holesViews
                                               andTimeView:self.timeView];
    
    [genPlayField addChild:countDown];
    [genPlayField addChild:mGame];
    
    [[ProcessManager defaultProcManager] addProcess:genPlayField];
    
    
    [self.inputManager startUp];
    [self.gameLooper startUp];
}

- (void)setupGameUI {
    CGRect screenFrame = self.view.frame;
    CGSize halfScreenSize = CGSizeMake(screenFrame.size.width / 2.0,
                                       screenFrame.size.height / 2.0);
    
    CGRect tvFrame = CGRectMake(0.0,
                                30.0,
                                screenFrame.size.width,
                                50.0);
    
    self.timeView = [[UIView alloc] initWithFrame:tvFrame];
    [self.timeView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.timeView];
    
    
    CGFloat hcSize = screenFrame.size.width * 0.86;
    CGFloat halfFieldSize = hcSize * 0.5;
    
    CGRect hcFrame = CGRectMake(0.0,
                                screenFrame.size.height - hcSize - 80.0,
                                hcSize,
                                hcSize);
    
    
    
    
    hcFrame.origin.x =  halfScreenSize.width - halfFieldSize;
    
    self.holesContainerView = [[UIView alloc] initWithFrame:hcFrame];
    [self.view addSubview:self.holesContainerView];
}

- (void)tapGestureRecognizerDlg:(UITapGestureRecognizer *)tap {
    CGPoint tapLocation = [tap locationInView:self.holesContainerView];
    TapEvent* tapEvent = [[TapEvent alloc] init];
    tapEvent.x = tapLocation.x;
    tapEvent.y = tapLocation.y;
    
    [self.inputManager enqueueInputEvent:tapEvent];
}


@end
