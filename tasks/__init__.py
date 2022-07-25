from __future__ import annotations

from invoke import Collection

from . import matrix
from . import mirrors

ns = Collection()
ns.add_collection(Collection.from_module(mirrors, name="mirrors"), name="mirrors")
ns.add_collection(Collection.from_module(matrix, name="matrix"), name="matrix")
