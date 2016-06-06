//
//  CounterGraph.h
//  Communicator
//
//  Created by mac on 05/06/16.
//  Copyright © 2016 Xanadutec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CounterGraph : NSObject

@property(nonatomic,strong)UILabel* counterGraphlabel;
@property(nonatomic,strong)UIView* referenceForCounterGraphView;
@property(nonatomic)long count;
@end
