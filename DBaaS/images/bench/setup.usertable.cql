drop keyspace usertable;
create keyspace usertable with placement_strategy = 'SimpleStrategy' and strategy_options = {replication_factor:1};
use usertable;
create column family data;
