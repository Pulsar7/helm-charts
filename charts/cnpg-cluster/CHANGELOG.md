# Changelog for the 'cnpg-cluster' Helm-Chart

# v0.2.1

* Fix indentation of labels-object in cnpg-cluster-manifest template

# v0.2.0

> [!CAUTION]
> Upgrading from `0.1.0` needs adjusting Helm-Values, since the Helm-field `backupCronjob.persistentVolumeClaimName` doesn't exist anymore. Please configure the claim-name of the PVC at `backupCronjob.persistentVolumeClaim.claimName`.
> By default, the Chart is creating a **new** PVC-Resource based on the Helm-Values specificed at `backupCronjob.persistentVolumeClaim`. Set `backupCronjob.persistentVolumeClaim.useExisting: true` if you want to use an existing PVC with the provided Claim-Name instead.

- Create new **PVC**-Resource for **CronJob** db-dump by default instead of using an existing PVC

# v0.1.0

- Initial version
- Helm-Untittests for **CronJob**- and **Cluster**-Resources
