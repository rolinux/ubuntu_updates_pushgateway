# ubuntu_updates_pushgateway
Ansible playbook for installing the `ubuntu-updates-to-pushgateway.sh` shell script that will run only on Ubuntu instances and send apt updates numbers to Pushgateway.

Use the following Prometheus Alert code:

```yaml
- name: Software alerts
    rules:
    - alert: Ubuntu security updates
      expr: ubuntu_updates_security{job="ubuntu_updates"} > 0
      for: 5m
      labels:
        severity: warning
      annotations:
        title: Ubuntu security updates for {{ $labels.instance }} instance
        description: There are {{ $value }} security updates for {{ $labels.instance }} instance
```
