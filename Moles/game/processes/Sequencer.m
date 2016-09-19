//
//  Sequencer.m
//  Moles
//
//  Created by William Izzo on 03/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Sequencer.h"
#import "EventBus.h"
#import "CollectMole.h"
#import "MoleRelease.h"
#import "SequenceData.h"
#import "TempoData.h"
#import "AddSequencerEvent.h"

@interface Sequencer()<EventBusDelegate> {
    __weak EventBus* eBus_;
    NSTimeInterval elapsedTime_;
    SequenceData* sequence_;
}

@end

@implementation Sequencer
- (instancetype)init{
    self = [super init];
    return self;
}

- (void)onInit {
    
    self->eBus_ = [EventBus defaultBus];
    
    [self->eBus_ registerListener:self
                     forEventType:kEventAddSequencerEvent];
    
    self->elapsedTime_ = 0.0;
    
    self->sequence_ = [[SequenceData alloc] init];
}


- (void)onUpdate:(NSTimeInterval)dt {
    
    if (self->elapsedTime_ >= self->sequence_.sequenceDuration) {
        self->elapsedTime_ = 0.0;
    }
    
    TimeRange tr = {
        self->elapsedTime_,
        self->elapsedTime_ + dt
    };
    
    self->elapsedTime_ += dt;
    
    NSArray<SequencerEvent*>* seqEvts =
    [self->sequence_ eventsInTimeRange:tr];
    
    for (SequencerEvent* sEvt in seqEvts) {
        [self->eBus_ queueEvent:sEvt];
    }
}

- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    assert(type == kEventAddSequencerEvent);
    AddSequencerEvent* asEvt = (AddSequencerEvent*)event;
    
    [self->sequence_ addEvent:asEvt.event];
}

@end


