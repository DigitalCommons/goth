#!/bin/bash

SCRIPT=${BASH_SOURCE[0]}
DIR=${SCRIPT%/*}

LANGS="en es pt fr it ko"

declare -a TTLINPUTS=(
    "$DIR/ess_vocabs/essglobal-vocab.ttl"
    "$DIR/ess_vocabs/activities.ttl"
    "$DIR/ess_vocabs/activities-modified.ttl"
    "$DIR/ess_vocabs/activities-ica.ttl"
    "$DIR/ess_vocabs/legal-form.ttl"
    "$DIR/ess_vocabs/organisational-structure.ttl"
    "$DIR/ess_vocabs/base-membership-type.ttl"
    "$DIR/ess_vocabs/qualifiers.ttl"
    "$DIR/ess_vocabs/type-of-labour.ttl"
)

rm -rf "$DIR/out"
mkdir "$DIR/out"

for lang in $LANGS; do
    OUT="$DIR/out/essglobal-vocab_$lang.html"
    EXPECTED="$DIR/expected/essglobal-vocab_$lang.html"
    ruby bin/goth "${TTLINPUTS[@]}" -l "$lang" > "$OUT"
    if diff -qu "$OUT" "$EXPECTED"
    then
	echo "## $OUT: matches expected"
    else
	echo "## $OUT: differs from $EXPECTED"
	diff -u "$OUT" "$EXPECTED"	
    fi
done


