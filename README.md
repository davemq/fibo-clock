Inspired by https://github.com/pchretien/fibo and https://github.com/skrishnan22/fibonacci-clock.

I didn't like the static size implemented in https://github.com/skrishnan22/fibonacci-clock, so I set out to make a clock responsive to window size changes. I used to use Tcl/Tk a lot for simple graphical applications, so I returned to Tcl/Tk for this implementation,
using the Fibonacci numbers as weights for a grid's rows and columns. Tk's `grid` command makes this pretty easy, and the application responds just fine to window size changes.

I also used Tk's `after` to schedule the next update to the clock. I rely on the idea that 5 minutes is 300 seconds, and `clock seconds` starts at midnight. So I arrange for the clock to update on multiples of 300 seconds. There's no point in updating more often.

I'm contemplating adding a "seconds" mode that would add a third color and color combinations for the different combinations. And updates every 5 seconds. I'd probably switch to using blue for seconds. Then the various combinations can be bitwise ORs of the RGB bits, which should give us cyan, magenta, and yellow. Then all 3 values using a Fibonacci number would give us white. This would make the "not in use" color black.
