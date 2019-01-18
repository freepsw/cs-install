
## dpcore_globalworkflow
DROP DATABASE IF EXISTS dpcore_globalworkflow;
create database dpcore_globalworkflow;

DROP USER IF EXISTS dpcore_globalworkflow;
create user dpcore_globalworkflow;
grant all privileges on dpcore_globalworkflow.* to dpcore_globalworkflow@localhost identified by 'globalworkflow' with grant option;
grant all privileges on dpcore_globalworkflow.* to dpcore_globalworkflow@'%' identified by 'globalworkflow' with grant option;

## dpcore_streaming
create database dpcore_streaming;
create user streaming;
grant all privileges on dpcore_streaming.* to dpcore_streaming@localhost identified by 'streaming' with grant option;
grant all privileges on dpcore_streaming.* to dpcore_streaming@'%' identified by 'streaming' with grant option;


## dpcore_collector
create database dpcore_collector;
create user collector;
grant all privileges on dpcore_collector.* to collector@localhost identified by '!collector00' with grant option;
grant all privileges on dpcore_collector.* to collector@'%' identified by '!collector00' with grant option;

## pipeline
create database pipeline;
create user pipeline;
grant all privileges on pipeline.* to pipeline@localhost identified by 'pipeline' with grant option;
grant all privileges on pipeline.* to pipeline@'%' identified by 'pipeline' with grant option;

flush privileges;



## dpcore_common
-- create database dpcore_common;
-- create user dpcore_common;
-- grant all privileges on dpcore_common.* to dpcore_common@localhost identified by 'common' with grant option;
-- grant all privileges on dpcore_common.* to dpcore_common@'%' identified by 'common' with grant option;
