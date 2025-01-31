#!/usr/bin/wish

# globals
set secincrement 1
set hmdivisor    1
set minincrement [expr $hmdivisor * 60]

set seconds_mode 0;		# really sub-minute units

# set up next update
proc next_update {} {
    global minincrement
    global secincrement
    global seconds_mode

    set t [clock seconds]
    set increment [expr $seconds_mode ? $secincrement : $minincrement]
    set next [expr 1000 * ($increment - ($t % $increment))]
    after $next update_colors
}

# toggle seconds mode
proc toggle_seconds_mode {} {
    global seconds_mode
    
    set seconds_mode [expr ! $seconds_mode]
    after cancel update_colors
    
    update_colors
}

# procedure to update colors
proc update_colors {} {

    global hmdivisor
    global secincrement
    global minincrement
    global seconds_mode

    # Update colors
    set hourcolor   0xfff000000
    set mincolor    0x000fff000
    set seccolor    0x000000fff
    set nocolor     0x000000000

    # get time
    set t [clock seconds]

    set h [string trimleft [clock format $t -format "%H"] "0"]

    # Deal with 08 and 09 not being octal
    set m [string map {08 8 09 9} [clock format $t -format "%M"]]
    set m [expr $m / $hmdivisor]

    # Seconds
    if {$seconds_mode} {
	# Deal with 08 and 09 not being octal
	set s [expr [clock seconds] % $minincrement]
	set s [expr $s / $secincrement]
    }

    foreach l [list {34 .c34} {21 .c21} {13 .c13} {8 .c8} {5 .c5} {3 .c3} {2 .c2} {1 .c1} {1 .c12}] {

	set i [lindex $l 0]
	set w [lindex $l 1]
	
	set result 0
	if {$h >= $i} {
	    set h [expr $h - $i]
	    set result [expr $result ^ $hourcolor]
	}

	if {$m >= $i} {
	    set m [expr $m - $i]
	    set result [expr $result ^ $mincolor]
	}

	if {$seconds_mode && ($s >= $i)} {
	    set s [expr $s - $i]
	    set result [expr $result ^ $seccolor]
	}

	${w} configure -background [format "#%09x" $result]

    }

    next_update
}



# Set up canvas widgets
canvas .c34 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c21 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c13 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c8 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c5 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c3 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c2 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c1 -height 0 -width 0 -background white -relief solid -bd 1
canvas .c12 -height 0 -width 0 -background white -relief solid -bd 1

# Place canvas widgets in grid
grid .c13 .c8 -    -   .c34 -sticky nsew
grid ^    .c2 .c1  .c5 ^    -sticky nsew
grid ^    ^   .c12 ^   ^    -sticky nsew
grid ^    .c3 -    ^   ^    -sticky nsew
grid .c21 -   -    -   ^    -sticky nsew

# Configure grid weights
grid rowconfigure . 0 -weight 8
grid rowconfigure . 1 -weight 1
grid rowconfigure . 2 -weight 1
grid rowconfigure . 3 -weight 3
grid rowconfigure . 4 -weight 21
grid columnconfigure . 0 -weight 13
grid columnconfigure . 1 -weight 2
grid columnconfigure . 2 -weight 1
grid columnconfigure . 3 -weight 5
grid columnconfigure . 4 -weight 34

# Key bindings
bind . q exit
bind . s toggle_seconds_mode
bind . m toggle_seconds_mode

# Update colors
update_colors
