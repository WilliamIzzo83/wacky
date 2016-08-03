//
//  CollectMole.h
//  Moles
//
//  Created by William Izzo on 31/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"

static const NSUInteger kEventCollectMole = 0x00000006;

@interface CollectMole : Event{
@public
    NSUInteger holeIndex;
}
@end
