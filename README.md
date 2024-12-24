# How to Reproduce Database-Project

## Docker Download and Init

[https://docs.docker.com/desktop/setup/install/windows-install/]()

## Database in Docker Deploy
```cmd
docker pull docker.1panel.live/enmotech/opengauss:3.0.0
docker pull docker.1panel.live/ubuntu/postgres:14-22.04_beta
```

## Run the OpenGauss

```cmd
 docker run --name project3-opengauss --privileged=true \
    -d -e GS_PASSWORD=<!!!your db password!!!> \
    -v <!!!persist directory!!!>:/var/lib/opengauss  -u root \
    -p 15432:5432 \
    docker.1panel.live/enmotech/opengauss:3.0.0
```

## Run the Postgresql

```cmd
docker run -d \
	--name project3-postgres \
	-e POSTGRES_USER=postgres-e POSTGRES_PASSWORD=<!!!your db password!!!> \
	-e POSTGRES_DB=postgres-e PGDATA=/var/lib/postgresql/data/pgdata \
	-p 5432:5432 \
	-v <!!!persist directory!!!>:/var/lib/postgresql/data \
	docker.1panel.live/ubuntu/postgres:14-22.04_beta
```

## Install Pgbench

​	Pgbench was already installed when pulling the image.

------

> [!IMPORTANT]
>
> Ensure that the database in Docker is running in the following tests

## Initialize Database

```cmd
psql -h localhost -p 15432 -U gaussdb -d postgres -f pgbench_init.sql
psql -h localhost -p 5432 -U postgres -d postgres -f pgbench_init.sql
```

## Testing Query Response Time

```cmd
pgbench -h localhost -U gaussdb -d postgres -p 15432 -f query_pgbench_init.sql -T 60
pgbench -h localhost -U postgres -d postgres -p 5432 -f query_pgbench_init.sql -T 60
```

​	Pgbench will return *Number of Transactions Processed, Number of Failed Transactions, Latency Average (ms), Initial Connection Time (ms),  TPS (without initial connection time)*.

## Testing Throughput

```cmd
pgbench -h localhost -p 5432 -U postgres -d postgres -f tps_qps_pgbench_init.sql -T 60 -c 100 -j 32
pgbench -h localhost -p 15432 -U gaussdb -d postgres -f tps_qps_pgbench_init.sql -T 60 -c 100 -j 32
```

​	Pgbench will return *Number of Transactions Processed, Number of Failed Transactions, Latency Average (ms), Initial Connection Time (ms),  TPS (without initial connection time)*.

## Testing  Horizontal Scaling

> [!IMPORTANT]
>
> Do the same in ```openGauss``` and ```PostgreSQL```

### Install Pgpool2

```bash
apt-get install apt-utils
apt-get update
apt-get install pgpool2
```

### Modify ```postgresql.conf```

```sql
wal_level = replica
max_wal_senders = 10
hot_standby = on
primary_conninfo
```

### Modify ```pgpool.conf```

```
backend_hostname0 = 'localhost'
backend_port0 = 5432
backend_weight0 = 1

backend_hostnamex = 'localhost' # "x" can be any number
backend_portx = 5432
backend_weightx = 1

load_balance_mode = on
master_slave_mode = on
```

### Copying Verification

```sql
SELECT * FROM pg_stat_replication;
```

### Test Metrics in Different Node Numbers

```
pgbench -h localhost -p 15432 -U gaussdb -d postgres -f horizontal_pgbench_init.sql -T 60 -c 100 -j 32
pgbench -h localhost -p 5432 -U postgres -d postgres -f horizontal_pgbench_init.sql -T 60 -c 100 -j 32
```

​	Pgbench will return *Number of Transactions Processed, Number of Failed Transactions, Latency Average (ms), Initial Connection Time (ms),  TPS (without initial connection time)*.

## Testing  Vertical Scaling

### Build Docker in Different Hardware Resources

```cmd
docker run --name project3-opengauss2C1G --cpuset-cpus="0,1" --cpus="2.0" --memory="1g" --privileged=true -d -e GS_PASSWORD=Baiyu!0123 -v D:/project1/var/lib/opengauss  -u root -p 15432:5432 docker.1panel.live/enmotech/opengauss:3.0.0 
docker run --name project3-opengauss4C2G --cpuset-cpus="0,1,2,3" --cpus="4.0" --memory="2g" --privileged=true -d -e GS_PASSWORD=Baiyu!0123 -v D:/project2/var/lib/opengauss  -u root -p 15432:5432 docker.1panel.live/enmotech/opengauss:3.0.0 
docker run --name project3-opengauss8C4G --cpuset-cpus="0,1,2,3,4,5,6,7" --cpus="8.0" --memory="4g" --privileged=true -d -e GS_PASSWORD=Baiyu!0123 -v D:/project3/var/lib/opengauss  -u root -p 15432:5432 docker.1panel.live/enmotech/opengauss:3.0.0 
docker run -d --name project3-postgres2C1G  --cpuset-cpus="0,1" --cpus="2.0" --memory="1g" -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=114514 -e POSTGRES_DB=postgres -e PGDATA=/var/lib/postgresql/data/pgdata -p 5432:5432 -v D:/var/lib/postgresql/data docker.1panel.live/ubuntu/postgres:14-22.04_beta
docker run -d --name project3-postgres4C2G  --cpuset-cpus="0,1,2,3" --cpus="4.0" --memory="1g" -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=114514 -e POSTGRES_DB=postgres -e PGDATA=/var/lib/postgresql/data/pgdata -p 5432:5432 -v D:/var/lib/postgresql/data docker.1panel.live/ubuntu/postgres:14-22.04_beta
docker run -d --name project3-postgres8C4G  --cpuset-cpus="0,1,2,3,4,5,6,7" --cpus="8.0" --memory="1g" -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=114514 -e POSTGRES_DB=postgres -e PGDATA=/var/lib/postgresql/data/pgdata -p 5432:5432 -v D:/var/lib/postgresql/data docker.1panel.live/ubuntu/postgres:14-22.04_beta
```

### Test Metrics in Different Hardware Resources

> [!NOTE]
>
> You need to ensure that the corresponding Docker is running

```cmd
pgbench -h localhost -p 5432 -U postgres -d postgres -f vertical_pgbench_init.sql -T 60 -c 20 -j 8
pgbench -h localhost -p 15432 -U gaussdb -d postgres -f vertical_pgbench_init.sql -T 60 -c 20 -j 8
```

​	Pgbench will return *Number of Transactions Processed, Number of Failed Transactions, Latency Average (ms), Initial Connection Time (ms),  TPS (without initial connection time)*.

