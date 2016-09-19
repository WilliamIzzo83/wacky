//
//  NoteEvent.m
//  Moles
//
//  Created by William Izzo on 08/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "NoteEvent.h"
static const uint32_t kPianoKeyCount = 88;
static const double kMiddleAPitch = 440.0; // would love to play with this.
// 88 as the number of keys on a piano
static double notePitches[kPianoKeyCount];

static double notePitch(uint32_t pianoKey) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        for (uint32_t k = 0; k < kPianoKeyCount; ++k) {
            double exponent = ((double)k - 49.0) / 12.0;
            notePitches[k] = pow(2.0, exponent) * kMiddleAPitch;
        }
    });
    
    return notePitches[pianoKey];
}

@implementation NoteEvent

+ (NoteEvent*)eventWithNoteName:(NoteName)noteName {
    NoteEvent* evt = [[NoteEvent alloc] init];
    evt->identifier = noteName;
    evt->pitch = notePitch((uint32_t)noteName);
    return evt;
}

- (NSUInteger)type {
    return kEventSequencerNote;
}

@end
