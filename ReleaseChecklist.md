#Release checklist

- add new entry to debian/changelog file if it has not beed added yet:

	```
	dch -v"1.0.1-1" "Unique added"
	```

- add what has been done in this release if not there yet:

	```
	dch -a "important bug fixes"
	```

- mark debian/changelog entry as released:

	```
	dch -r -D stable ""
	```

- update the version in all places where needed:

	```
	make ver
	```

- Check if SO-name needs increment and update src/soname.txt if needed

- commit to version control system

- make version tag in version control system

- generate debian package:

	```
	make deb
	```

- update formula in homebrew-tap

- generate NuGet package
	```
	Write-NuGetPackage nuget.autopkg
	```
