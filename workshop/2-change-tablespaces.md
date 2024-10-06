# Change tablespaces

Puppet is not only very easy when creating (or ensuring) tablespaces. It is also straightforward to change an existing tablespace. We will use the same declarative hiera data to change some of the tablespace properties. We will use the tablespace we created before.

## Add some changes

A very common use case is to change the size and the max size of the tablespace. Let's increase the size from 5G to 10G  

Let's open the node-specific data file again. Go to the directory `/etc/puppetlabs/code/environments/production/hieradata/` and open the file `edit_in_workshop.yaml` again. Replace the current setting for `ora_profile::database::db_tablespaces::list` with this one:

```yaml
#
# Application specific stuff
#
ora_profile::database::db_tablespaces::list:
  APP_TS_1@DB01:
    ensure:     present
    size:       400M
```

and re-run Puppet again:

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

If you look at the output, you see this:

```
Notice: /Stage[main]/Ora_profile::Database::Db_tablespaces/Ora_tablespace[APP_TS_1@DB01]/size:  size changed 209715200 to 419430400
```

As a final check, let's re-run Puppet and see if this change is also idempotent.

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

No changes were detected, so it is indeed idempotent.

[Continue to the next step](./3-more-tablespace-properties.md)
