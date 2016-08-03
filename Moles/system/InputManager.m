//
//  InputManager.m
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "InputManager.h"
#import "EventBus.h"
#import "GameTickEvent.h"

typedef NSMutableArray<id<IEvent>> IMInputQueue;

@interface InputManager()<EventBusDelegate> {
    BOOL paused;
}

@property (strong, nonatomic) IMInputQueue* inputQueue;
@end

@implementation InputManager

- (void)startUp {
    self->paused = NO;
    self.inputQueue = [IMInputQueue array];
    [[EventBus defaultBus] registerListener:self
                               forEventType:kEventGameTick];
}

- (void)enqueueInputEvent:(id<IEvent>)event {
    if (paused == YES) {
        return;
    }
    
    [self.inputQueue addObject:event];
}

- (void)update:(NSTimeInterval)dt {
    for (id<IEvent> iEvent in self.inputQueue) {
        [[EventBus defaultBus] queueEvent:iEvent];
    }
    [self.inputQueue removeAllObjects];
}

- (void)pause {
    self->paused = !self->paused;
}

- (void)shutDown {
    self.inputQueue = nil;
}

- (void)receivedEvent:(id<IEvent>)event withType:(NSUInteger)type {
    if ([event type] == kEventGameTick) {
        [self update:0];
    }
}
@end
