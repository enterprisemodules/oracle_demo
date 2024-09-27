# Manage database users

Now let's add some database users (schema owners). Again you only need to add some yaml settings to your hiera data.

For managing database users, we can use the hiera key `ora_profile::database::db_users::list`.

Let's start off with a database use where the application tables will be created. We call it `APP_SCHEMA_1`

Go to the directory `/etc/puppetlabs/code/environments/production/hieradata/` and open the file `edit_in_workshop.yaml`. This file contains all the node-specific data. 

Now add this data to it:

```yaml
#
# Database users
#
ora_profile::database::db_users::list:
  APP_SCHEMA_1@DB01:
    ensure: present
    profile: DEFAULT
    default_tablespace: APP_TS_1
    grants:
    - CREATE SESSION
    - RESOURCE
```

## First Puppet run

Puppet runs will read this data and make sure the database user is available with the specified properties. Puppet will detect that the user is unknown and create it since we will apply Puppet for the first time with this data. 

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

Let's inspect the Puppet output. Somewhere near the top you'll see:

```
Notice: Ensure DB user(s) APP_SCHEMA_1@DB01
```

This is the information Puppet provides you about the users it manages. When you look at the Puppet output, somewhere near the end, you will see this:

```
Notice: /Stage[main]/Ora_profile::Database::Db_users/Ora_user[APP_SCHEMA_1@DB01]/ensure: created
```

So Puppet created the database user.

## Second Puppet run

One of the essential features of Puppet is that it is idempotent. Idempotent means it will not apply changes a second time. So if we rerun Puppet, it should see that the database user already exists with the specified properties and do nothing.

Let's verify that and rerun Puppet:

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

We still see the message at the top that Puppet manages the user, but we no longer have the creation message, just as we expected.

## Interactive users

Puppet also checks and changes the password of the specified database user. For static accounts containing application tables, that is most of the time what you want. But for interactive database users, this is mostly unwanted. If a database user changes his password, we don't want Puppet to change it back. Fortunately, Puppet has you covered here as well.

We are going to make the interactive user: `APP_USER_1`. The `APP_USER_1` database user is an interactive user. We set the initial password and expiry property. But the parameter `create_only` tells Puppet to leave the properties as they are on future runs. Add this data to the db_users key:

```yaml
  APP_USER_1@DB01:
    ensure: present
    password: verysecret
    profile: DEFAULT
    temporary_tablespace: TMP_TS_1
    default_tablespace: APP_TS_1
    expired: 'false'
    locked: false
    create_only:
    - expired
    - password
    grants:
    - CREATE SESSION
    - RESOURCE
```

## First Puppet run

Puppet runs will read this data and make sure the database user is available with the specified properties. Puppet will detect that the user is unknown and create it since we will apply Puppet for the first time with this data. 

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

Let's inspect the Puppet output. Somewhere near the top you'll see:

```
Notice: Ensure DB user(s) APP_SCHEMA_1@DB01,APP_USER_1@DB01
```

This is the information Puppet provides you about the users it manages. When you look at the Puppet output, somewhere near the end, you will see this:

```
Notice: /Stage[main]/Ora_profile::Database::Db_users/Ora_user[APP_USER_1@DB01]/ensure: created
```

So Puppet created the database user.

## Second Puppet run

One of the essential features of Puppet is that it is idempotent. Idempotent means it will not apply changes a second time. So if we rerun Puppet, it should see that the database user already exists with the specified properties and do nothing.

Let's verify that and rerun Puppet:

``` bash
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

## More information

See [the documentation](https://www.enterprisemodules.com/docs/ora_config/ora_user.html) what kind of user properties you can manage with Puppet use.

[Continue to the next step](./6-manage-db-parameters.md)
