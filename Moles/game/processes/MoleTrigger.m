//
//  MoleTrigger.m
//  Moles
//
//  Created by William Izzo on 10/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "MoleTrigger.h"
#import "EventBus.h"
#import "NoteEvent.h"
#import "CollectMole.h"
#import "MoleRelease.h"

@interface MoleTrigger ()<EventBusDelegate> {
    EventBus* eBus_;
    NSUInteger holesCount_;
}

- (void)registerBusEvents;
@end

@implementation MoleTrigger

- (instancetype)initWithHolesCount:(NSUInteger)holesCount {
    self = [super init];
    self->holesCount_ = holesCount;
    return self;
}

- (void)onInit {
    self->eBus_ = [EventBus defaultBus];
    [self registerBusEvents];
    
}

- (void)onUpdate:(NSTimeInterval)dt {}

- (void)onSuccess {}

- (void)onFail {}

- (void)registerBusEvents {
    [self->eBus_ registerListener:self forEventType:kEventCollectMole];
    [self->eBus_ registerListener:self forEventType:kEventSequencerNote];
}


- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    switch (type) {
        case kEventSequencerNote:{
            NoteEvent* nEvt = (NoteEvent*)event;
            NSUInteger targetHoldeIdx = nEvt->identifier % self->holesCount_;
            
            MoleRelease* rlsEvt = [[MoleRelease alloc] init];
            rlsEvt->releaseData.holeIndex = targetHoldeIdx;
            rlsEvt->releaseData.permanenceTime = nEvt->durationTime * 0.5;
            rlsEvt->releaseData.appearanceTime =  nEvt->durationTime * 0.1;
            rlsEvt->releaseData.retreatTime = nEvt->durationTime * 0.2;
            rlsEvt->releaseData.dieTime = nEvt->durationTime * 0.2;
            
            [self->eBus_ queueEvent:rlsEvt];
        }break;
        case kEventCollectMole:{
        }
        default:
            break;
    }
}

@end
