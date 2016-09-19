//
//  CountDown.m
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "CountDown.h"
#import "EventBus.h"
#import "CountdownEndedEvent.h"

@interface CountDown() {
    NSTimeInterval countDownDuration;
    NSTimeInterval elapsedTime;
}
@end
@implementation CountDown

- (void)onInit {
    self->countDownDuration = 3.0; // 3 seconds
    self->elapsedTime = 0.0;
}

- (void)onUpdate:(NSTimeInterval)dt {
    
    if (self->elapsedTime > self->countDownDuration) {
        CountdownEndedEvent* cde = [[CountdownEndedEvent alloc] init];
        [[EventBus defaultBus] queueEvent:cde];
        [self success];
    }
    
    self->elapsedTime+=dt;
}

@end
