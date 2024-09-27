# Manage database parameters

You can also manage your database parameters with Puppet. When managing these with `SQL` you can use  `BOTH` to manage both the `MEMORY` and the `SPFILE` setting. With Puppet these are two distinctive values. Values that you have to manage separately.

Let's change the maximum number of open cursors for this database from `300` to `600`.

For managing database users, we can use the hiera key `ora_profile::database::db_init_params::parameters`.

Go to the directory `/etc/puppetlabs/code/environments/production/hieradata/` and open the file `edit_in_workshop.yaml`. This file contains all the node-specific data. 

Now add this data to it:

```yaml
#
# Init.ora parameters
#
ora_profile::database::db_init_params::parameters:
  'SPFILE/OPEN_CURSORS@DB01':
    ensure:	present
    value:          600
  'MEMORY/OPEN_CURSORS@DB01':
    ensure:	present
    value:          600
```

## First Puppet run

Puppet runs will read this data and make sure the parameters are available and have the correct value. Puppet will detect that the parameters have a different value since we will apply Puppet for the first time with this data. 

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

Let's inspect the Puppet output. Somewhere near the top you'll see:

```
Notice: Ensure DB init parameter(s) SPFILE/OPEN_CURSORS:*@DB01,MEMORY/OPEN_CURSORS:*@DB01
```

This is the information Puppet provides you about the parameters it manages. When you look at the Puppet output, somewhere near the end, you will see this:

```
Notice: /Stage[main]/Ora_profile::Database::Db_init_params/Ora_init_param[SPFILE/OPEN_CURSORS:*@DB01]/value: value changed 300 to 600
Notice: /Stage[main]/Ora_profile::Database::Db_init_params/Ora_init_param[MEMORY/OPEN_CURSORS:*@DB01]/ensure: created
```

So Puppet ensured that both parameters are present and set to the correct value.

In this case, we set both the `MEMODY` and `SPFILE` parameters. This is possible because the open_cursors is a dynamic value. For some parameters, you can only modify the `SPFILE` parameters. To make them active  a restart of the database is required.

## Second Puppet run

One of the essential features of Puppet is that it is idempotent. Idempotent means it will not apply changes a second time. So if we rerun Puppet, it should see that the database parameters are already set with the correct values and do nothing.

Let's verify that and rerun Puppet:

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

We still see the message at the top that Puppet manages the user, but we no longer have the creation message, just as we expected.

## More information

See [the documentation](https://www.enterprisemodules.com/docs/ora_config/ora_init_param.html) what kind of user properties you can manage with Puppet use.

[Continue to the next step](./7-secure-your-database.md)

