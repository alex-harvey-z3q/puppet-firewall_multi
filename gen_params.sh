#!/usr/bin/env bash

if [[ "$(uname -s)" == "Darwin" ]] ; then
  brew_prefix="$(brew --prefix 2>/dev/null)"

  if [ ! -x "$brew_prefix"/bin/gsed ] ; then
    echo "On MacOS you need to install gnu-sed:"
    echo "$ brew install gnu-sed"
    exit 1
  fi

  shopt -s expand_aliases

  # shellcheck disable=SC2139
  alias sed="$brew_prefix"/bin/gsed
fi

path_to_firewall=../puppetlabs-firewall  # Path to wherever the firewall module
                                         # is checked out.

_firewall_lib() {
  cat "$path_to_firewall"/lib/puppet/type/firewall.rb
}

usage() {
  echo "Usage: bash $0 > manifests/init.pp"
  exit 1
}

header() {
  cat <<-'EOF'
		# @summary A defined type wrapper for spawning
		#   [puppetlabs/firewall](https://github.com/puppetlabs/puppetlabs-firewall)
		#   resources for arrays of certain inputs.
		#
		# @param [Array] source An array of source IPs or CIDRs.
		# @param [Array] destination An array of destination IPs or CIDRs.
		# @param [Array] proto An array of proto's.
		# @param [Array] icmp An array of ICMP types.
		# @param [Array] protocol An array of protocols.
		#
		define firewall_multi (
		  $ensure                      = undef,
	EOF
}

middle() {
  cat <<-'EOF'
		) {
		
		  $firewalls = firewall_multi(
		    {
		      $name => {
		        ensure                       =>  $ensure,
	EOF
}

footer() {
  cat <<-'EOF'
		      }
		    }
		  )
		
		  create_resources(firewall, $firewalls)
		}
	EOF
}

transform() {
  local mode="$1"
  local indent="$2"

  _firewall_lib | awk -v mode="$mode" '
    BEGIN {
      trim = "^[ \t]+|[ \t]+$"
    }

    /^  attributes: {/ {
      flag=1
      next
    }

    /^  }/ {
      flag=0
    }

    /^    [^ }]/ {
      if (!flag) next
      if (/^  *name:/) next
      if (/^  *ensure:/) next

      split($0, arr, ":")
      gsub(trim, "", arr[1])

      if (mode == "parameter") {
        print "$" arr[1] " = undef,"
      } else if (mode == "attribute") {
        print arr[1] " => $" arr[1] ","
      }
    }

  ' | sort | column -t | sed '

    s/^/'"$indent"'/
    s/ = /=/
  '
}

main() {
  [[ "$1" == -h ]] && usage
  header
  transform "parameter" "  "
  middle
  transform "attribute" "        "
  footer
}

if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
  main "$@"
fi

# vim: set ft=sh:
