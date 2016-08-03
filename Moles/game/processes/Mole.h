//
//  Mole.h
//  Moles
//
//  Created by William Izzo on 31/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "Process.h"
#import <UIKit/UIKit.h>
@interface Mole : Process {
    
}
- (instancetype)initWithHoleView:(UIView*)holeView
                       holeIndex:(NSUInteger)holeIndex;

@property (readonly, nonatomic) NSUInteger holeIndex;
@end
