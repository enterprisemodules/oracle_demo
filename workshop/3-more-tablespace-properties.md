# More tablespace properties

The previous example was very elementary. In reality, you probably need more options when defining a tablespace. No worries. Puppet supports **all** of the options `sqlplus create tablespace` command also supports. Let's investigate some.

## Autoextend

Let's ensure that a second tablespace `APP_TS_2` is available and that it will auto-extend. The initial size we need is `5G,` any increments created are `2G` and the maximum size we allow is `10G`. Here is the definition of this tablespace. Let's add this to the node hieradata and re-run Puppet

```yaml
#
# Application specific stuff
#
ora_profile::database::db_tablespaces::list:
  APP_TS_1@DB01:
    ensure:     present
    size:       10G
  APP_TS_2@DB01:
    ensure:   present
    autoextend: 'on'
    max_size:  10G
    next:    2G
    size:    5G
```

And run Puppet:

```
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

We see:

```
Notice: /Stage[main]/Ora_profile::Database::Db_tablespaces/Ora_tablespace[APP_TS_2@DB01]/ensure: created
```

## A temporary tablespace

Let's add the `TMP_TS_1` temporary tablespace. Here is the hiera data you have to **add** to the of the list of tablespaces. 

```yaml
ora_profile::database::db_tablespaces::list:
...
  TMP_TS_1:
    contents: 'temporary'
    size:    5G
```

When we run Puppet, we see:

```
Notice: /Stage[main]/Ora_profile::Database::Db_tablespaces/Ora_tablespace[TMP_TS_1]/ensure: created
```

## An undo tablespace

Let's add the `UNDO_TS_1` undo tablespace. Here is the hiera data you have to **add** to the of the list of tablespaces. 

```yaml
ora_profile::database::db_tablespaces::list:
...
  UNDO_TS_1:
    contents: 'undo'
    size:    5G
```

When we run Puppet, we see:

```
Notice: /Stage[main]/Ora_profile::Database::Db_tablespaces/Ora_tablespace[UNDO_TS_1]/ensure: created
```

## More information

See [the documentation](https://www.enterprisemodules.com/docs/ora_config/ora_tablespace.html) what kind of table space properties you can manage with Puppet use.

[Continue to the next step](./4-manage-profiles.md)
