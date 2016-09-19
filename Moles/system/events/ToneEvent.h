//
//  ToneEvent.h
//  Moles
//
//  Created by William Izzo on 18/09/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"

static const NSUInteger kEventTone = 0x0000A000;

@interface ToneEvent : Event{
@public
    float pitch;
    double duration;
}
@end
