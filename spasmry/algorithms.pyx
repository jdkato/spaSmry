from collections import defaultdict

from libcpp.pair cimport pair
from libcpp.queue cimport priority_queue

from cymem.cymem cimport Pool
from spacy.tokens.doc cimport Doc
from spacy.tokens.token cimport Token
from spacy.tokens.span cimport Span


cdef top_n(RankedSentence* sentences, int size, int n):
    """Return the top-n sentences according their scores.
    """
    # We use a `priority_queue` to allow us to find the top-n sentences without
    # having to sort the entire array.
    cdef priority_queue[pair[float, int]] queue
    cdef pair[float, int] entry
    cdef int i

    for i in range(size):
        entry.first = sentences[i].score
        entry.second = i
        queue.push(entry)

    top = []
    for i in range(n):
        top.append(queue.top().second)
        queue.pop()

    return top


cpdef smmry(Doc doc, int n):
    """Summarize `doc` using an approach similar to the SMMRY algorithm.

    See https://smmry.com/about for more details.
    """
    cdef Pool mem = Pool()
    cdef Token token
    cdef Span sent
    cdef int i

    tokens = defaultdict(int)
    for token in doc:
        if token.is_alpha:
            tokens[token.lower_] += 1

    sentences = tuple(doc.sents)
    size = len(sentences)

    ranked = <RankedSentence*>mem.alloc(size, sizeof(RankedSentence))
    for i, sent in enumerate(sentences):
        ranked[i].index = i
        ranked[i].score = sum([tokens[w.lower_] for w in sent])

    return [sentences[i] for i in top_n(ranked, size, n)]


