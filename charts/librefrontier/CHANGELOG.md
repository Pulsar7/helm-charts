# CHANGELOG for `charts/librefrontier`

## `0.4.0-alpha.1` to `0.5.0`

> [!CAUTION]
> This release includes **breaking changes**.
>
> Non backwards-compatible Helm-Values changes affecting Services-, IngressRoutes-, Middlewaress- and Container-specifications.

* __Helm-Values__:
  - Move „main”-Container specifications from `.Values.containers.librefrontier` to `.Values.librefrontierContainer`
  - Rename `additionalVolumeMounts` to `extraVolumeMounts`
  - Rename `additionalEnv` to `extraEnv`
  - Rename `additionalArgs` to `extraArgs`
  - Rename `.Values.additionalVolumes` to `.Values.extraVolumes`

* Update `AppVersion` from `0.0.2-dev` to `v0.0.3-preview`

* Docu: adjust Chart's description