# NagiosEximStatus
Nagios plugin for check exim4 mails in queue. Supports directly usage and Nagios/Icinga usage.

## Options

- `-w (--warning)` - Specify warning number of emails in queue (usage: `-w <integer> | --warning=<integer>`).
- `-c (--critical)` - Specify critical number of emails in queue (usage: `-c <integer> | --critical=<integer>`).

## Usage

Put [check_eximq.sh](https://github.com/zevilz/NagiosEximStatus/blob/master/check_eximq.sh) to nagios plugins directory (usually `/usr/lib*/nagios/plugins`). Than make file executable (`chmod +x check_eximq.sh`).

### Directly usage

```bash
./check_eximq.sh -w <integer> -c <integer>
```

### Nagios/Icinga usage

Add following check command object to your commands file
```bash
object CheckCommand "eximq" {
    import "plugin-check-command"
    command = [ PluginDir + "/check_eximq" ]
    arguments = {
        "-w" = "$eximq_warning$"
        "-c" = "$eximq_critical$"
    }
}
```

Notice: critical and warning number of mails must be integer and critical number of mails must be greater than warning number of mails.

## Changelog
- 17.01.2018 - 1.0.0 - released
