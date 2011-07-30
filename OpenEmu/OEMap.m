/*
 Copyright (c) 2009, OpenEmu Team
 
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
     * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.
     * Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.
     * Neither the name of the OpenEmu Team nor the
       names of its contributors may be used to endorse or promote products
       derived from this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY OpenEmu Team ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL OpenEmu Team BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "OEMap.h"

#ifndef BOOL_STR
#define BOOL_STR(var) ((var) ? "YES" : "NO")
#endif

typedef BOOL (*_OECompare)(OEMapValue, OEMapValue);

typedef struct {
    OEMapKey    key;
    OEMapValue  value;
    BOOL        allocated;
} OEMapEntry;

BOOL defaultIsEqual(OEMapValue v1, OEMapValue v2)
{
    return v1.key == v2.key && v1.player == v2.player;
}

@interface OEMap ()
{
@package
    size_t      capacity;
    size_t      count;
    OEMapEntry *entries;
    NSLock     *lock;
    _OECompare  valueIsEqual;
}

@end

@implementation OEMap

- (id)init
{
    return [self initWithCapacity:1];
}

- (id)initWithCapacity:(size_t)aCapacity;
{
    if((self = [super init]))
    {
        count        = 0;
        capacity     = aCapacity;
        entries      = malloc(sizeof(OEMapEntry) * capacity);
        valueIsEqual = defaultIsEqual;
        lock         = [[NSLock alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    free(entries);
}

- (NSString *)description
{
    NSMutableString *ret = [NSMutableString stringWithFormat:@"<%@, count: %zu", [super description], count];

    for(size_t i = 0, max = count; i < max; i++)
    {
        OEMapEntry *entry = &entries[i];
        [ret appendFormat:@"entry[%zu] = { .allocated = %s, .key = %ld, .value = { .key = %ld, .player = %ld } }", i, BOOL_STR(entry->allocated), entry->key, entry->value.key, entry->value.player];
    }
    
    return ret;
}

@end

OEMapRef OEMapCreate(size_t capacity)
{
    return [[OEMap alloc] initWithCapacity:capacity];
}

void OEMapRelease(OEMapRef map)
{
    /*
    if(map == NULL) return;
    
    [map->lock release];
    if(map->capacity > 0)
        free(map->entries);
    free(map);
     */
}

// The lock must be acquired before using this function
static void _OEMapSetValue(OEMapRef map, OEMapKey key, OEMapValue value)
{
    if(map == NULL) return;
    
    if(map->count != 0)
    {
        for(size_t i = 0, max = map->count; i < max; i++)
        {
            OEMapEntry *entry = &map->entries[i];
            if(entry->key == key)
            {
                entry->value = value;
                entry->allocated = YES;
                return;
            }
        }
        
        //find the next unallocated spot
        for (int i = 0; i < map->count; i++)
        {
            OEMapEntry *entry = &map->entries[i];
            if(!entry->allocated)
            {
                entry->key = key;
                entry->value = value;
                entry->allocated = YES;
                return;
            }
        }
    }
    
    if(map->count + 1 > map->capacity)
    {
        map->capacity = map->capacity * 2;
        map->entries = realloc(map->entries, sizeof(OEMapEntry) * map->capacity);
    }
    
    OEMapEntry *entry = &map->entries[map->count++];
    entry->value = value;
    entry->key   = key;
    entry->allocated = YES;
}

void OEMapSetValue(OEMapRef map, OEMapKey key, OEMapValue value)
{
    if(map == NULL) return;
    
    [map->lock lock]; 
    _OEMapSetValue(map, key, value);
    [map->lock unlock];
}

BOOL OEMapGetValue(OEMapRef map, OEMapKey key, OEMapValue *value)
{
    if(map == NULL) return NO;
    
    BOOL ret = NO;
    [map->lock lock];
    for(size_t i = 0, max = map->count; i < max; i++)
    {
        OEMapEntry *entry = &map->entries[i];
        if(entry->allocated && entry->key == key)
        {
            *value = entry->value;
            ret = YES;
            break;
        }
    }
    [map->lock unlock];
    return ret;
}

void OEMapSetValueComparator(OEMapRef map, BOOL (*comparator)(OEMapValue, OEMapValue))
{
    if(map == NULL) return;
    
    [map->lock lock];
    map->valueIsEqual = comparator;
    [map->lock unlock];
}

void OEMapRemoveMaskedKeysForValue(OEMapRef map, OEMapKey mask, OEMapValue value)
{
    if(map == NULL) return;
    
    [map->lock lock];
    for(size_t i = 0, max = map->count; i < max; i++)
    {
        OEMapEntry *entry = &map->entries[i];
        if(entry->allocated && map->valueIsEqual(value, entry->value) && entry->key & mask)
            entry->allocated = NO;
    }
    [map->lock unlock];
}

#if 0
void OEMapShowOffContent(OEMapRef map)
{
    if(map == NULL) return;
    
    NSLog(@"Count = %zu", map->count);
    for(size_t i = 0, max = map->count; i < max; i++)
    {
        OEMapEntry *entry = &map->entries[i];
        NSLog(@"entry[%zu] = { .allocated = %s, .key = %d, .value = { .key = %d, .player = %d } }", i, BOOL_STR(entry->allocated), entry->key, entry->value.key, entry->value.player);
    }
}
#endif
