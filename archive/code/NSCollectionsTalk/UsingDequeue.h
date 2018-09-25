//
//  UsingDequeue.h
//  deleteme
//
//  Created by Josh Smith on 9/25/13.
//  Copyright (c) 2013 Josh Smith. All rights reserved.
//

#ifndef __deleteme__UsingDequeue__
#define __deleteme__UsingDequeue__

@interface UsingDequeue : NSEnumerator

/*! push the object onto the back
 */
- (void) push:(id) obj;

/*! pop the last item from the back 
 */
- (id) pop;

/*! length of the collection */
- (NSInteger) length;

/*! The first item in the queue.
 This does not alter the queue.
 */
- (id) first;

/*! The last item in the queue.
 This does not alter the queue.
 */
- (id) last;

/*! returns the object at the given index.
 */
- (id) objectAtIndex:(NSInteger) idx;
@end

#endif /* defined(__deleteme__UsingDequeue__) */
