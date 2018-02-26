# coding: utf8
from __future__ import unicode_literals
from spacy.tokens import Doc

from .about import __version__
from .algorithms import smmry


__all__ = ['Summary']


class Summary(object):
    """spaCy v2.0 pipeline component for summarizing text.

    USAGE:
        >>> import spacy
        >>> from spasmry import Summary
        >>> nlp = spacy.load('en')
        >>> nlp.add_pipe(Summary(), first=True)
        >>> doc = nlp(u"This is a test")
        >>> doc._.summarize
        [<Span>, ...]
    """
    name = 'summary'

    def __init__(self, algorithm='smmry', cutoff=7):
        self._algorithm = algorithm
        self._cutoff = cutoff

        Doc.set_extension('summarize', getter=self.summarize)

    def __call__(self, doc):
        return doc

    def summarize(self, doc):
        return smmry(doc, self._cutoff)
