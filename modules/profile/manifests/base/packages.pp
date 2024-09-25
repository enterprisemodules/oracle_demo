#
# Make sure all required packages are installed
#
class profile::base::packages {
  $required_package = {}

  ensure_resources('package', $required_package)
}
