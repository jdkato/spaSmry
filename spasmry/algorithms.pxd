from libc.stdint cimport uint64_t

cdef struct RankedSentence:
    # The sentences index within its `Doc` object.
    uint64_t index

    # A score indicating the relevance of this sentence.
    float score
