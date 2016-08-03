//
//  GameTickEvent.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"

static const NSUInteger kEventGameTick = 0x00000001;

/**
 * GameTickEvent is sent by the GameLooper on each vSync.
 */
@interface GameTickEvent : Event
/// Elapsed time since the previous tick
@property (assign, nonatomic) NSTimeInterval dt;
@end
