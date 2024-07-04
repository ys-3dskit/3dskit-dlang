/**
 * @file mappable.h
 * @brief Mappable memory allocator.
 */

extern (C):

/**
 * @brief Initializes the mappable allocator.
 * @param addrMin Minimum address.
 * @param addrMax Maxium address.
 */
void mappableInit (uint addrMin, uint addrMax);

/**
 * @brief Finds a mappable memory area.
 * @param size Size of the area to find.
 * @return The mappable area.
 */
void* mappableAlloc (size_t size);

/**
 * @brief Frees a mappable area (stubbed).
 * @param mem Mappable area to free.
 */
void mappableFree (void* mem);
