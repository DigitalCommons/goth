# TESTS

Currently there is a single regression test in `tests/regression_test.sh`.

This is insufficient, however, and more tests are warranted. Suggested
tactic is to borrow the test framework in another project. (Perhaps [this][1].)

[1]: https://github.com/DigitalCommons/se-open-data/

## USAGE

To run this from the repository top-level directory, first install the dependencies:

    bundle install

Then execute it with those dependencies:

    bundle exec tests/regression_test.sh
	
The test runs `goth` against some snapshots of current (at the time of
writing) vocab TTL files in `tests/ess_vocabs`, generating HTML
documentation for each of a set of languages in `tests/out`, then
compares these against snapshots of the expected output in
`tests/expected`, outputting a diff if there are changes.

You should see output something like this if it succeeds:

	## tests/out/essglobal-vocab_en.html: matches expected
	## tests/out/essglobal-vocab_es.html: matches expected
	## tests/out/essglobal-vocab_pt.html: matches expected
	## tests/out/essglobal-vocab_fr.html: matches expected
	## tests/out/essglobal-vocab_it.html: matches expected
	## tests/out/essglobal-vocab_ko.html: matches expected

If you wish, you can inspect the generated output in `tests/out`
afterwards. Note that this directory is deleted and re-created before
the test runs.
