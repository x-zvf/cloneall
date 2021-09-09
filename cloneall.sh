#1/bin/sh
# cloneall.sh - (c)2019 xzvf. (github.com/x-zvf/cloneall)
# LICENSE: MIT, see LICENSE file

clonedir=$(pwd)
username=""
usessh=false
promptpass=false
curlopts=""

usage() {
    echo "cloneall.sh - clone all your github repos at once"
    echo "Usage:"
    echo 'cloneall.sh [(-s|-h)] -u <username> [-p] [-d <directory>]'
    echo 'Options:'
    echo '-s             Use ssh'
    echo '-h             Use http (default)'
    echo '-u <username>  specify the github username to clone all repos from'
    echo '-p             Authenticate as specified user. This is for cloning private repos'
    echo '               and will prompt the user to input their github password.'
    echo '-d <directory> specify the directory to clone all the repos to.'
    echo '               a seperate folder for each repo inside this folder'
    echo '               will still be created. Defaults to current directory.'
    echo 'made by xzvf'

}

# Parse options passed to script
while getopts "shpu:d:" o; do
    case "${o}" in
        h)
            usessh=false
            ;;
        s)
            usessh=true
            ;;
        p)
            promptpass=true
            ;;
        u)
            username=${OPTARG}
            ;;
        d)
            clonedir=${OPTARG}
            ;;
        *)
            echo 'Invalid argument'
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Argument validation
if [ -z $username ];
then
    echo 'Username must not be empty'
    usage
    exit 2
fi

if ! [ -d $clonedir ];
then
    echo 'The directory specified is not valid'
    usage
    exit 3
fi

# Authenticate if required
if $promptpass;
then
    curlopts="$curlopts --user '$username'"
fi

# 100 should be fine for most
res=$(curl $curlopts "https://api.github.com/users/$username/repos?per_page=100")

# Response error handling
if [ -n "$(echo \"$res\"| grep ' \"message\": \"Not Found\"')" ];
then
    echo "User $username not found"
    exit 4
fi

if [ -n "$(echo \"$res\"| grep ' \"message\": \"Bad credentials\"')" ];
then
    echo "Invalid credentials for user $username"
    exit 5
fi

# Parse response
repos=$(echo "$res"| grep full_name | cut -d '"' -f 4)

#echo $res
echo "Found repos:"
echo "$repos"

cd $clonedir

# Clone all found repos
for r in $repos
do
    if $usessh
    then
        git clone "git@github.com:$r.git"
    else
        git clone "https://github.com/$r.git"
    fi
done

