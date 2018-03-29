




##############################
Results
##############################

2:
44266.64
38154.70

(with higher rlimit/connections)
46161.80
40217.23

4: (keepalive 16)
44940.19
32700.07
30715.77
44409.68

8: (keepalive 256) - with keepalive 16 performance was poor (10k each)
31159.94
32634.92
31776.65
31172.27
30801.34
30356.67
30752.31
31269.26

16:
24731.97
21542.09
21715.02
20861.49
 8439.01
19372.05
 9560.51
19820.11
24417.07
21302.78
20350.40
11297.42
15158.94
16351.10
16401.24
21007.84

32:
17410.83
 5084.05
 9235.97
 8427.56
 6483.28
10568.13
11548.70
13031.59
10787.52
 5157.99
12997.73
16813.03
10517.61
 7585.00
 7153.78
12993.82
 8336.55
 7653.66
 7166.23
13076.85
 6434.06
13218.00
17263.39
12650.67
14760.08
13276.88
10874.30
 5271.08


`


When directly tesitng the webserver:

16:
(incorrect mask)
33304.53
12721.35
 6907.63
17059.22
15050.81
13439.84
13931.11
20791.39
30191.26
28509.08
20399.75
22935.89
 6022.47
23774.71
30455.79
21309.55

(auto mask - 1 worker)
26126.31
24741.95
35235.91
23432.97
25597.26
23185.28
28529.62
24358.61
26654.33
24557.80
25335.69
24117.72
26835.50
27861.38
22959.30
24169.42

28:
(incorrect mask)
21361.74
 4804.97
 8659.74
 8254.87
 8927.42
 6263.08
14475.17
 3341.39
 5840.86
 9958.17
 9034.73
22942.13
 9829.61
 5879.17
14528.89
12221.91
 8696.35
15807.45
10093.98
14810.68
13075.08
22518.92
21528.41
 6527.87
17139.28
16186.83
15974.87
11091.48

(auto mask 1 worker)

20442.37
18761.86
18861.34
19690.10
16883.36
22474.14
19260.92
20295.50
19793.41
18750.64
19140.86
21798.80
19620.55
19858.56
19511.13
20763.13
18491.88
19670.28
19367.02
19392.21
20142.64
19914.16
19070.85




---------
LB after mask fix in webserver

20389.80
19646.86
18410.29
19636.02
19130.32
18943.66
19288.32
20099.75
20606.41
19058.54
18157.64
18488.07
18820.52
18927.62
17970.69
18509.51


15315.85
13783.31
13180.72
13504.57
13464.74
12817.54
13678.42
13546.75
13036.04
13821.48
13206.53
15368.01
12647.24
13373.40
13059.17
14970.23
14242.22
13559.15
15860.68
14309.31
14666.51
16709.18
13940.47
14298.15
15630.46
13615.45
13915.75
13245.08




======================









# Max receive buffer size (8 Mb)
net.core.rmem_max=8388608
# Max send buffer size (8 Mb)
net.core.wmem_max=8388608

# Default receive buffer size
net.core.rmem_default=65536
# Default send buffer size
net.core.wmem_default=65536

# The first value tells the kernel the minimum receive/send buffer for each TCP connection,
# and this buffer is always allocated to a TCP socket,
# even under high pressure on the system. …
# The second value specified tells the kernel the default receive/send buffer
# allocated for each TCP socket. This value overrides the /proc/sys/net/core/rmem_default
# value used by other protocols. … The third and last value specified
# in this variable specifies the maximum receive/send buffer that can be allocated for a TCP socket.
# Note: The kernel will auto tune these values between the min-max range
# If for some reason you wanted to change this behavior, disable net.ipv4.tcp_moderate_rcvbuf
net.ipv4.tcp_rmem=8192 873800 8388608
net.ipv4.tcp_wmem=4096 655360 8388608

# Units are in page size (default page size is 4 kb)
# These are global variables affecting total pages for TCP
# sockets
# 8388608 * 4 = 32 GB
#  low pressure high
#  When mem allocated by TCP exceeds “pressure”, kernel will put pressure on TCP memory
#  We set all these values high to basically prevent any mem pressure from ever occurring
#  on our TCP sockets
net.ipv4.tcp_mem=8388608 8388608 8388608

# Increase max number of sockets allowed in TIME_WAIT
net.ipv4.tcp_max_tw_buckets=6000000

# Increase max half-open connections.
net.ipv4.tcp_max_syn_backlog=65536

# Increase max TCP orphans
# These are sockets which have been closed and no longer have a file handle attached to them
net.ipv4.tcp_max_orphans=262144

# Max listen queue backlog
# make sure to increase nginx backlog as well if changed
net.core.somaxconn = 16384

# Max number of packets that can be queued on interface input
# If kernel is receiving packets faster than can be processed
# this queue increases
net.core.netdev_max_backlog = 16384

# Only retry creating TCP connections twice
# Minimize the time it takes for a connection attempt to fail
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

# Timeout closing of TCP connections after 7 seconds
net.ipv4.tcp_fin_timeout = 7

# Avoid falling back to slow start after a connection goes idle
# keeps our cwnd large with the keep alive connections
net.ipv4.tcp_slow_start_after_idle = 0





   sudo sysctl -w net.ipv4.tcp_tw_reuse=1
  sudo sysctl -w net.ipv4.ip_local_port_range="15000 64000"
  sudo sysctl -w fs.nr_open=10000000
  
  116  sudo sysctl -w net.ipv4.tcp_mem="786432 1697152 1945728"
  117  sudo sysctl -w net.ipv4.tcp_rmem="4096 4096 16777216"
  120  sudo sysctl -w net.ipv4.tcp_wmem="4096 4096 16777216"


>>> imactful
sudo sysctl  -w net.core.somaxconn="16384"


sudo sysctl -w net.core.rmem_max="8388608"
sudo sysctl -w net.core.wmem_max="8388608"
sudo sysctl -w net.core.rmem_default="65536"
sudo sysctl -w net.core.wmem_default="65536"
sudo sysctl -w net.ipv4.tcp_rmem="8192 873800 8388608"
sudo sysctl -w net.ipv4.tcp_wmem="4096 655360 8388608"
sudo sysctl -w net.ipv4.tcp_mem="8388608 8388608 8388608"
sudo sysctl -w net.ipv4.tcp_max_tw_buckets="6000000"
sudo sysctl -w net.ipv4.tcp_max_syn_backlog="65536"
sudo sysctl -w net.ipv4.tcp_max_orphans="262144"
sudo sysctl -w net.core.somaxconn="16384"
sudo sysctl -w net.core.netdev_max_backlog="16384"
sudo sysctl -w net.ipv4.tcp_synack_retries="2"
sudo sysctl -w net.ipv4.tcp_syn_retries="2"
sudo sysctl -w net.ipv4.tcp_fin_timeout="7"
sudo sysctl -w net.ipv4.tcp_slow_start_after_idle="0"


capture from appserv96:

    sudo sysctl -w net.ipv4.tcp_tw_reuse=1
    sudo sysctl -w net.ipv4.ip_local_port_range="15000 64000"

    sudo sysctl -w fs.nr_open=10000000
    
    sudo sysctl -w net.ipv4.tcp_mem="786432 1697152 1945728"
    sudo sysctl -w net.ipv4.tcp_rmem="4096 4096 16777216"
    sudo sysctl -w net.ipv4.tcp_wmem="4096 4096 16777216"

    sudo sysctl  -w net.core.somaxconn="32768"
    sudo sysctl -w net.core.rmem_max="8388608"
    sudo sysctl -w net.core.wmem_max="8388608"
    sudo sysctl -w net.core.rmem_default="65536"
    sudo sysctl -w net.core.wmem_default="65536"
    sudo sysctl -w net.ipv4.tcp_rmem="8192 873800 8388608"
    sudo sysctl -w net.ipv4.tcp_wmem="4096 655360 8388608"
    sudo sysctl -w net.ipv4.tcp_mem="8388608 8388608 8388608"
    sudo sysctl -w net.ipv4.tcp_max_tw_buckets="6000000"
    sudo sysctl -w net.ipv4.tcp_max_syn_backlog="65536"
    sudo sysctl -w net.ipv4.tcp_max_orphans="262144"
    sudo sysctl -w net.core.somaxconn="16384"
    sudo sysctl -w net.core.netdev_max_backlog="16384"
    sudo sysctl -w net.ipv4.tcp_synack_retries="2"
    sudo sysctl -w net.ipv4.tcp_syn_retries="2"
    sudo sysctl -w net.ipv4.tcp_fin_timeout="7"
    sudo sysctl -w net.ipv4.tcp_slow_start_after_idle="0"



following worked better, increasing to 64k was not impactful
    sudo sysctl -w net.core.somaxconn="32768"


####### modifed setting. These setting did increse perf once but on compete fresh run only imact I am seeing is with somax-conn.

    sudo sysctl -w net.ipv4.tcp_tw_reuse=1
    sudo sysctl -w net.ipv4.ip_local_port_range="15000 64000"
    sudo sysctl -w fs.nr_open=10000000
    sudo sysctl  -w net.core.somaxconn="32768"
    sudo sysctl -w net.core.rmem_max="8388608"
    sudo sysctl -w net.core.wmem_max="8388608"
    sudo sysctl -w net.core.rmem_default="65536"
    sudo sysctl -w net.core.wmem_default="65536"
    sudo sysctl -w net.ipv4.tcp_rmem="8192 873800 8388608"
    sudo sysctl -w net.ipv4.tcp_wmem="4096 655360 8388608"
    sudo sysctl -w net.ipv4.tcp_mem="8388608 8388608 8388608"
    sudo sysctl -w net.ipv4.tcp_max_tw_buckets="6000000"
    sudo sysctl -w net.ipv4.tcp_max_syn_backlog="65536"
    sudo sysctl -w net.ipv4.tcp_max_orphans="262144"

    sudo sysctl -w net.core.netdev_max_backlog="16384"
    sudo sysctl -w net.ipv4.tcp_synack_retries="2"
    sudo sysctl -w net.ipv4.tcp_syn_retries="2"
    sudo sysctl -w net.ipv4.tcp_fin_timeout="7"
    sudo sysctl -w net.ipv4.tcp_slow_start_after_idle="0"


    sudo sysctl -w net.ipv4.tcp_mem="786432 1697152 1945728"
    sudo sysctl -w net.ipv4.tcp_rmem="4096 4096 16777216"
    sudo sysctl -w net.ipv4.tcp_wmem="4096 4096 16777216"


#####Defautl setting of dismanti systems:

sudo sysctl -w net.core.somaxconn="128"


sudo sysctl -w net.ipv4.tcp_tw_reuse="0"
sudo sysctl -w net.ipv4.ip_local_port_range="32768  60999"

sudo sysctl -w fs.nr_open="1048576"

sudo sysctl -w net.core.rmem_max="212992"
sudo sysctl -w net.core.rmem_default="212992"
sudo sysctl -w net.core.wmem_default="212992"
sudo sysctl -w net.core.wmem_max="212992"

sudo sysctl -w net.ipv4.tcp_rmem="4096        87380   6291456"
sudo sysctl -w net.ipv4.tcp_wmem="4096        16384   4194304"
sudo sysctl -w net.ipv4.tcp_mem="12373659     16498213        24747318"
sudo sysctl -w net.ipv4.tcp_max_syn_backlog="2048"
sudo sysctl -w net.ipv4.tcp_max_tw_buckets="262144"
sudo sysctl -w net.ipv4.tcp_max_orphans="262144"

sudo sysctl -w net.core.netdev_max_backlog="1000"
sudo sysctl -w net.ipv4.tcp_synack_retries="5"
sudo sysctl -w net.ipv4.tcp_syn_retries="6"
sudo sysctl -w net.ipv4.tcp_fin_timeout="60"
sudo sysctl -w net.ipv4.tcp_slow_start_after_idle="1"