//
//  SequencerEvent.h
//  Moles
//
//  Created by William Izzo on 07/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"

static NSUInteger kEventSequencerAny = 0x00000009;

@interface SequencerEvent : Event {
@public
    NSTimeInterval startTime;
    NSTimeInterval durationTime;
}
@end
