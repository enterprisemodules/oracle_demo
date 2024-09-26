# Secure your database

A standard installed Oracle database is pretty open. Meaning insecure. The Center For Internet Security (CIS) has defined a benchmark for Oracle database security. With Puppet, it is pretty easy to apply this benchmark to your database and make your database secure.

## Apply the CIS benchmark

Go to the directory `/etc/puppetlabs/code/environments/production/hieradata/` and open the file `edit_in_workshop.yaml`. This file contains all the node-specific data. Now look for the line that starts with `role`. It now contains the string: `role::database`. To make your database a secured database, you need to change it to `role::secured_database`.

## First noop Puppet run

When you run Puppet now for the first time, it will start inspecting the security and directly fix it. This is probably not what you want right now. For now, to see what it will change, we will use the `--noop` switch for Puppet.

``` bash
puppet apply site.pp --noop
```

You'll see a large list of things that Puppet would change. The generated notices look like this:

```
Notice: /Stage[main]/Ora_secured::Db19c::V1_1_0::P3_1::Db01 Ora_secured::Controls::Failed_login_attempts_is_less_than_or_equal_to_5[DB01]......
```

The part after `Ora_secured::Db19c::V1_1_0::` is the CIS paragraf (e.g. rule) that this change belongs to. It is very likely that your application deosn work anymore if you apply **ALL** rules. You have to start inspecting and evaluating the changes.

## Customise

In the `edit_in_workshop.yaml` file at the bottom you see a commented out list of all the rules and the text `skip`. If your hiera data contains this key, the test will be skipped. SO uncomment a few rules and run puppet with noop again. You'll see that the number of changes will shrink.

## Second noop Puppet run 

No when we run Puppet, the warning will no longer be issues.

``` bash
puppet apply site.pp --noop
```

## The real deal

You probably will have to apply more customisations for your database, but for teaching porposes, we are ready to apply all these changes to the database. Let's run Puppet for real:

``` bash
puppet apply site.pp
```

[Continue to the next step](./epilogue.md)
