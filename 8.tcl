# Create a simulator
set ns [new Simulator]

# Create a NAM file
set namfile [open tcp.nam w]
$ns namtrace-all $namfile

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Create links
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail

# TCP agent on n0, sink on n2
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ns connect $tcp $sink

# Start traffic
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 0.5 "$ftp start"
$ns at 5.0 "$ftp stop"

# Finish procedure for NAM
proc finish {} {
    global ns namfile
    $ns flush-trace
    close $namfile
    exec nam tcp.nam &
    exit 0
}

# End simulation
$ns at 6.0 "finish"
$ns run
