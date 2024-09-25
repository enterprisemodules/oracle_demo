# Ensure tablespaces

After you have installed your software and created your primary database,  most of the time, you need to have some specific tablespaces.  You can do this by adding some data to your hiera data.

Go to the directory `/etc/puppetlabs/code/environments/production/hieradata/` and open the file `edit_in_workshop.yaml`. This file contains all the node-specific data. 

Now add this data to it:

```yaml
#
# Application specific stuff
#
ora_profile::database::db_tablespaces::list:
  APP_TS_1@DB01:
    ensure:     present
    size:       5G
```

This data tells Puppet to ensure that the tablespace `APP_TS_1` needs to be available with the specified size. Make sure that you safe the changes before continuing. See [the documentation](https://www.enterprisemodules.com/docs/ora_config/ora_tablespace.html) what kind of properties you can use.

## First Puppet run

Puppet runs will read this data and make sure the tablespace is available with the specified properties. Puppet will detect that the tablespace is unknown and create it since we will apply Puppet for the first time with this data. 

``` bash
puppet apply site.pp 
```

Let's inspect the Puppet output. Somewhere near the top you'll see:

```
Notice: Ensure DB tablespace(s) APP_TS_1@DB01
```

This is the information Puppet provides you about the tablespaces it manages. When you look at the Puppet output, somewhere near the end, you will see this:

```
Notice: /Stage[main]/Ora_profile::Database::Db_tablespaces/Ora_tablespace[APP_TS_1@DB01]/ensure: created
```

So Puppet created the tablespace.

## Second Puppet run

One of the essential features of Puppet is that it is idempotent. Idempotent means it will not apply changes a second time. So if we rerun Puppet, it should see that the tablespace already exists with the specified properties and do nothing.

Let's verify that and rerun Puppet:

``` bash
puppet apply site.pp 
```

We still see the message at the top that Puppet manages the tablespace, but we no longer have the creation message, just as we expected.

[Continue to the next step](./2-change-tablespaces.md)
