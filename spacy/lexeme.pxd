from libc.stdint cimport uint64_t

# Put these above import to avoid circular import problem
ctypedef int ClusterID
ctypedef uint64_t StringHash
ctypedef size_t Lexeme_addr

from spacy.spacy cimport Language

cdef struct Lexeme:
    StringHash sic # Hash of the original string
    StringHash lex # Hash of the word, with punctuation and clitics split off
    StringHash normed # Hash of the normalized version of lex
    StringHash last3 # Last 3 characters of the token
    Py_UNICODE first # First character of the token

    double prob # What is the log probability of the lex value?
    ClusterID cluster # Brown cluster of the token

    bint oft_upper # Is the lowered version of the lex value often in all caps?
    bint oft_title # Is the lowered version of the lex value often title-cased?
    Lexeme* tail # Lexemes are linked lists, to deal with sub-tokens


cdef Lexeme BLANK_WORD = Lexeme(0, 0, 0, 0, 0, 0.0, 0, False, False, NULL)

cdef Lexeme* init_lexeme(Language lang, unicode string, StringHash hashed,
                         int split, size_t length)
 
# Use these to access the Lexeme fields via get_attr(Lexeme*, LexAttr), which
# has a conditional to pick out the correct item.  This allows safe iteration
# over the Lexeme, via:
# for field in range(LexAttr.n): get_attr(Lexeme*, field)
cdef enum HashFields:
    sic
    lex
    normed
    cluster
    n


#cdef uint64_t get_attr(Lexeme* word, HashFields attr)
