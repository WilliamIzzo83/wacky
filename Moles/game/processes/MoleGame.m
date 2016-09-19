//
//  MoleGame.m
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "MoleGame.h"
#import "EventBus.h"
#import "ProcessManager.h"
#import "Mole.h"
#import "TapEvent.h"
#import "HoleHit.h"
#import "MoleEscaped.h"
#import "MoleDied.h"
#import "CollectMole.h"
#import "MoleRelease.h"
#import "Sequencer.h"
#import "MoleTrigger.h"
#import "SequenceGenerator.h"
#import "CountdownEndedEvent.h"
#import "CountDown.h"
#import "NoteEvent.h"
#import "ToneEvent.h"

typedef enum GameState {
    GameState_Initializing,
    GameState_GameStart,
    GameState_GameOver
} GameState;

@interface MoleGame()<EventBusDelegate>{
    ProcessManager* procMan_;
    NSUInteger score;
    GameState gameState;
    
    
    Sequencer* seqProc;
    SequenceGenerator* seqGenProc;
    MoleTrigger* moleTrigProc;
}

- (void)startCountdown;
- (void)setupGame;
- (void)tearDownGame;
- (void)gameOver;
- (void)updateScoreLabel;

@property (strong, nonatomic) NSArray<UIView*>* holesViews;
@property (strong, nonatomic) UIView* timeView;
@property (weak, nonatomic) EventBus* eBus;
@property (weak, nonatomic) UILabel* scoreLabel;

@end

@implementation MoleGame

- (instancetype)initWithHolesViews:(NSArray<UIView*>*)holesViews
                          timeView:(UIView *)timeView
                     andScoreLabel:(UILabel *)scoreLabel {
    self = [super init];
    self.holesViews = holesViews;
    self.timeView = timeView;
    self.scoreLabel = scoreLabel;
    self.eBus = [EventBus defaultBus];
    self->procMan_ = [ProcessManager defaultProcManager];
    return self;
}


- (void)onInit {
    self->gameState = GameState_Initializing;
    [self.eBus registerListener:self
                   forEventType:kEventTap];
    
    [self.eBus registerListener:self
                   forEventType:kEventMoleEscaped];
    
    [self.eBus registerListener:self
                   forEventType:kEventMoleDied];
    
    [self.eBus registerListener:self
                   forEventType:kEventMoleRelease];
    
    [self.eBus registerListener:self
                   forEventType:kEventCountdownEnded];
    
    [self.eBus registerListener:self
                   forEventType:kEventSequencerNote];
    [self startCountdown];
}

- (void)startCountdown {
    CountDown* cdProc = [[CountDown alloc] init];
    [self->procMan_ addProcess:cdProc];
}

- (void)setupGame {
    self->score = 0;
    self->_timeView.backgroundColor = [UIColor greenColor];
    
    self->seqGenProc = [[SequenceGenerator alloc] init];
    self->seqProc = [[Sequencer alloc] init];
    
    self->moleTrigProc = [[MoleTrigger alloc]
                          initWithHolesCount:self->_holesViews.count];
    
    [self->procMan_ addProcess:self->seqProc];
    [self->procMan_ addProcess:self->seqGenProc];
    [self->procMan_ addProcess:self->moleTrigProc];
}

- (void)tearDownGame {
    [self->seqGenProc success];
    [self->seqProc success];
    [self->moleTrigProc success];
    
    self->seqGenProc = nil;
    self->seqProc = nil;
    self->moleTrigProc = nil;
}

- (void)onUpdate:(NSTimeInterval)dt {
    [super onUpdate:dt];
    

    [self updateScoreLabel];
      
}

- (void)updateScoreLabel {
    [self.scoreLabel setText:[NSString stringWithFormat:@"%@", @(self->score)]];
}

- (void)gameOver {
    // Shuts down tone generator
    ToneEvent* toneEvt = [[ToneEvent alloc] init];
    toneEvt->pitch = 0.0;
    toneEvt->duration = 0.0;
    [self.eBus queueEvent:toneEvt];

    [self.timeView setBackgroundColor:[UIColor redColor]];
}

- (void)onSuccess {
    [self tearDownGame];
}

- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    
    switch (type) {
        case kEventCountdownEnded: {
            [self setupGame];
        } break;
        case kEventTap:{
            TapEvent* tap = (TapEvent*)event;
            CGPoint tapPoint = CGPointMake(tap.x, tap.y);
            NSUInteger vIdx = 0;
            for (UIView* v in self.holesViews) {
                if (CGRectContainsPoint(v.frame, tapPoint)) {
                    HoleHit* hitEvt = [[HoleHit alloc] init];
                    hitEvt->holeIndex = vIdx;
                    [self.eBus queueEvent:hitEvt];
                }
                ++vIdx;
            }
        }break;
        case kEventMoleRelease : {
            MoleRelease* rlsEvt = (MoleRelease*)event;
            NSUInteger holeIdx = rlsEvt->releaseData.holeIndex;
            Mole* mole = [[Mole alloc] initWithHoleView:self.holesViews[holeIdx]
                                            releaseData:rlsEvt->releaseData];

            [self->procMan_ addProcess:mole];
        }break;
        case kEventMoleEscaped: {
            self->gameState = GameState_GameOver;
            [self gameOver];
            [self tearDownGame];
            [self startCountdown];
        }break;
        case kEventMoleDied: {
            ++self->score;
        }break;
        case kEventSequencerNote: {
            NoteEvent* noteEvt = (NoteEvent*)event;
            ToneEvent* toneEvt = [[ToneEvent alloc] init];
            toneEvt->pitch = noteEvt->pitch;
            toneEvt->duration = noteEvt->durationTime;

            [self.eBus queueEvent:toneEvt];
        }break;
        default:
            break;
    }
}

@end
