function iplot
    echo "
    set terminal pngcairo enhanced font 'JetBrains Mono,13'
    set autoscale
    set samples 1000
    set output '|kitty +kitten icat --stdin yes'
    set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb\"#fdf6e3\" behind
    plot $argv
    set output '/dev/null'
    " | gnuplot
end
