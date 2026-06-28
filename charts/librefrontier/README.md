# librefrontier

Custom Helm-Chart for Librefrontier

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.3.1-alpha.1](https://img.shields.io/badge/Version-0.3.1--alpha.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.0.1-dev](https://img.shields.io/badge/AppVersion-0.0.1--dev-informational?style=flat-square)

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
| tolerations | list | `[]` | Tolerations allow the scheduler to schedule pods with matching taints |

### Librefrontier-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.librefrontier.additionalArgs | object | `{}` | Additional Arguments |
| containers.librefrontier.additionalEnv | object | `{}` | Additional Environment-variables |
| containers.librefrontier.additionalVolumeMounts | object | `{}` | Additional Volume-Mounts for Container |
| containers.librefrontier.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| containers.librefrontier.image.repository | string | `"ghcr.io/lukas-fichtner/librefrontier"` | Container-Image-Repository |
| containers.librefrontier.image.tag | string | `"v0.0.1-dev"` | Container-Image-Tag (by default `.Chart.AppVersion` will be used) |
| containers.librefrontier.resources | object | `{}` | Container resource requests and limits |
| containers.librefrontier.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":0,"runAsUser":0}` | Container Security Context |

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

### Librefrontier-Container HTTP-API-Service specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.librefrontier.services.httpAPI.containerPort | int | `80` | HTTP-API Container-Port |
| containers.librefrontier.services.httpAPI.nodePort | string | `nil` | HTTP-API NodePort (if `services.httpAPI.type: NodePort`) |
| containers.librefrontier.services.httpAPI.port | int | `80` | HTTP-API internal exposed Port |
| containers.librefrontier.services.httpAPI.type | string | `"ClusterIP"` | HTTP-API Service-type |

### Librefrontier-Container Web-UI-Service specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| containers.librefrontier.services.webUI.containerPort | int | `8080` | Web-UI Container-Port |
| containers.librefrontier.services.webUI.enabled | bool | `false` | Whether to enable the Web-UI Service |
| containers.librefrontier.services.webUI.nodePort | string | `nil` | Web-UI NodePort (if `services.httpAPI.type: NodePort`) |
| containers.librefrontier.services.webUI.port | int | `8080` | Web-UI internal exposed port |
| containers.librefrontier.services.webUI.type | string | `"ClusterIP"` | Web-UI Service-type |

### HTTP-API-IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| httpAPIIngressRoute.enabled | bool | `false` | Whether to enable the HTTP-API-IngressRoute |
| httpAPIIngressRoute.entryPoints | HTTP-only | `[]` | -Entrypoints for API-Service |
| httpAPIIngressRoute.host | string | `""` | Hostname for the API-Service |

### Init-Containers

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| initContainers | list | `[]` | Librefrontier Init-Containers |

### Librefrontier-Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| librefrontierConfig.LFAPIBaseURL | string | `"http://teufel.wifiradiofrontier.com"` | LF_API_BASE_URL |
| librefrontierConfig.databaseConnectionString.existingSecret | bool | `false` | Whether to use an existing Secret or a default Secret should be generated storing a default database-connection-string. |
| librefrontierConfig.databaseConnectionString.secretName | string | `"librefrontier-secret"` | Name of the Secret, storing the database-connection-string. Secret-Key is 'database-connection-string' |
| librefrontierConfig.databaseConnectionString.stringData | string | `""` | When not using an existing-Secret, enter the database-connection-string. |
| librefrontierConfig.ginMode | string | `"release"` | GIN_MODE |

### Web-UI IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| webUIIngressRoute.certResolver | string | `""` | Name of the Certificate Resolver to use to generate automatic TLS certificates. https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/ |
| webUIIngressRoute.enabled | bool | `false` | Whether to enable the Web-UI-IngressRoute. requires `services.webUI.enabled: true` otherwise this gets ignored! |
| webUIIngressRoute.entryPoints | HTTP-only | `[]` | -Entrypoints for Web-UI-Service |
| webUIIngressRoute.host | string | `""` | Hostname for the API-Service |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)