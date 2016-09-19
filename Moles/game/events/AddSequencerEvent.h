//
//  AddSequenceEvent.h
//  Moles
//
//  Created by William Izzo on 10/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"
#import "NoteEvent.h"
#import "PauseEvent.h"

static const NSUInteger kEventAddSequencerEvent = 0x0000000C;

@interface AddSequencerEvent : Event

+ (instancetype)addNoteEventNamed:(NoteName)name
                           atTime:(NSTimeInterval)time
                     withDuration:(NSTimeInterval)duration;

+ (instancetype)addPauseEventAtTime:(NSTimeInterval)time
                       withDuration:(NSTimeInterval)duration;

@property (readonly, nonatomic) SequencerEvent* event;

@end
