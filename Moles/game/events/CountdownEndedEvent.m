//
//  CountdownEndedEvent.m
//  Moles
//
//  Created by William Izzo on 17/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "CountdownEndedEvent.h"

@implementation CountdownEndedEvent
- (NSUInteger)type {
    return kEventCountdownEnded;
}
@end
