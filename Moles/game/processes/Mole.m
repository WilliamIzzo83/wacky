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
    NSTimeInterval appearanceTime_;
    NSTimeInterval permanenceTime_;
    NSTimeInterval retreatTime_;
    NSTimeInterval dieTime_;
    MoleState state_;
}
- (BOOL)IsHittable;
@end

@implementation Mole

@synthesize holeIndex = holeIndex_;

- (instancetype)initWithHoleView:(UIView *)holeView holeIndex:(NSUInteger)holeIndex {
    self = [super init];
    self->holeView_ = holeView;
    self->holeIndex_ = holeIndex;
    self->state_ = MoleState_Appearing;
    return self;
}


- (void)onInit {
    // TODO: read those from a configuration file maybe?
    self->permanenceTime_ = 0.4;
    self->appearanceTime_ = 0.5;
    self->retreatTime_ = 0.4;
    self->dieTime_ = 0.3;
    
    [[EventBus defaultBus] registerListener:self
                               forEventType:kEventHoleHit];
}


- (void)onUpdate:(NSTimeInterval)dt {
    // Dumb mole state machine
    switch (self->state_) {
        case MoleState_Appearing:{
            self->appearanceTime_ -= dt;
            if (self->appearanceTime_ <= 0.0) {
                self->state_ = MoleState_Idling;
            }
            [self->holeView_ setBackgroundColor:[UIColor orangeColor]];
        } break;
        case MoleState_Idling :{
            self->permanenceTime_ -= dt;
            if (self->permanenceTime_ <= 0.0) {
                self->state_ = MoleState_Retreating;
            }
            [self->holeView_ setBackgroundColor:[UIColor greenColor]];
        } break;
        case MoleState_Retreating: {
            self->retreatTime_ -= dt;
            if (self->retreatTime_ <= 0.0) {
                self->state_ = MoleState_Done;
            }
            [self->holeView_ setBackgroundColor:[UIColor blueColor]];
        } break;
        case MoleState_Dying: {
            self->dieTime_ -= dt;
            if (self->dieTime_ <= 0.0) {
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
    CollectMole* collectMole = [[CollectMole alloc] init];
    collectMole->holeIndex = self->holeIndex_;
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
    
    if (hitEvent->holeIndex != self->holeIndex_) {
        return;
    }
    
    self->state_ = MoleState_Dying;
}

@end
