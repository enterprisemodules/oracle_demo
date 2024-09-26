# Manage profiles

One of the other database objects that are easy to manage with our Puppet modules is the database profile. A very common use-case is that we wish to change the properties of the default profile. The standard `DEFAULT` profile allows 10 failed login attempts before taking action. We want to change that to 5. Let's go ahead and do this with Puppet.

Go to the directory `/etc/puppetlabs/code/environments/production/hieradata/` and open the file `edit_in_workshop.yaml`. This file contains all the node-specific data. 

Now add this data to it:

```yaml
#
# Change the default profile
#
ora_profile::database::db_profiles::list:
  'DEFAULT@DB01':
    failed_login_attempts:  5
```

## First Puppet run

Puppet runs will read this data and make sure the profile is available with the specified properties. Puppet will detect that the profile has a different value for `failed_login_attemps`, and it will change the value.

``` bash
puppet apply site.pp 
```

Let's inspect the Puppet output. Somewhere near the top you'll see:

```
Notice: Ensure DB profile(s) DEFAULT@DB01
```

This is the information Puppet provides you about the profiles it manages. When you look at the Puppet output, somewhere near the end, you will see this:

```
Notice: /Stage[main]/Ora_profile::Database::Db_profiles/Ora_profile[DEFAULT@DB01]/failed_login_attempts: failed_login_attempts changed 10 to 5
```

So Puppet adjusted the value for `failed_login_attempts` of the `DEFAULT` profile.

## Second Puppet run

One of the essential features of Puppet is that it is idempotent. Idempotent means it will not apply changes a second time. So if we rerun Puppet, it should see that the `DEFAULT` profile already exists with the specified properties and do nothing.

Let's verify that and rerun Puppet:

``` bash
puppet apply site.pp 
```
We still see the message at the top that Puppet manages the profile, but we no longer have the creation message, just as we expected.

## More information

See [the documentation](https://www.enterprisemodules.com/docs/ora_config/ora_profile.html) what kind of profile properties you can manage with Puppet use.

[Continue to the next step](./5-manage-database-users.md)
