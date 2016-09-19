//
//  SequenceData.m
//  Moles
//
//  Created by William Izzo on 07/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "SequenceData.h"

@interface SequenceData()
- (void)appendGenericEvent:(SequencerEvent*)event;
@property (strong, nonatomic) NSMutableArray<SequencerEvent*>* events;
@end

@implementation SequenceData
- (instancetype)init {
    self = [super init];
    self.events = [NSMutableArray<SequencerEvent*> array];
    return self;
}

- (void)addEvent:(SequencerEvent*)event {
    [self.events addObject:event];
    self->_sequenceDuration += event->durationTime;
}

- (void)appendGenericEvent:(SequencerEvent*)event {
    SequencerEvent* lastEvt = [self.events lastObject];
    if (lastEvt) {
        event->startTime = lastEvt->startTime + lastEvt->durationTime;
    }
    
    [self addEvent:event];
}

- (void)appendEvent:(NSTimeInterval)duration {
    SequencerEvent* evt = [[SequencerEvent alloc] init];
    evt->durationTime = duration;
    
    [self appendGenericEvent:evt];
}

- (void)appendPause:(NSTimeInterval)duration {
    PauseEvent* pEvt = [[PauseEvent alloc] init];
    pEvt->durationTime = duration;
    [self appendGenericEvent:pEvt];
}

- (void)appendNote:(NSTimeInterval)duration
          withName:(NoteName)name {
    NoteEvent* nEvt = [NoteEvent eventWithNoteName:name];
    nEvt->durationTime = duration;
    [self appendGenericEvent:nEvt];
}

- (void)appendNote:(NSTimeInterval)duration {
    [self appendNote:duration
            withName:NoteName_A];
}

- (NSArray<SequencerEvent*>*)eventsInTimeRange:(TimeRange)range {
    NSMutableArray<SequencerEvent*>* eventsInRange =
    [NSMutableArray<SequencerEvent*> array];
    for (SequencerEvent* event in self.events) {
        if (event->startTime >= range.from &&
            event->startTime < range.to) {
            [eventsInRange addObject:event];
        }
    }
    
    return eventsInRange;
}

@end
