# Changelog for helm-charts/radicale

## 0.2.0

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
