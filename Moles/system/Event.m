//
//  Event.m
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"
@interface Event()
@end

@implementation Event
- (instancetype)init {
    self = [super init];
    self->_timestamp = 0.0;
    return self;
}

- (NSTimeInterval)timestamp {
    return self->_timestamp;
}

- (NSUInteger)type {
    return kEventInvalid;
}

@end
