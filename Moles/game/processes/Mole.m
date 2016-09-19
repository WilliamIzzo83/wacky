//
//  Mole.m
//  Moles
//
//  Created by William Izzo on 31/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Mole.h"
#import "EventBus.h"
#import "HoleHit.h"
#import "MoleDied.h"
#import "MoleEscaped.h"
#import "CollectMole.h"

typedef enum : NSUInteger {
    MoleState_Appearing,
    MoleState_Idling,
    MoleState_Retreating,
    MoleState_Dying,
    MoleState_Done
} MoleState;

@interface Mole()<EventBusDelegate> {
    UIView* __weak holeView_;
    MoleReleaseData releaseData;
    MoleState state_;
}
- (BOOL)IsHittable;
@end

@implementation Mole

- (instancetype)initWithHoleView:(UIView*)holeView
                     releaseData:(MoleReleaseData)rData {
    self = [super init];
    self->holeView_ = holeView;
    self->releaseData = rData;
    return self;
}


- (instancetype)initWithHoleView:(UIView *)holeView
                       holeIndex:(NSUInteger)holeIndex {
    
    MoleReleaseData mrData = {
      holeIndex, 0.4, 0.5, 0.4, 0.3
    };
    
    self = [self initWithHoleView:holeView
                      releaseData:mrData];
    return self;
}


- (void)onInit {
    self->state_ = MoleState_Appearing;
    [[EventBus defaultBus] registerListener:self
                               forEventType:kEventHoleHit];
}


- (void)onUpdate:(NSTimeInterval)dt {
    // Dumb mole state machine
    switch (self->state_) {
        case MoleState_Appearing:{
            self->releaseData.appearanceTime -= dt;
            if (self->releaseData.appearanceTime <= 0.0) {
                self->state_ = MoleState_Idling;
            }
            [self->holeView_ setBackgroundColor:[UIColor orangeColor]];
        } break;
        case MoleState_Idling :{
            self->releaseData.permanenceTime -= dt;
            if (self->releaseData.permanenceTime <= 0.0) {
                self->state_ = MoleState_Retreating;
            }
            [self->holeView_ setBackgroundColor:[UIColor greenColor]];
        } break;
        case MoleState_Retreating: {
            self->releaseData.retreatTime -= dt;
            if (self->releaseData.retreatTime <= 0.0) {
                self->state_ = MoleState_Done;
            }
            [self->holeView_ setBackgroundColor:[UIColor blueColor]];
        } break;
        case MoleState_Dying: {
            self->releaseData.dieTime -= dt;
            if (self->releaseData.dieTime <= 0.0) {
                self->state_ = MoleState_Done;
                MoleDied* diedEvt = [[MoleDied alloc] init];
                [[EventBus defaultBus] queueEvent:diedEvt];
                [self success];
            }
            [self->holeView_ setBackgroundColor:[UIColor redColor]];
            
        } break;
        case MoleState_Done : {
            MoleEscaped* escapedEvt = [[MoleEscaped alloc] init];
            [[EventBus defaultBus] queueEvent:escapedEvt];
            [self success];
        }
        default:
            break;
    }
}

- (void)onSuccess {
    [self->holeView_ setBackgroundColor:[UIColor clearColor]];
    CollectMole* collectMole = [[CollectMole alloc] init];
    collectMole->holeIndex = self->releaseData.holeIndex;
    [[EventBus defaultBus] queueEvent:collectMole];
}

- (BOOL)IsHittable {
    return self->state_ == MoleState_Appearing ||
    self->state_ == MoleState_Idling ||
    self->state_ == MoleState_Retreating;
}

- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    if (![self IsHittable]) {
        return;
    }
    
    assert(type == kEventHoleHit);
    HoleHit* hitEvent = (HoleHit*)event;
    
    if (hitEvent->holeIndex != self->releaseData.holeIndex) {
        return;
    }
    
    self->state_ = MoleState_Dying;
}

@end
