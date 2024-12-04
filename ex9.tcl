# Create a simulator
set ns [new Simulator]

# Create a NAM file for visualization
set namfile [open dvr_simulation.nam w]
$ns namtrace-all $namfile

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Create links with bandwidth and delay
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail

# Create routing agents for each node
set r0 [new Agent/DSR]
set r1 [new Agent/DSR]
set r2 [new Agent/DSR]
set r3 [new Agent/DSR]

$ns attach-agent $n0 $r0
$ns attach-agent $n1 $r1
$ns attach-agent $n2 $r2
$ns attach-agent $n3 $r3

# Set the routing protocol (distance vector routing)
$r0 set protocol DSR
$r1 set protocol DSR
$r2 set protocol DSR
$r3 set protocol DSR

# Create CBR traffic from n0 to n3
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $r0
$cbr set packetSize_ 512
$cbr set interval_ 0.1
$ns at 1.0 "$cbr start"
$ns at 4.0 "$cbr stop"

# Finish procedure
proc finish {} {
    global ns namfile
    $ns flush-trace
    close $namfile
    exec nam dvr_simulation.nam &
    exit 0
}

# End the simulation after 5 seconds
$ns at 5.0 "finish"

# Run the simulation
$ns run
