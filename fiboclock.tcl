#!/usr/bin/wish

# procedure to update colors
proc update_colors {} {

    # Update colors
    set hourcolor   red
    set mincolor    green
    set bothcolor   blue
    set nocolor     white
    set hour12color red

    # get time
    set t [clock seconds]

    set h [string trimleft [clock format $t -format "%I"] "0"]

    # Deal with 08 and 09 not being octal
    set m [string map {08 8 09 9} [clock format $t -format "%M"]]
    set m [expr $m / 5]

    # Set noon/midnight color
    if {$h == 0 || $h == 12} {
	.c12 configure -background $hour12color
	h = 12
    } else {
	.c12 configure -background $nocolor
    }

    foreach i {5 3 2 1} {

	if {$h >= $i} {
	    set h [expr $h - $i]
	    if {$m >= $i} {
		.c${i} configure -background $bothcolor
		set m [expr $m - $i]
	    } else {
		.c${i} configure -background $hourcolor
	    }
	} elseif {$m >= $i} {
	    set m [expr $m - $i]
	    .c${i} configure -background $mincolor
	} else {
	    .c${i} configure -background $nocolor
	}
	
    }

    # Set up next update
    set t [clock seconds]
    set next [expr 300 - ($t % 300)]
    after $next update_colors
}



# Set up canvas widgets
canvas .c5 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c3 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c2 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c1 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c12 -height 0 -width 0 -background white -relief solid -bd 1

# Place canvas widgets in grid
grid .c2 .c1  .c5 -sticky nsew
grid ^   .c12 ^   -sticky nsew
grid .c3 -    ^    -sticky nsew

# Configure grid weights
grid rowconfigure . 0 -weight 1
grid rowconfigure . 1 -weight 1
grid rowconfigure . 2 -weight 3
grid columnconfigure . 0 -weight 2
grid columnconfigure . 1 -weight 1
grid columnconfigure . 2 -weight 5

# Update colors
update_colors
