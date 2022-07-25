from __future__ import annotations

from invoke import Collection

from . import containers

ns = Collection()
ns.add_collection(Collection.from_module(containers, name="containers"), name="containers")
