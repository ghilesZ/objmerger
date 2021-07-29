echo "# transparency of $1 set to $2
newmtl transluent
d 0
usemtl transluent
" | cat - $1 > temp && mv temp $1
