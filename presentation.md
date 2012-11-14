10 Percona Toolkit tools every MySQL DBA should know about
===

Fernando Ipar - Percona Webinars 2012

!

About me
===

- Fernando Ipar
- Consultant @ Percona
- fernando.ipar@percona.com

!

About this presentation
===

- Introductory level
- http://github.com/fipar/10&#95;pt&#95;tools
- http://github.com/fipar/percona&#95;toolkit&#95;recipes

!

About Percona Toolkit
===

- Actual customer problems
- Extensive test coverage
- Works with every version since 5.0
  - Some tools with 4.1 too
- Good community
- Covered by our Support services

!

Before we begin
===

Knowing your DSNs

!

(This includes all of today's tools except pt-stalk and pt-sift)

!

Data Source Names in a nutshell
===

- comma separated K/V list
- h=localhost,u=root,p=s3cr3t
- For multiple hosts, specific DSN inherit from others
  - So your life will be easier if you keep your credentials
    consistent across hosts
- Full story: http://bit.ly/percona-toolkit-dsn-spec

!

Before running a tool
===

- Read the manual carefully
- <span class=warning>Test</span>
- Have a <span class=warning>tested backup</span> available

!


Replication management tools
===

!

pt-table-checksum
===

Determines if a master and its replicas have a consistent copy of
  the dataset
  
!

Why would a replica *not* be consistent?
===

- Writing directly to it
- Using SBR
- Bad coordinates after server crash
- &lt;your reason here&gt;

!

How does it work?
===

- Uses STATEMENT based replication
  - Does not change other sessions
- Runs checksum queries against master
  - Waits for them to replicate to slaves
  - Checks for differences in the results

!

The scenario
===

Master A, replicas B and C

!

<span class="example">pt-table-checksum --replicate percona.checksums h=A</span>

!

Yes, it's *that* simple! 

Some considerations: 

- Schema differences may <span class=warning>break replication</span>
- Will self-throttle checking replica lag
  - But don't leave unattended

!

pt-table-sync
===

If pt-table-checksum gives you the bad news, pt-table-sync helps you
go back to a sane state. 

!

The scenario
===

Master A, replicas B and C. 

pt-table-checksum found differences on C. 

!

<span class="example">pt-table-sync --replicate percona.checksums --print h=A</span>

happy with what you see? then add --execute

!


![](./img/pt-table-sync-flowchart.png "")

!

pt-slave-delay
===

- Intentionally keep a slave behind

!

![](./img/exploits_of_a_mom.png "") 

(http://xkcd.com/327/ is one reason why a slave is **not** a backup)

!

<span class="example">pt-slave-delay --delay 2h h=slave</span>

!

pt-slave-restart
===

- Automatically skip replication errors
- Only as a last resort!

!

<span class="example">pt-slave-restart h=slave</span>

!

![](./img/pt-slave-restart-flowchart.png "")

!

When using SBR, skipping errors can make a <span class=warning>bad
situation worse</span>.

!
pt-heartbeat
===

- Reliably measure replication lag
- Works with Percona Monitoring Plugins
  - http://www.percona.com/software/percona-monitoring-plugins

!

On master
===

<span class="example">pt-heartbeat -D percona --create-table --update h=master</span>


!

From nagios/etc
===

<span class="example">pt-heartbeat -D percona --check h=replica</span>

!

Performance optimization tools
===

!

pt-query-digest
===

- Analyze MySQL queries
- Discover optimization opportunities
- Prevent scalability bottlenecks

!

<span class="example">pt-query-digest &lt;path-to-log&gt;</span>

!

![](./img/pt-query-digest-example.png "")

!

![](./img/pt-query-digest-detail-example.png "")

!

Filtering
===

<span class="example">pt-query-digest --filter <filter.pl> &lt;path-to-log&gt;</span>
	
filter.pl: 
     
<span class="example">return ($event->{fingerprint} =~ m/users/)</span>

!

Reviews
===

<span class="example">pt-query-digest --create-review-table --review D=percona,t=reviews &lt;path-to-log&gt;</span>

https://github.com/box/Anemometer makes good use of this feature

!

![](./img/pt-query-digest-review-example.png "")

!
Operations tools
===

!

pt-upgrade
===

- Compare query results & run time against different instances
- Part of proper version upgrade testing

!

<span class="example">pt-upgrade h=127.0.0.1,P=5527,D=sakila,u=msandbox,p=msandbox h=127.0.0.1,P=18967,D=sakila,u=msandbox,p=msandbox queries.txt</span>

!

![](./img/pt-upgrade.png "")


!
pt-online-schema-change
===

- Minimize impact of ALTERing tables
- Be careful with foreign keys

!

<span class="example">pt-online-schema-change --alter-foreign-keys-method auto --alter "add key actor&#95;last&#95;update (last&#95;update)" --execute S=/tmp/mysql_sandbox5527.sock,D=sakila,t=actor</span>

!

![](./img/pt-online-schema-change.png "")

!

Root cause analysis tools
===

!

pt-stalk
===

- Helps diagnose hard-to-catch problems
- 'Random' stalls

!

<span class=example>pt-stalk --function processlist --variable State
--match statistics --threshold 10</span>

!

<span class=example>pt-stalk --function processlist --variable Command
--match Sleep --threshold 155 --cycles 0</span>

!

<span class=example>pt-stalk --threshold 40 --cycles 6</span>

!

<span class=example>pt-stalk --function custom-check.sh --threshold 12</span>

custom-check just has to provide a 'trg&#95;plugin' function, which must
output a number
</span>

!


<span class=example>pt-stalk --no-stalk</span>

!

pt-sift
===

- High level overview of pt-stalk data

!


![](./img/pt-sift.png "")

!

The take home message
===
- Don't reinvent the wheel
- We've been burned, so you don't have to

!

Q/A
===
