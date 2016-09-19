//
//  SequenceData.h
//  Moles
//
//  Created by William Izzo on 07/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SequencerEvent.h"
#import "NoteEvent.h"
#import "PauseEvent.h"
#import "TimeRange.h"

NS_ASSUME_NONNULL_BEGIN

@interface SequenceData : NSObject
- (void)addEvent:(SequencerEvent*)event;
- (void)appendEvent:(NSTimeInterval)duration;
- (void)appendPause:(NSTimeInterval)duration;
- (void)appendNote:(NSTimeInterval)duration;
- (void)appendNote:(NSTimeInterval)duration
          withName:(NoteName)name;
- (NSArray<SequencerEvent*>*)eventsInTimeRange:(TimeRange)range;

@property (readonly, nonatomic) NSTimeInterval sequenceDuration;
@end

NS_ASSUME_NONNULL_END
