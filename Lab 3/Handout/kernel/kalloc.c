// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

uint64 MAX_PAGES = 0;
uint64 FREE_PAGES = 0;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run
{
    struct run *next;
};

struct
{
    struct spinlock lock;
    struct run *freelist;
    int reference_count[PHYSTOP / PGSIZE]; // Reference count for each physical page
} kmem;

void kinit()
{
    initlock(&kmem.lock, "kmem");
    for (int i = 0; i < PHYSTOP / PGSIZE; i++) {
        kmem.reference_count[i] = 0; // Initialize reference counts to 0
    }
    freerange(end, (void *)PHYSTOP);
    MAX_PAGES = FREE_PAGES;
}

void freerange(void *pa_start, void *pa_end)
{
    char *p;
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    {
        kfree(p);
    }
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    if (MAX_PAGES != 0)
        assert(FREE_PAGES < MAX_PAGES);
    struct run *r;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    // Decrement reference count and only free the page if the count reaches 0
    acquire(&kmem.lock);
    int page_index = (uint64)pa / PGSIZE;
    if (kmem.reference_count[page_index] > 0) {
        kmem.reference_count[page_index]--;
    }
    if (kmem.reference_count[page_index] == 0) {
        // Fill with junk to catch dangling refs.
        memset(pa, 1, PGSIZE);

        r = (struct run *)pa;
        r->next = kmem.freelist;
        kmem.freelist = r;
        FREE_PAGES++;
    }
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    assert(FREE_PAGES > 0);
    struct run *r;

    acquire(&kmem.lock);
    r = kmem.freelist;
    if (r) {
        kmem.freelist = r->next;
        int page_index = (uint64)r / PGSIZE;
        kmem.reference_count[page_index] = 1; // Initialize reference count to 1
    }
    release(&kmem.lock);

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    FREE_PAGES--;
    return (void *)r;
}

// Increment reference count for a physical page
void
incref(void *pa) {
    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("incref: invalid physical address");

    acquire(&kmem.lock);
    int page_index = (uint64)pa / PGSIZE;
    kmem.reference_count[page_index]++;
    release(&kmem.lock);
}

// Decrement reference count for a physical page
void
decref(void *pa) {
    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("decref: invalid physical address");

    acquire(&kmem.lock);
    int page_index = (uint64)pa / PGSIZE;
    if (kmem.reference_count[page_index] > 0) {
        kmem.reference_count[page_index]--;
    }
    if (kmem.reference_count[page_index] == 0) {
        // Free the page if the reference count reaches 0
        struct run *r = (struct run *)pa;
        r->next = kmem.freelist;
        kmem.freelist = r;
        FREE_PAGES++;
    }
    release(&kmem.lock);
}