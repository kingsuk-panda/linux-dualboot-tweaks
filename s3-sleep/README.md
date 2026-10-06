# S3 (Deep) Sleep

The system is configured to use S3 (`deep`) instead of s2idle for suspend.

## Changes

### Kernel cmdline — `/etc/default/grub`
```
mem_sleep_default=deep
```

Verified state:
```bash
cat /sys/power/mem_sleep
# s2idle [deep]
```

### Related services
- `ctos-hibernate-on.service` plays the suspend sound before freezing user.slice
- `ctos-hibernate-off.service` plays the resume sound after wake

See [ctos-sounds](../ctos-sounds/) for details.
