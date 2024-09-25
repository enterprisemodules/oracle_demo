[![Enterprise Modules](https://raw.githubusercontent.com/enterprisemodules/public_images/master/banner1.jpg)](https://www.enterprisemodules.com)

# Demo Puppet implementation

## Required software

For the box to run it needs a Oracle Database software.


- `LINUX.X64_193000_db_home.zip`                  (19c oracle home)
- `p6880880_190000_Linux-x86-64-12.2.0.1.33.zip`  (OPatch version 12.2.0.1.33)
- `p34416665_190000_Linux-x86-64.zip`             (19c OCT2022RU)
- `p34411846_190000_Linux-x86-64.zip`             (19c OCT2022RU OJVM)


The software must be placed in `modules/software/files`. It must contain the next files:

### OPatch update file

We have chosen to rename the download of the OPatch updates to contain the version of OPatch in the name.
This makes it more clear which version is included in the zipfile. Make sure to also rename the zipfile when using this demo.

## Starting the node

To start the node for the first time, run:

```bash
vagrant up ml-db01
```


## Running puppet

Although puppet normaly is running client-server mode, for simplicity in this demo we will use the masterless approach. That means you have to run puppet manualy. The command is:

```
puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp
```

The basic `vagrant up` will already run puppet for the first time.


## Experimenting with Puppet for Oracle

- [intro](workshop/intro.md)
- [Ensure Tablespaces](workshop/1-ensure-tablespaces.md)
- [Change Tablespaces](workshop/2-change-tablespaces.md)
- [More Tablespace-properties](workshop/3-more-tablespace-properties.md)
- [Manage Profiles](workshop/4-manage-profiles.md)
- [Manage DB users](workshop/5-manage-database-users.md)
- [Manage DB parameters](workshop/6-manage-db-parameters.md)
- [Secure your database](workshop/7-secure-your-database.md)
- [Epilogue](workshop/epilogue.md)


