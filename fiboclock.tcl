#!/usr/bin/wish

set seconds_mode 0

# set up next update
proc next_update {} {
    global seconds_mode

    set t [clock seconds]
    set increment [expr $seconds_mode ? 5 : 300]
    set next [expr $increment - ($t % $increment)]
    after $next update_colors
}

# toggle seconds mode
proc toggle_seconds_mode {} {
    global seconds_mode
    
    set seconds_mode [expr ! $seconds_mode]
    after cancel update_colors
    
    next_update
}

# procedure to update colors
proc update_colors {} {

    global seconds_mode

    # Update colors
    set hourcolor   0xfff000000
    set mincolor    0x000fff000
    set seccolor    0x000000fff
    set nocolor     0x000000000

    # Divisor
    set divisor 5

    # get time
    set t [clock seconds]

    set h [string trimleft [clock format $t -format "%I"] "0"]

    # Deal with 08 and 09 not being octal
    set m [string map {08 8 09 9} [clock format $t -format "%M"]]
    set m [expr $m / $divisor]

    # Seconds
    if {$seconds_mode} {
	# Deal with 08 and 09 not being octal
	set s [string map {08 8 09 9} [clock format $t -format "%S"]]
	set s [expr $s / $divisor]
    }

    foreach l [list {5 .c5} {3 .c3} {2 .c2} {1 .c1} {1 .c12}] {

	set i [lindex $l 0]
	set w [lindex $l 1]
	
	set result 0
	if {$h >= $i} {
	    set h [expr $h - $i]
	    set result [expr $result | $hourcolor]
	}

	if {$m >= $i} {
	    set m [expr $m - $i]
	    set result [expr $result | $mincolor]
	}

	if {$seconds_mode && ($s >= $i)} {
	    set s [expr $s - $i]
	    set result [expr $result | $seccolor]
	}

	${w} configure -background [format "#%09x" $result]

    }

    next_update
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

# Key bindings
bind . q exit
bind . s toggle_seconds_mode

# Update colors
update_colors
