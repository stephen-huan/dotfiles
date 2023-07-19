# micromamba

- re-implementation of [conda](/pkgs/tools/package-management/conda.md) in C++
- uses `libsolv`, library used by Red Hat's `dnf` and others (see
  [internals](https://mamba.readthedocs.io/en/latest/developer_zone/internals.html))
- pretty much drop-in replacement, just much faster
