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

@interface MoleGame()<EventBusDelegate>{
    NSTimeInterval remainingGameTime;
    NSTimeInterval elapsedTime;
    CGFloat initialTimeViewLength;
    CGFloat timeViewVsGameTimeProportion;
    NSTimeInterval moleSpawnElapsedTime;
    NSTimeInterval moleSpawnTime;
    NSUInteger maxActiveMoles;
    NSUInteger activeMolesCount;
    char* busyHoles;
}

- (void)unlockAllHoles;
- (BOOL)holeIsBusy:(NSUInteger)holeIdx;
- (BOOL)lockHole:(NSUInteger)holeIdx;
- (void)unlockHole:(NSUInteger)holeIdx;

- (void)updateTimeBar:(NSTimeInterval)dt;
- (void)updateMoles:(NSTimeInterval)dt;

@property (strong, nonatomic) NSArray<UIView*>* holesViews;
@property (strong, nonatomic) UIView* timeView;
@property (weak, nonatomic) EventBus* eBus;

@end

@implementation MoleGame
- (instancetype)initWithHolesViews:(NSArray<UIView*>*)holesViews
                       andTimeView:(UIView*)timeView {
    self = [super init];
    self.holesViews = holesViews;
    self.timeView = timeView;
    self.eBus = [EventBus defaultBus];
    self->busyHoles = (char*)(malloc(sizeof(char) * self.holesViews.count));
    
    return self;
}

- (void)dealloc {
    free(self->busyHoles);
}

- (void)onInit {
    [self unlockAllHoles];
    self->maxActiveMoles = 1;
    self->activeMolesCount = 0;
    self->remainingGameTime = 120.0;
    self->moleSpawnTime = 1.0;
    self->moleSpawnElapsedTime = 0.0;
    self->initialTimeViewLength = self.timeView.frame.size.width;
    self->timeViewVsGameTimeProportion = self->initialTimeViewLength / self->remainingGameTime;
    
    [self.eBus registerListener:self
                   forEventType:kEventTap];
    
    [self.eBus registerListener:self
                   forEventType:kEventCollectMole];
    
    [self.eBus registerListener:self
                   forEventType:kEventMoleEscaped];
    
    [self.eBus registerListener:self
                   forEventType:kEventMoleDied];
    
}

- (void)onUpdate:(NSTimeInterval)dt {
    [super onUpdate:dt];
    
//    self->remainingGameTime -= dt;
//    if (self->remainingGameTime <= 0) {
//        [self success];
//        return;
//    }
    
    [self updateMoles:dt];
    [self updateTimeBar:dt];
    
    
}

- (void)updateTimeBar:(NSTimeInterval)dt {
    CGRect tvFrame = self.timeView.frame;
    tvFrame.size.width = self->timeViewVsGameTimeProportion * self->remainingGameTime;
    self.timeView.frame = tvFrame;
}

- (void)updateMoles:(NSTimeInterval)dt {
    self->moleSpawnElapsedTime += dt;
    if (self->moleSpawnElapsedTime < self->moleSpawnTime) {
        return;
    }
    
    
    self->moleSpawnElapsedTime = 0.0;
    
    if (self->activeMolesCount >= self->maxActiveMoles) {
        return;
    }
    
    
    NSUInteger holeIdx = (NSUInteger)arc4random_uniform(self->_holesViews.count);
    if (![self lockHole:holeIdx]) {
        return;
    }
    
    ++self->activeMolesCount;
    
    
    
    Mole* mole = [[Mole alloc] initWithHoleView:self.holesViews[holeIdx]
                                      holeIndex:holeIdx];
    
    ProcessManager* pm = [ProcessManager defaultProcManager];
    [pm addProcess:mole];
}

- (void)unlockAllHoles {
    memset(self->busyHoles, 0, sizeof(char) * self.holesViews.count);
}

- (BOOL)lockHole:(NSUInteger)holeIdx {
    if ([self holeIsBusy:holeIdx]) {
        return NO;
    }
    
    self->busyHoles[holeIdx] = 1;
    return YES;
}

- (void)unlockHole:(NSUInteger)holeIdx {
    self->busyHoles[holeIdx] = 0;
}

- (BOOL)holeIsBusy:(NSUInteger)holeIdx {
    return self->busyHoles[holeIdx];
}

- (void)onSuccess {
    CGRect tvFrame = self.timeView.frame;
    tvFrame.size.width = self->initialTimeViewLength;
    self.timeView.frame = tvFrame;
    [self.timeView setBackgroundColor:[UIColor redColor]];
}

- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    
    switch (type) {
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
        case kEventCollectMole: {
            --self->activeMolesCount;
            CollectMole* collectEvt = (CollectMole*)event;
            [self unlockHole:collectEvt->holeIndex];
            [self.holesViews[collectEvt->holeIndex]
             setBackgroundColor:[UIColor clearColor]];
        }break;
        case kEventMoleEscaped: {
            // TODO : apply some gameplay modifier
        }break;
        case kEventMoleDied: {
            // TODO : apply some gameplay modifier
        }break;
        default:
            break;
    }
}

@end
