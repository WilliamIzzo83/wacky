//
//  NoteEvent.h
//  Moles
//
//  Created by William Izzo on 08/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "SequencerEvent.h"

static const NSUInteger kEventSequencerNote = 0x0000000B;

typedef enum NoteName {
    NoteName_C = 40,
    NoteName_C_f = 41,
    NoteName_D = 42,
    NoteName_D_f = 43,
    NoteName_E = 44,
    NoteName_F = 45,
    NoteName_F_f = 46,
    NoteName_G = 47,
    NoteName_G_f = 48,
    NoteName_A = 49,
    NoteName_A_f = 50,
    NoteName_B = 51,
} NoteName;



@interface NoteEvent : SequencerEvent{
@public
    NoteName identifier;
    double pitch;
}

+ (NoteEvent*)eventWithNoteName:(NoteName)noteName;
@end
