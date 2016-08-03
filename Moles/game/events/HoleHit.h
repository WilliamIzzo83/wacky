//
//  HoleHit.h
//  Moles
//
//  Created by William Izzo on 31/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"

static const NSUInteger kEventHoleHit = 0x00000004;

@interface HoleHit : Event {
@public
    NSUInteger holeIndex;
}
@end
