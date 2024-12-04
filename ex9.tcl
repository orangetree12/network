# Create a simulator instance
set ns [new Simulator]

# Open trace files
set nf [open distance_vector.nam w]
$ns namtrace-all $nf
set tf [open out.tr w]
$ns trace-all $tf

# Define finish procedure
proc finish {} {
    global ns nf tf
    $ns flush-trace
    close $nf
    close $tf
    exec nam distance_vector.nam & exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Create links (with different delays to simulate distance)
$ns duplex-link $n0 $n1 1Mb 20ms DropTail
$ns duplex-link $n1 $n2 1Mb 30ms DropTail
$ns duplex-link $n0 $n2 1Mb 50ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail

# Create a routing table for distance vector
# This is a simplified representation
set routingTable {
    "n0" { "n1" 20 "n2" 50 }
    "n1" { "n0" 20 "n2" 30 }
    "n2" { "n0" 50 "n1" 30 "n3" 10 }
    "n3" { "n2" 10 }
}

# Function to print routing table
proc printRoutingTable {table} {
    foreach {node routes} $table {
        puts "Routing table for $node:"
        foreach route $routes {
            puts "  -> $route"
        }
    }
}

# Print initial routing tables
printRoutingTable $routingTable

# Create UDP agents
set udp0 [new Agent/UDP]
set sink0 [new Agent/Null]  ; # Use Null agent instead of UDPSink
$ns attach-agent $n0 $udp0
$ns attach-agent $n3 $sink0
$ns connect $udp0 $sink0

# Set up a traffic generator (CBR)
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0
$ns at 0.0 "$cbr start"
$ns at 5.0 "$cbr stop"
$ns at 6 "finish"

# Run the simulation
$ns run
