link=$(echo $1 | sed "s/tree\/master/trunk/")
svn checkout $link
link=$(echo $1 | sed "s/github.com/raw.githubusercontent.com/")
curl -Ls $link
