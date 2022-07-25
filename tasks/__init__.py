from __future__ import annotations

from invoke import Collection

from . import containers
from . import matrix

ns = Collection()
ns.add_collection(Collection.from_module(containers, name="containers"), name="containers")
ns.add_collection(Collection.from_module(matrix, name="matrix"), name="matrix")
