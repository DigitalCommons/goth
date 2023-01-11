#!

PATH1="lib/goth/assets/ess_vocabs"
PATH2="lib/goth/assets/ess_vocabs"

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

ruby bin/goth ${TTLINPUTS[@]} -l en -t lib/goth/assets/esstemplate.erb > essglobal-vocab_en.html
ruby bin/goth ${TTLINPUTS[@]} -l es -t lib/goth/assets/esstemplate.erb > essglobal-vocab_es.html
ruby bin/goth ${TTLINPUTS[@]} -l it -t lib/goth/assets/esstemplate.erb > essglobal-vocab_it.html
ruby bin/goth ${TTLINPUTS[@]} -l fr -t lib/goth/assets/esstemplate.erb > essglobal-vocab_fr.html
ruby bin/goth ${TTLINPUTS[@]} -l pt -t lib/goth/assets/esstemplate.erb > essglobal-vocab_pt.html
ruby bin/goth ${TTLINPUTS[@]} -l ko -t lib/goth/assets/esstemplate.erb > essglobal-vocab_ko.html