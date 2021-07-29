echo "# colorization of $1 in red
newmtl red
Ka 0.000000 0.000000 0.000000
Kd 0.400000 0.000000 0.000000
Ks 0.330000 0.330000 0.330000
d 1.0
usemtl red
" | cat - $1 > temp && mv temp $1
