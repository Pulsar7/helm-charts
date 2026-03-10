# ntfy

Custom Helm-Chart for NTFY

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.1.2-alpha.1](https://img.shields.io/badge/Version-0.1.2--alpha.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

## Values

### Pod specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalVolumes | object | `{}` | Additional Volumes |
| affinity | object | `{}` | Affinity expand the types of constraints you can define |
| nodeSelector | object | `{}` | Kubernetes only schedules the Pod onto nodes that have each of the labels you specify |
| podAnnotations | object | `{}` | Additional Pod-annotations |
| podLabels | object | `{}` | Additional Pod-Labels |
| podSecurityContext | object | `{"fsGroup":10000,"runAsGroup":10000,"runAsNonRoot":true,"runAsUser":10000}` | Pod Security Context |
| replicaCount | int | `1` | Number of Pods |
| strategy | object | `{"type":"Recreate"}` | The strategy used to replace old Pods by new ones https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | object | `{}` | Tolerations allow the scheduler to schedule pods with matching taints |

### NTFY-Authentication specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| authentication.authAccess.existingSecretName | string | `""` | Name of an existing Secret for Authentication-Access. A Secret will be created if not set. |
| authentication.authAccess.secretKey | string | `"auth-access"` | Secret-Key Name for Authentication-Access |
| authentication.authTokens.existingSecretName | string | `""` | Name of an existing Secret for Authentication-Tokens. A Secret will be created if not set. |
| authentication.authTokens.secretKey | string | `"auth-tokens"` | Secret-Key Name for Authentication-Tokens |
| authentication.authUsers.existingSecretName | string | `""` | Name of an existing Secret for Authentication-Users. A Secret will be created if not set. |
| authentication.authUsers.secretKey | string | `"auth-users"` | Secret-Key Name for Authentication-Users |

### server.yaml Config-File

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configFiles.serverYAML.dynamicValues.authAccess | list | `[]` | auth-access (Secret is recommended instead) |
| configFiles.serverYAML.dynamicValues.authDefaultAccess | string | `"deny-all"` | auth-default-access |
| configFiles.serverYAML.dynamicValues.authFile | string | `"/var/lib/ntfy/user.db"` | auth-file |
| configFiles.serverYAML.dynamicValues.authTokens | list | `[]` | auth-tokens (Secret is recommended instead) |
| configFiles.serverYAML.dynamicValues.authUsers | list | `[]` | auth-users (Secret is recommended instead) |
| configFiles.serverYAML.dynamicValues.behindProxy | bool | `false` | Whether NTFY is behind a Proxy |
| configFiles.serverYAML.dynamicValues.cacheDuration | string | `"72h"` | cache-duration |
| configFiles.serverYAML.dynamicValues.cacheFile | string | `"/var/lib/ntfy/cache.db"` | cache-file |
| configFiles.serverYAML.dynamicValues.proxyForwardedHeader | string | `""` | Forwarded Proxy-Header (e.g. "X-Forwarded-For") |
| configFiles.serverYAML.ownConfigFileContent | string | `""` | Provide own 'server.yaml' file-content |
| configFiles.serverYAML.useOwnConfigFileContent | bool | `false` | Whether to use your own 'server.yaml'-file |

### NTFY-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.ntfy.additionalArgs | object | `{}` | Additional Arguments |
| containers.ntfy.additionalEnv | object | `{}` | Additional Environment-variables |
| containers.ntfy.additionalVolumeMounts | object | `{}` | Additional Volume-Mounts for Container |
| containers.ntfy.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| containers.ntfy.image.repository | string | `"docker.io/binwiederhier/ntfy"` | Container-Image-Repository |
| containers.ntfy.image.tag | string | `"v2.18"` | Container-Image-Tag (by default `.Chart.AppVersion` will be used) |
| containers.ntfy.resources | object | `{}` | Container Resources |
| containers.ntfy.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":10000,"runAsNonRoot":true,"runAsUser":10000}` | Container Security Context |
| containers.ntfy.service.type | string | `"ClusterIP"` | Service Type |

### NTFY-Container-Probes specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.ntfy.probes.livenessProbe.enabled | bool | `true` | Whether to enable the Liveness-Probe |
| containers.ntfy.probes.livenessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the Pod |
| containers.ntfy.probes.livenessProbe.initialDelaySeconds | int | `30` | Initial Delay in Seconds |
| containers.ntfy.probes.livenessProbe.periodSeconds | int | `10` | How often to perform the liveness checks |
| containers.ntfy.probes.livenessProbe.successThreshold | int | `1` | Number of successful checks before considering the Pod healthy (again) |
| containers.ntfy.probes.livenessProbe.timeoutSeconds | int | `5` | Time to wait for a response from the database |
| containers.ntfy.probes.readinessProbe.enabled | bool | `true` | Whether to enable the Readiness-Probe |
| containers.ntfy.probes.readinessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the Pod |
| containers.ntfy.probes.readinessProbe.initialDelaySeconds | int | `30` | How long to wait before starting the first readiness Probe after the container starts |
| containers.ntfy.probes.readinessProbe.periodSeconds | int | `5` | How often to perform the readiness checks after the initial delay |
| containers.ntfy.probes.readinessProbe.successThreshold | int | `1` | Number of successful checks before considering the Pod healthy |
| containers.ntfy.probes.readinessProbe.timeoutSeconds | int | `2` | The maximum amount of time the probe will wait for a response from the application |

### IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoute.certResolver | string | `""` | Name of the Certificate Resolver to use to generate automatic TLS certificates. https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/ |
| ingressRoute.enabled | bool | `false` | Whether to enable the IngressRoute for NTFY |
| ingressRoute.entryPoints | list | `["websecure"]` | Listening for Incoming Connections/Requests https://doc.traefik.io/traefik/reference/install-configuration/entrypoints/ |
| ingressRoute.host | string | `""` | Hostname |

### NTFY-Persistence specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access-Modes of the PVC |
| persistence.claimName | string | `"ntfy-data-pvc"` | Name of the PVC |
| persistence.createNewPVC | bool | `true` | Whether to create a new PVC |
| persistence.emptyDirSizeLimit | string | `"1Gi"` | SizeLimit for emptyDir (used when persistence/PVC is disabled) |
| persistence.enabled | bool | `false` | Whether to enable persistence for 'cache.db' and 'user.db' (enables PVC) |
| persistence.storageClassName | string | `""` | StorageClassName of the PVC |
| persistence.storageRequest | string | `"5Gi"` | storage-request for the PVC |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)