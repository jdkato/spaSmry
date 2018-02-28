from collections import defaultdict

from libcpp.pair cimport pair
from libcpp.queue cimport priority_queue

from spacy.tokens.doc cimport Doc
from spacy.tokens.token cimport Token
from spacy.tokens.span cimport Span


cpdef smmry(Doc doc, int n):
    """Summarize `doc` using an approach similar to the SMMRY algorithm.

    See https://smmry.com/about for more details.
    """
    # We use a `priority_queue` to allow us to find the top-n sentences without
    # having to sort the entire array.
    cdef priority_queue[pair[float, int]] queue
    cdef pair[float, int] entry

    cdef Token token
    cdef Span sent
    cdef int i

    tokens = defaultdict(int)
    for token in doc:
        if token.is_alpha:
            tokens[token.lower_] += 1

    sentences = tuple(doc.sents)
    size = len(sentences)

    for i, sent in enumerate(sentences):
        entry.first = sum([tokens[w.lower_] for w in sent])
        entry.second = i
        queue.push(entry)

    top = []
    for i in range(n):
        top.append(queue.top().second)
        queue.pop()

    return [sentences[i] for i in top]
