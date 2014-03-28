Size out whisper databases
==========================

Use this perl script to quickly determine what size your whisper databases will be.


### Command
```./size_out_whisper_databases.pl 10s:5m,30s:15m,1m:1h,5m:4h 1m:1d,5m:7d,15m:1y --checks 25 --machines 100```

### Output
```
10s:5m 947.27 KB
30s:15m 947.27 KB
1m:1h 1.78 MB
1m:1d 41.27 MB
5m:7d 57.74 MB
5m:4h 1.44 MB
15m:1y 1002.57 MB

Size per check: 44.27 MB
Size per machine: 11.07 MB
Total size: 1.08 GB
```

### Help
```
Usage:
    size_out_whisper_database.pl [options] retention_policy

      Options:
        --help              Brief help message
        --checks            Number of checks on a machine
        --machines          Number of machines the policy applies to
        --whisper_bin       Specify whisper-checks binary path

Options:
    --help  Prints a brief help message and exits

    --checks
            The number of checks you're running on a single machine

    --machines
            The number of machines the specified retention policy applies to

    --whisper_bin
            Specify the location of your whisper-checks binary

```
