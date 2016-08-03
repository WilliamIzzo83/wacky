//
//  Event.h
//  Moles
//
//  Created by William Izzo on 29/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEvent.h"

static const NSUInteger kEventInvalid = 0x0;

/**
 * Abstract event class. It provides base implementation of IEvent interface.
 * @note Being abstract is not meant to be instantiated. 
 */
@interface Event : NSObject<IEvent>
@property(assign, nonatomic) NSTimeInterval timestamp;
@end
