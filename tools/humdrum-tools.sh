#!/bin/bash

alias rid-all='rid -GLId | egrep -v "=|r"'
alias sort-uniq="sort | uniq -c | sort -nr"

function fill-null-tokens {
    for f in $1/*.krn
    do
        ditto $f > $1/$(basename $f .krn).ditto
    done
}

function hint-all {
    # It's useful to have the result in a file for further processing.
    hint -cul $1/*.ditto | rid-all > $1.hint
}

function sonority-quartets1 {
    # the argument must be without extension
    uniq-line $1.hint | sort-uniq > $1.son1
}

function sonority-quartets2 {
    sonority -t $1/*.ditto | rid-all | sort-uniq > $1.son2
}

function make-tmp-hint {
    for file in $1/*.ditto
    do
        hint -cul $file > $1/$(basename $file .ditto).hint
    done
}

function find-sonority {
    hgrep -H -m "$2" $1/*.hint
}

function find-and-show-sonority {
    # composer, sonority
    result=$(hgrep -H -m "$2" $1/*.hint)
    bar=$(echo $result | awk -F: '{print $2}' | awk '{print $2}')
    file=$(basename $(echo $result | awk -F: '{print $1}') .hint).krn
    echo $file $bar
    yank -n ^= -r $(($bar-1))-$(($bar+1)) $1/$file > foo.krn
    hum2ps foo.krn
}

function hum2ps {
    file=$(basename $1 .krn)
    hum2abc $1 > $file.abc
    abcm2ps -O $file.ps $file.abc
}

function perc {
    # n total
    #  $((100.0*$1/$2))
    echo "scale=2;100*$1/$2" | bc -l
}

function cons-dis {
    dis=$(grep "[Ad]" $1 | awk '{sum+=$1}END{print sum}')
    cons=$(grep -v "[Ad]" $1 | awk '{sum+=$1}END{print sum}')
    total=$(($dis+$cons))
    echo dis: $(perc $dis $total)% cons: $(perc $cons $total)%
}

function show-diss {
    grep "[Ad]" $1
}

function perc2-table {
    echo haydn > a
    echo mozart > b
    echo beethoven > c
    echo "" > d
    sort haydn.perc2 -k 2 | awk '{print $2}' >> d
    sort haydn.perc2 -k 2 | awk '{print $1}' >> a
    sort mozart.perc2 -k 2 | awk '{print $1}' >> b
    sort beethoven.perc2 -k 2 | awk '{print $1}' >> c
    paste -d "&" d a b c
    
}

#######################################################################

function prepare-data {
    for x in haydn mozart beethoven
    do
        echo processing $x
        fill-null-tokens $x
        make-tmp-hint $x
        hint-all $x
        sonority-quartets1 $x
        sonority-quartets2 $x
        percentage $x.son1 > $x.perc1
        percentage $x.son2 > $x.perc2
    done
}

# find-sonority haydn "A2 A4 m7"
# find-and-show-sonority haydn "A2 A4 m7"
