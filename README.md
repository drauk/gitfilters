# gitfilters
Some smudge-and-clean filters for Git working directories.

Converts keywords of the form &#x24;Id&#x24; in source files in Git working directories to Subversion-like revision/time/author strings.

Example of the effect of **svnid.smudge.pl**:

&#x24;Id: doc/makefile 9e2eb0a 2017-08-29 16:45:57Z Alan U. Kennington &#x24;

1. The subversion-style file name **makefile** is replaced by a relative path **doc/makefile**.
2. The subversion-style revision number is replaced by a short commit-hash **9e2eb0a** because Git does not have revision numbers.
3. The UTC date and time are the same as in Subversion.
4. The author name is used instead of the Subversion-style Unix account username.

Note that Subversion expands keywords whenever you do a commit, but Git only runs smudge filters when you do a checkout. So if you want the keywork expansion to reflect the commit-hash and commit-time of the latest commit, you must force a checkout, for example by running the "touch" command on the recently committed files and then running git checkout on those files.
