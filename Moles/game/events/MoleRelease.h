//
//  MoleRelease.h
//  Moles
//
//  Created by William Izzo on 03/08/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Event.h"
#import "MoleReleaseData.h"
static const NSUInteger kEventMoleRelease = 0x00000008;

@interface MoleRelease : Event {
@public
    MoleReleaseData releaseData;
}
@end
