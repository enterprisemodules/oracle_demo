# Docs
class role::oradb::simple_db {
  contain profile::base
  contain ora_profile::database

  Class['profile::base']
  -> Class['ora_profile::database']
}
