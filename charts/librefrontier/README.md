# librefrontier

Custom Helm-Chart for Librefrontier

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.1.0-alpha](https://img.shields.io/badge/Version-0.1.0--alpha-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1-dev](https://img.shields.io/badge/AppVersion-0.0.1--dev-informational?style=flat-square)

## Values

### Pod specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| additionalVolumes | object | `{}` | Additional Volumes |
| affinity | object | `{}` | Affinity expand the types of constraints you can define |
| nodeSelector | object | `{}` | Kubernetes only schedules the Pod onto nodes that have each of the labels you specify |
| podAnnotations | object | `{}` | Additional Pod-annotations |
| podLabels | object | `{}` | Additional Pod-Labels |
| podSecurityContext | object | `{}` | Pod Security Context |
| replicaCount | int | `1` | Number of Pods |
| strategy | object | `{"type":"RollingUpdate"}` | The strategy used to replace old Pods by new ones https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | object | `{}` | Tolerations allow the scheduler to schedule pods with matching taints |

### Librefrontier-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.librefrontier.additionalArgs | object | `{}` | Additional Arguments |
| containers.librefrontier.additionalEnv | object | `{}` | Additional Environment-variables |
| containers.librefrontier.additionalVolumeMounts | object | `{}` | Additional Volume-Mounts for Container |
| containers.librefrontier.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| containers.librefrontier.image.repository | string | `"ghcr.io/lukas-fichtner/librefrontier"` | Container-Image-Repository |
| containers.librefrontier.image.tag | string | `"v0.0.1-dev"` | Container-Image-Tag (by default `.Chart.AppVersion` will be used) |
| containers.librefrontier.resources | object | `{}` | Container R# Service configurationesources |
| containers.librefrontier.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":0,"runAsUser":0}` | Container Security Context |
| containers.librefrontier.service.type | string | `"ClusterIP"` | Service Type |

### Librefrontier-Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.librefrontier.config.LFAPIBaseURL | string | `"http://teufel.wifiradiofrontier.com"` | LF_API_BASE_URL |
| containers.librefrontier.config.ginMode | string | `"release"` | GIN_MODE |
| containers.librefrontier.config.lfDatabaseConnectionString | string | `""` | LF_DB_CONN_STRING |

### Librefrontier-Container-Probes specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.librefrontier.probes.livenessProbe.enabled | bool | `true` | Whether to enable the Liveness-Probe |
| containers.librefrontier.probes.livenessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the Pod |
| containers.librefrontier.probes.livenessProbe.initialDelaySeconds | int | `30` | Initial Delay in Seconds |
| containers.librefrontier.probes.livenessProbe.periodSeconds | int | `10` | How often to perform the liveness checks |
| containers.librefrontier.probes.livenessProbe.successThreshold | int | `1` | Number of successful checks before considering the Pod healthy (again) |
| containers.librefrontier.probes.livenessProbe.timeoutSeconds | int | `5` | Time to wait for a response from the database |
| containers.librefrontier.probes.readinessProbe.enabled | bool | `true` | Whether to enable the Readiness-Probe |
| containers.librefrontier.probes.readinessProbe.failureThreshold | int | `3` | Number of consecutive failures before restarting the Pod |
| containers.librefrontier.probes.readinessProbe.initialDelaySeconds | int | `30` | How long to wait before starting the first readiness Probe after the container starts |
| containers.librefrontier.probes.readinessProbe.periodSeconds | int | `5` | How often to perform the readiness checks after the initial delay |
| containers.librefrontier.probes.readinessProbe.successThreshold | int | `1` | Number of successful checks before considering the Pod healthy |
| containers.librefrontier.probes.readinessProbe.timeoutSeconds | int | `2` | The maximum amount of time the probe will wait for a response from the application |

### IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoute.APIhost | string | `""` | Hostname for the API-Service |
| ingressRoute.certResolver | string | `""` | Name of the Certificate Resolver to use to generate automatic TLS certificates. https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/ |
| ingressRoute.enabled | bool | `false` | Whether to enable the IngressRoute for Librefrontier |
| ingressRoute.entryPoints | list | `[]` | Listening for Incoming Connections/Requests https://doc.traefik.io/traefik/reference/install-configuration/entrypoints/ |
| ingressRoute.webUIHost | string | `""` | Hostname for the Web-UI-Service |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| initContainers | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)