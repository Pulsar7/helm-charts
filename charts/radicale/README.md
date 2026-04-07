# radicale

Custom Helm-Chart for Radicale

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.1.8-alpha](https://img.shields.io/badge/Version-0.1.8--alpha-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.6.1.0](https://img.shields.io/badge/AppVersion-3.6.1.0-informational?style=flat-square)

## Values

### Pod specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalVolumes | object | `{}` | Additional Volumes |
| affinity | object | `{}` | Affinity expand the types of constraints you can define |
| nodeSelector | object | `{}` | Kubernetes only schedules the Pod onto nodes that have each of the labels you specify |
| podAnnotations | object | `{}` | Additional Pod-annotations |
| podLabels | object | `{}` | Additional Pod-Labels |
| podSecurityContext | object | `{"fsGroup":2999,"runAsGroup":2999,"runAsNonRoot":true,"runAsUser":2999}` | Pod Security Context |
| replicaCount | int | `1` | Number of Pods |
| strategy | object | `{"type":"Recreate"}` | The strategy used to replace old Pods by new ones https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | object | `{}` | Tolerations allow the scheduler to schedule pods with matching taints |

### Radicale-Authentication specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| authentication.existingSecretName | string | `""` | Name of an existing Secret for Users. A Secret will be created if not set. |
| authentication.secretKey | string | `"users"` | Secret-Key Name for Users |

### config Config-File

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configFiles.config.dynamicValues.authSection | string | `"type = htpasswd\nhtpasswd_filename = /config/users\nhtpasswd_encryption = bcrypt"` | `[auth]`-Section |
| configFiles.config.dynamicValues.serverSection | string | `"hosts: 0.0.0.0:5232"` | `[server]`-Section |
| configFiles.config.dynamicValues.storageSection | string | `"type = multifilesystem\nfilesystem_folder = /data/collections"` | `[storage]`-Section |
| configFiles.config.ownConfigFileContent | string | `""` | Provide own 'config' file-content |
| configFiles.config.useOwnConfigFileContent | bool | `false` | Whether to use your own 'config'-file |

### Radicale-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.radicale.additionalVolumeMounts | object | `{}` | Additional Volume-Mounts for Container |
| containers.radicale.environmentVariables | list | `[{"name":"TAKE_FILE_OWNERSHIP","value":"false"}]` | Environment variables for the Container |
| containers.radicale.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| containers.radicale.image.repository | string | `"tomsquest/docker-radicale"` | Container-Image-Repository |
| containers.radicale.image.tag | string | `"3.6.1.0"` | Container-Image-Tag (by default `.Chart.AppVersion` will be used) |
| containers.radicale.resources | object | `{}` | Container Resources |
| containers.radicale.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":2999,"runAsNonRoot":true,"runAsUser":2999}` | Container Security Context |
| containers.radicale.service.type | string | `"ClusterIP"` | Service Type |

### Radicale-Container-Probes specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.radicale.probes.livenessProbe.enabled | bool | `true` | Whether to enable the Liveness-Probe |
| containers.radicale.probes.livenessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the Pod |
| containers.radicale.probes.livenessProbe.initialDelaySeconds | int | `30` | Initial Delay in Seconds |
| containers.radicale.probes.livenessProbe.periodSeconds | int | `10` | How often to perform the liveness checks |
| containers.radicale.probes.livenessProbe.successThreshold | int | `1` | Number of successful checks before considering the Pod healthy (again) |
| containers.radicale.probes.livenessProbe.timeoutSeconds | int | `5` | Time to wait for a response from the database |
| containers.radicale.probes.readinessProbe.enabled | bool | `true` | Whether to enable the Readiness-Probe |
| containers.radicale.probes.readinessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the Pod |
| containers.radicale.probes.readinessProbe.initialDelaySeconds | int | `30` | How long to wait before starting the first readiness Probe after the container starts |
| containers.radicale.probes.readinessProbe.periodSeconds | int | `5` | How often to perform the readiness checks after the initial delay |
| containers.radicale.probes.readinessProbe.successThreshold | int | `1` | Number of successful checks before considering the Pod healthy |
| containers.radicale.probes.readinessProbe.timeoutSeconds | int | `2` | The maximum amount of time the probe will wait for a response from the application |

### IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoute.certResolver | string | `""` | Name of the Certificate Resolver to use to generate automatic TLS certificates. https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/ |
| ingressRoute.enabled | bool | `false` | Whether to enable the IngressRoute for NTFY |
| ingressRoute.entryPoints | list | `["websecure"]` | Listening for Incoming Connections/Requests https://doc.traefik.io/traefik/reference/install-configuration/entrypoints/ |
| ingressRoute.host | string | `""` | Hostname |

### Radicale-Persistence specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access-Modes of the PVC |
| persistence.claimName | string | `""` | Name of the PVC |
| persistence.createNewPVC | bool | `true` | Whether to create a new PVC |
| persistence.emptyDirSizeLimit | string | `"1Gi"` | SizeLimit for emptyDir (used when persistence is disabled) |
| persistence.enabled | bool | `true` | Whether to enable persistence for collections-data (enables PVC). Otherwise local ephemeral storage is being used (emptyDir). |
| persistence.storageClassName | string | `""` | StorageClassName of the PVC |
| persistence.storageRequest | string | `"5Gi"` | storage-request for the PVC |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)