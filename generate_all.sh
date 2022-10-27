#!/bin/bash

PATH1="ess_vocabs"
PATH2="ess_vocabs"
LANGS="en es pt fr it ko"

### Change PATHs as required.
### Default PATHs point to the input examples included with GOTH,
### this data was taken from the SEA repository PATHs below:
### PATH1=SolidarityEconomyAssociation/map-sse/tree/ica10-draft-locality-vocabs/vocabs/vocab/
### PATH2=SolidarityEconomyAssociation/map-sse/blob/ica10-draft-locality-vocabs/vocabs/standard/

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
