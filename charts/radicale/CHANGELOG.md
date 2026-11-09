# CHANGELOG for `charts/radicale`

## `0.3.1` to `0.3.2`

* Update `AppVersion` from `3.8.1.1` to `3.8.3`

## `0.3.0` to `0.3.1`

* __Helm-Values__:
  - Adjust `.Values.radicaleContainer`- and `Service`-ports naming to use dedicated `name`-Helm-Values field instead of interpreting object-name as string
  - Rename `.Values.configFile.dynamicValues.serverSection` to `.Values.configFile.dynamicValues.extraServerSection`
  - `.Values.configFile.dynamicValues.extraServerSection` is empty by default and `host` is configured as `hosts = 0.0.0.0: {{ .Values.radicaleContainer.ports.http.containerPort }}`

* __Documentation__: Add `Authentication`-section to README

* __Helm unittests__: Add additional `helm-unittest`-Tests
  * move Deployment-Annotations-check to `Test Deployment/Annotations`-test-suite
  * move unittests which should result in a failed template of Deployment to `Test Deployment/Failed Template`-test-suite

* Remove `checksum/pvc` annotation from Deployment-manifest template (`deployment.yaml`) 

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

#### Additional Helm-Value validation

This version adds additional Helm values validation checks as template functions. If a check fails, Helm chart rendering fails.

## `0.2.0` to `0.2.1`

* __Fix__ indentation of `metadata.labels` at IngressRoute-manifest

## `0.1.10-alpha` to `0.2.0`

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
