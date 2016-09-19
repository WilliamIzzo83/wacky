//
//  TempoData.h
//  Moles
//
//  Created by William Izzo on 10/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct TempoData {
    NSTimeInterval wholeNoteTime;
    NSTimeInterval quarterNoteTime;
    NSTimeInterval halfNoteTime;
    NSTimeInterval eigthNoteTime;
    NSTimeInterval sixteenthNoteTime;
} TempoData;

NS_INLINE
TempoData MakeTempoDataFromBpm (NSTimeInterval bpm) {
    TempoData data;
    
    NSTimeInterval quarterTime = 60.0 / bpm;
    
    data.wholeNoteTime = quarterTime * 4.0;
    data.halfNoteTime = quarterTime * 2.0;
    data.quarterNoteTime = quarterTime;
    data.eigthNoteTime = quarterTime / 2.0;
    data.sixteenthNoteTime = quarterTime / 4.0;
    
    return data;
}
