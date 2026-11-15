# CHANGELOG for `charts/librefrontier`

## `0.5.2` to `0.5.3`

* __Fix__: Make tls-termination at IngressRoute-manifest templates optional instead of mandatory

## `0.5.1` to `0.5.2`

* Move `httpWebUI`-Service at Helm-Values to own Service-resource instead of being a port at the `httpAPI`-Service

## `0.5.0` to `0.5.1`

* __Fix__: surround all 'main'-container environment-variables values with double quotes

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