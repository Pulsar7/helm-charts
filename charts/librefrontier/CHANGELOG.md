# CHANGELOG for `charts/librefrontier`

## `0.4.0-alpha.1` to `0.5.0`

> [!CAUTION]
> This release includes **breaking changes**.
>
> Non backwards-compatible Helm-Values changes affecting Services-, IngressRoutes-, Middlewaress- and Container-specifications.

* Add additional configurable default environment-variables at Deployment-manifest template for the `librefrontierContainer`

* __Helm-Values__:
  - Move „main”-Container specifications from `.Values.containers.librefrontier` to `.Values.librefrontierContainer`
  - Please see the commit-history to see all changes

* Update `AppVersion` from `0.0.2-dev` to `v0.0.3-preview`

* Docu: adjust Chart's description