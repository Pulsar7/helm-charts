# librefrontier

Custom Helm-Chart to deploy Librefrontier

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.5.3](https://img.shields.io/badge/Version-0.5.3-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.3-preview](https://img.shields.io/badge/AppVersion-v0.0.3--preview-informational?style=flat-square)

## Values

### Pod specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity expand the types of constraints you can define |
| extraVolumes | object | `{}` | Additional Volumes |
| nodeSelector | object | `{}` | Kubernetes only schedules the Pod onto nodes that have each of the labels you specify |
| podAnnotations | object | `{}` | Additional Pod-annotations |
| podLabels | object | `{}` | Additional Pod-Labels |
| podSecurityContext | object | `{"fsGroup":101,"fsGroupChangePolicy":"OnRootMismatch","runAsGroup":101,"runAsNonRoot":true,"runAsUser":100}` | Pod Security Context |
| replicaCount | int | `1` | Number of Pods |
| strategy | object | `{"type":"RollingUpdate"}` | The strategy used to replace old Pods by new ones https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | list | `[]` | Tolerations allow the scheduler to schedule pods with matching taints |

### Config specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.databaseConnectionString.defaultConnectionString | string | `""` | When not using an existing-Secret, enter the database-connection-string. |
| config.databaseConnectionString.existingSecret | bool | `false` | Whether to use an existing Secret or a Secret gets created. |
| config.databaseConnectionString.secretKey | string | `"database-connection-string"` | Secret-key, storing the database-connection-string |
| config.databaseConnectionString.secretName | string | `"librefrontier-secret"` | Name of the Secret, storing the database-connection-string |
| config.enableGUI | bool | `false` | ENABLE_GUI |
| config.ginMode | string | `"release"` | GIN_MODE |
| config.lfAPIBaseURL | string | `"http://teufel.wifiradiofrontier.com"` | LF_API_BASE_URL |
| config.logLevel | string | `"info"` | LOG_LEVEL |
| config.maxConcurrentStreams | int | `10` | MAX_CONCURRENT_STREAMS |
| config.proxyAllStreams | bool | `true` | PROXY_ALL_STREAMS |
| config.radioBrowserURL | string | `"de1.api.radio-browser.info"` | RADIO_BROWSER_URL |

### Extra Containers

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraContainers | list | `[]` | Additional sidecar-Containers |

### IngressRoute/Middlewares specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoutes | object | `{"httpAPI":{"certResolver":"","enabled":false,"entryPoints":[],"name":"http-api","refMiddlewares":[],"refServiceName":"http-api","refServicePortName":"http-api","routeMatch":""}}` | Map of IngressRoutes |
| middlewares | object | `{}` | Map of middlewares added to the IngressRoute |

### IngressRoute/httpAPI specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingressRoutes.httpAPI.certResolver | string | `""` | Name of the TLS-cert-resolver |
| ingressRoutes.httpAPI.enabled | bool | `false` | Whether to create the httpAPI-IngressRoute |
| ingressRoutes.httpAPI.entryPoints | list | `[]` | List of entryPoints |
| ingressRoutes.httpAPI.name | string | `"http-api"` | Name of IngressRoute resource |
| ingressRoutes.httpAPI.refMiddlewares | list | `[]` | List with names of Middlewares |
| ingressRoutes.httpAPI.refServiceName | string | `"http-api"` | Name of referenced Service |
| ingressRoutes.httpAPI.refServicePortName | string | `"http-api"` | Name of referenced Service-Port |
| ingressRoutes.httpAPI.routeMatch | string | `""` | Route-Match |

### Init-Containers

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| initContainers | list | `[]` | Init-Containers |

### Librefrontier-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| librefrontierContainer.extraArgs | list | `[]` | Additional Arguments for the librefrontier-'main'-Container |
| librefrontierContainer.extraEnv | list | `[]` | Additional Environment-variables for the librefrontier-'main'-Container |
| librefrontierContainer.extraVolumeMounts | list | `[]` | Additional Volume-Mounts for the librefrontier-'main'-Container |
| librefrontierContainer.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| librefrontierContainer.image.registry | string | `"ghcr.io"` | Container-Image registry |
| librefrontierContainer.image.repository | string | `"lukas-fichtner/librefrontier"` | Container-Image repository |
| librefrontierContainer.image.tag | string | `""` | Container-Image-Tag (overrides `.Chart.AppVersion`) |
| librefrontierContainer.livenessProbe | object | `{}` |  |
| librefrontierContainer.ports | object | `{"httpAPI":{"containerPort":80,"name":"http-api"},"httpWebUI":{"containerPort":8080,"name":"http-web-ui"}}` | Exposed Container-ports |
| librefrontierContainer.readinessProbe | object | `{}` |  |
| librefrontierContainer.resources | object | `{}` | Container resource requests and limits |
| librefrontierContainer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"privileged":false,"runAsGroup":101,"runAsUser":100}` | Container Security Context |
| librefrontierContainer.startupProbe | object | `{}` |  |

### Librefrontier-Container/ports specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| librefrontierContainer.ports.httpAPI.containerPort | int | `80` | Port-number of exposed http Container-port |
| librefrontierContainer.ports.httpAPI.name | string | `"http-api"` | Name of exposed http Container-port |
| librefrontierContainer.ports.httpWebUI.containerPort | int | `8080` | Port-number of exposed http Container-port |
| librefrontierContainer.ports.httpWebUI.name | string | `"http-web-ui"` | Name of exposed http Container-port |

### Services specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| services.httpAPI.ports.httpAPI.portNumber | int | `80` | Exposed Service-port |
| services.httpAPI.ports.httpAPI.protocol | string | `"TCP"` | Protocol |
| services.httpAPI.ports.httpAPI.servicePortName | string | `"http-api"` | Name of the Service-port |
| services.httpAPI.ports.httpAPI.targetPort | string | `"http-api"` | Reference exposed Container-port by its name |
| services.httpAPI.serviceName | string | `"http-api"` | Service-Name for the http-API Service |
| services.httpAPI.type | string | `"ClusterIP"` | Service-Type |
| services.httpWebUI.ports.httpWebUI.portNumber | int | `8080` | Exposed Service-port |
| services.httpWebUI.ports.httpWebUI.protocol | string | `"TCP"` | Protocol |
| services.httpWebUI.ports.httpWebUI.servicePortName | string | `"http-web-ui"` | Name of the Service-port |
| services.httpWebUI.ports.httpWebUI.targetPort | string | `"http-web-ui"` | Reference exposed Container-port by its name |
| services.httpWebUI.serviceName | string | `"http-web-ui"` | Service-Name for the http-Web-UI Service |
| services.httpWebUI.type | string | `"ClusterIP"` | Service-Type |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)