//
//  UsingDequeue.cpp
//  deleteme
//
//  Created by Josh Smith on 9/25/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#include <deque>

#include "UsingDequeue.h"

@interface UsingDequeue ()
@property (assign) std::deque<CFTypeRef> *internaldat;
@property (assign) int currentIndex;
@end

@implementation UsingDequeue

- (id) init {
    if (self = [super init]) {
        self.currentIndex = 0;
        self.internaldat = new std::deque<CFTypeRef>;
    }
    return self;
}

- (id) nextObject {
    id res = nil;
    if (self.currentIndex >= [self length]) {
        self.currentIndex = 0;
    } else {
        res = [self objectAtIndex:self.currentIndex];
    }
    self.currentIndex++;
    return res;
}

- (void) push:(id)obj {
    self.internaldat->push_back((__bridge CFTypeRef)obj);
}

- (NSInteger) length {
    return self.internaldat->size();
}

- (id) pop {
    CFTypeRef r = self.internaldat->back();
    self.internaldat->pop_back();
    return (id)CFBridgingRelease(r);
}

- (id) first {
    CFTypeRef r = self.internaldat->front();
    return (id) CFBridgingRelease(r);
}

- (id) last {
    CFTypeRef r = self.internaldat->back();
    return (id) CFBridgingRelease(r);
}

- (id) objectAtIndex:(NSInteger)idx {
    if (idx > self.internaldat->size()) {
        return nil;
    } if (idx < 0) {
        return nil;
    } else {
        return (id) CFBridgingRelease(self.internaldat->at(idx));
    }
}
@end
