#!/bin/bash

PATH1="ess_vocabs"
PATH2="ess_vocabs"
LANGS="en es pt fr it ko"

declare -a TTLINPUTS=("${PATH1}/essglobal-vocab.ttl" \
        "${PATH2}/activities.ttl" \
        "${PATH2}/activities-modified.ttl" \
        "${PATH2}/activities-ica.ttl" \
        "${PATH2}/legal-form.ttl" \
        "${PATH2}/organisational-structure.ttl" \
        "${PATH2}/base-membership-type.ttl" \
        "${PATH2}/qualifiers.ttl" \
        "${PATH2}/type-of-labour.ttl")

for lang in $LANGS; do
    ruby bin/goth "${TTLINPUTS[@]}" -l "$lang" > "essglobal-vocab_$lang.html"
done
