#!/bin/sh

# git-isnewest.sh
#
# A shell script to answer the question:
#
#     "Is the current branch the newest?"
#
# More specifically: "Is the tip of the current branch the most recent
# (in terms of committer date) of all the branches' tips?"
#
# To make a Git alias called 'isnewest' out of this script,
# put the latter on your search path, and run
#
#   git config --global alias.isnewest '!sh git-isnewest.sh'

# Get the current branch.
if git symbolic-ref HEAD >/dev/null; then
  current=$(git symbolic-ref HEAD)
else
  exit $?
fi

# Get the name of the branch whose tip is the most recent of all
# branches' tips.
newest=$(git for-each-ref --count=1               \
                          --sort='-committerdate' \
                          --format='%(refname)'   \
                         refs/heads)

# If "newest" is empty, none of the branches contain commits.
if [ -z "$newest" ]; then
  printf "none of the branches contain commits\n"
  exit 1
fi

# Is the current branch the most recent one?
if [ "$current" = "$newest" ]; then
  printf "yes\n"
else
  printf "no\n"
fi

exit $?
