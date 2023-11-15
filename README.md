# resources_lib

A collection of Puppet resource helper library.

- resources_default, based on [trlinkin/noop](https://forge.puppet.com/trlinkin/noop), inspire to do more on other attributes.

## Description

1. resources_default - Puppet function to include/override current scope resources attributes values.

## Usage

### resources_default

Puppet manifest that will run in noop with loglevel set to debug on all resources under current scope. This functions not
limited to only metaparameters.

```puppet
class os_compliance::rhel::item::x_1_7_1_1 (
  Boolean   $report_only  = true,
) {
  resources_default({ 'noop' => $report_only, 'loglevel' => 'debug' })

  file { '/etc/motd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("os_compliance/rhel/${banner}"),
  }
}
```

tags..

## Limitations

Not fully tested, have open up a lot of good uses case as well as other possibilties to cause compilation failure.

## Development

Just fork and raise a PR, if you have any good library to add here.
