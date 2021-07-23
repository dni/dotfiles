# my little update notes

# move master to v8 branch
git branch -c master v8
git push origin v8

# merge v9 into master
git checkout master
git reset --hard
git merge v9 --unrelated-history

# add upstream
git remote add upstream10 git@git.hostinghelden.at:typo3.git
git fetch upstream10
git merge upstream10/master

# copy v9 branch and merge master back to v9 (temporary workaround)
git branch -c v9 v9_old
git push origin v9_old
git checkout v9
git merge master
git push origin v9
