//
//  TapEvent.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"
#import <CoreGraphics/CoreGraphics.h>

static const NSUInteger kEventTap = 0x00000002;

@interface TapEvent : Event
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@end
