//
//  AddSequenceEvent.m
//  Moles
//
//  Created by William Izzo on 10/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "AddSequencerEvent.h"

@implementation AddSequencerEvent

+ (instancetype)addNoteEventNamed:(NoteName)name
                           atTime:(NSTimeInterval)time
                     withDuration:(NSTimeInterval)duration{
    
    NoteEvent* nEvt = [NoteEvent eventWithNoteName:name];
    nEvt->startTime = time;
    nEvt->durationTime = duration;
    
    AddSequencerEvent* addEvt = [[AddSequencerEvent alloc] init];
    addEvt->_event = nEvt;
    return addEvt;
}

+ (instancetype)addPauseEventAtTime:(NSTimeInterval)time
                       withDuration:(NSTimeInterval)duration {
    
    PauseEvent* pEvt = [[PauseEvent alloc] init];
    pEvt->startTime = time;
    pEvt->durationTime = duration;
    
    AddSequencerEvent* addEvt = [[AddSequencerEvent alloc] init];
    addEvt->_event = pEvt;
    return addEvt;
}

- (NSUInteger)type { return kEventAddSequencerEvent; }

@end
