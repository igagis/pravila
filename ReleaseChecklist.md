#Release checklist

- add new entry to debian/changelog file if it has not beed added yet:

	```
	dch -v"1.0.1" "Unique added"
	```

- add what has been done in this release if not there yet:

	```
	dch -a "important bug fixes"
	```

- mark debian/changelog entry as released:

	```
	dch -r -D unstable ""
	```

- Check if SO-name needs increment and update src/soname.txt if needed

- commit to version control system

- make version tag in version control system
