//
//  SequenceGenerator.m
//  Moles
//
//  Created by William Izzo on 10/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "SequenceGenerator.h"
#import "EventBus.h"
#import "AddSequencerEvent.h"
#import "TempoData.h"
#import "Perceptron.hpp"

@interface SequenceGenerator() {
    EventBus* eBus_;
    TempoData tempoData_;
    NSTimeInterval lastEventTimestamp;
    NoteName selectedTones[12];
    NSUInteger lastNoteIndex;
    molegame::misc::Perceptron<2> repetitionPerc;
}


@end

@implementation SequenceGenerator
- (instancetype)init {
    self = [super init];
    return self;
}


- (void)onInit {
    self->eBus_ = [EventBus defaultBus];
    self->tempoData_ = MakeTempoDataFromBpm(65.0);
    self->selectedTones[0] = NoteName_G_f;
    self->selectedTones[1] = NoteName_A;
    self->selectedTones[2] = NoteName_G;
    self->selectedTones[3] = NoteName_F;
    self->selectedTones[4] = NoteName_B;
    self->selectedTones[5] = NoteName_E;
    self->selectedTones[6] = NoteName_D;
    self->selectedTones[7] = NoteName_D_f;
    self->selectedTones[8] = NoteName_A_f;
    self->selectedTones[9] = NoteName_C_f;
    self->selectedTones[10] = NoteName_C;
    self->selectedTones[11] = NoteName_F_f;
    self->lastNoteIndex = 0;
}

- (void)onUpdate:(NSTimeInterval)dt {
    const NSUInteger notesPerTick = 12;
    
    
    for (NSUInteger note = 0; note < notesPerTick; ++note) {
        NoteName noteName = self->selectedTones[self->lastNoteIndex];
        
        AddSequencerEvent* addSeqEvt =
        [AddSequencerEvent addNoteEventNamed:noteName
                                      atTime:self->lastEventTimestamp
                                withDuration:self->tempoData_.quarterNoteTime];
        
        
        self->lastEventTimestamp += self->tempoData_.quarterNoteTime;
        self->lastNoteIndex = (self->lastNoteIndex + 1) % 12;
        
        [self->eBus_ queueEvent:addSeqEvt];
    }
    
    
    
}


@end
