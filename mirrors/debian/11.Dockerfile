FROM debian:11
# Debian 11 (bullseye) reached EOL on 2026-08-31. The live
# debian-security repository InRelease signature is no longer refreshed
# and packages have been purged from deb.debian.org. Pin sources to a
# snapshot.debian.org timestamp taken a week before EOL and install a
# persistent apt config that disables the Valid-Until freshness check.
# GPG signature verification is unaffected.
RUN printf 'deb http://snapshot.debian.org/archive/debian/20260824T000000Z bullseye main\ndeb http://snapshot.debian.org/archive/debian-security/20260824T000000Z bullseye-security main\ndeb http://snapshot.debian.org/archive/debian/20260824T000000Z bullseye-updates main\n' > /etc/apt/sources.list
RUN printf 'Acquire::Check-Valid-Until "false";\nAcquire::Retries "5";\nAcquire::http::Timeout "60";\n' > /etc/apt/apt.conf.d/99-bullseye-eol
RUN apt-get update
RUN apt-get upgrade -y
