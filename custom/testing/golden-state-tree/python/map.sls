{% set python = salt['grains.filter_by']({
    'Arch': {
        'pkgs': [
        ],
    },
    'Debian': {
        'pkgs': [
        ],
    },
    'OpenBSD': {
        'pkgs': [
        ],
    },
    'RedHat': {
        'pkgs': [
        ],
    },
    'Suse': {
        'pkgs': [
        ],
    },
    'FreeBSD': {
        'pkgs': [
        ],
    },
    'Gentoo': {
        'pkgs': [
        ],
    },
}, merge=salt['pillar.get']('python:lookup')) %}
