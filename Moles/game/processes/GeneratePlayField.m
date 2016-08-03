//
//  GeneratePlayField.m
//  Moles
//
//  Created by William Izzo on 30/07/16.
//  Copyright © 2016 wizzo. All rights reserved.
//

#import "GeneratePlayField.h"
@interface GeneratePlayField(){
    NSMutableArray* __weak holesViewRefs;
}
@property (weak, nonatomic) UIView* view;
@end

@implementation GeneratePlayField
- (instancetype)initWithGameView:(UIView *)view
                 andHolesViewRef:(NSMutableArray *)holesRef {
    self = [super init];
    self.view = view;
    self->holesViewRefs = holesRef;
    
    return self;
}

- (void)onUpdate:(NSTimeInterval)dt {
    const NSUInteger unitCount = 3;
    const NSUInteger gridElementsCount = unitCount * unitCount;
    
    const CGFloat sz = (CGFloat)unitCount;
    
    const CGSize gridSize = CGSizeMake(sz, sz);
    
    CGRect gameViewFrame = self.view.frame;
    CGSize tileSize = CGSizeMake(gameViewFrame.size.width / gridSize.width,
                                 gameViewFrame.size.height / gridSize.height);
    
    for (NSUInteger tidx = 0; tidx < gridElementsCount; ++tidx) {
        NSUInteger xIdx = tidx % unitCount;
        NSUInteger yIdx = tidx / unitCount;
        
        CGRect tileFrame = CGRectMake((CGFloat)xIdx * tileSize.width,
                                      (CGFloat)yIdx * tileSize.height,
                                      tileSize.width,
                                      tileSize.height);
        
        UIView* tileView = [[UIView alloc] initWithFrame:tileFrame];
        tileView.layer.borderWidth = 1.0;
        tileView.layer.borderColor = [[UIColor blackColor] CGColor];
        tileView.layer.cornerRadius = tileSize.width / 2.0;
        [self->holesViewRefs addObject:tileView];
        [self.view addSubview:tileView];
    }
    
    [self success];
}
@end
