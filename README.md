# cloneall.sh - a small script to clone all of your github repositories at once
![Project State](https://img.shields.io/badge/Working%3F-yes-green.svg)
![Maintenance](https://img.shields.io/badge/Maintained%3F-nope-orange.svg)
## Usage
```
cloneall.sh [(-s|-h)] -u <username> [-p] [-d <directory>]
Options:
-s             Use ssh
-h             Use http (default)
-u <username>  specify the github username to clone all repos from
-p             Authenticate as specified user. This is for cloning private repos
               and will prompt the user to input their github password.
-d <directory> specify the directory to clone all the repos to.
               a seperate folder for each repo inside this folder
               will still be created. Defaults to current directory.
```

## Warning
This script does not work with 2FA yet, and it is using deprecated HTTP authentication.

## LICENSE
Licensed under the MIT license, see LICENSE file.

## Contributing
If you found a way to improve this script, just make a pr.
