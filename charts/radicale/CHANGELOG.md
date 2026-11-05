# CHANGELOG for `charts/radicale`

## `0.2.1` to `0.3.0`

> [!CAUTION]
> **Breaking changes**
>
> Helm-Values and container-image-upgrade.
> There have been made non-backwards compatible adjustments at the Helm-Values.
>
> Please see the `values.yaml` for more detailed information.

#### Helm-Values

* `.Values.ingressRoute.entryPoints` is now empty by default
* `.Values.radicaleContainer.service` does not exist anymore
  - You have to configure the Service-resource at `.Values.service` instead
  - The exposed Container-Ports can be configured at `.Values.radicaleContainer.ports`
* `.Values.radicaleContainer.environmentVariables` has been renamed `.Values.radicaleContainer.env`
* The probes for the `radicaleContainer` are now defined at:
  - `.Values.radicaleContainer.startupProbe`
  - `.Values.radicaleContainer.readinessProbe`
  - `.Values.radicaleContainer.livenessProbe`

## `0.2.0` to `0.2.1`

* 

## `` to `0.2.0`

> [!CAUTION]
> This release includes **breaking changes**!

* Bump default `.Chart.AppVersion` to `3.8.1.1`
* __Breaking__ Helm-Values changes:
  * Removed `containers.radicale`-block and moved radicale-Container-specs to `radicaleContainer`
  * Removed `[containers.radicale].probes`-block and moved `livenessProbe` and `readinessProbe` to `radicaleContainer`-block
  * Renamed `persistence.createNewPVC` to `persistence.createPVC`
* Additional Helm-Values changes:
  * Add `extraContainers`-block to add the option to create sidecars
* Fix typos
