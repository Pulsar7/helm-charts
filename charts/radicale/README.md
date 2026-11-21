# radicale

Custom Helm chart to deploy radicale

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.9.0.0](https://img.shields.io/badge/AppVersion-3.9.0.0-informational?style=flat-square)

## Authentication

Keep in mind that by default a **Secret**-Resource gets created which stores a default user `test` with the password `lol1234`.
Please deploy your own Secret with the required users instead of defining them at the `configFile`.

## Values

### Pod specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity expand the types of constraints you can define |
| extraVolumes | list | `[]` | Additional Volumes |
| nodeSelector | object | `{}` | Kubernetes only schedules the Pod onto nodes that have each of the labels you specify |
| podAnnotations | object | `{}` | Additional Pod-annotations |
| podLabels | object | `{}` | Additional Pod-Labels |
| podSecurityContext | object | `{"fsGroup":2999,"runAsGroup":2999,"runAsNonRoot":true,"runAsUser":2999}` | Pod Security Context |
| replicaCount | int | `1` | Number of Pods |
| strategy | object | `{"type":"Recreate"}` | The strategy used to replace old Pods by new ones https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy |
| tolerations | list | `[]` | Tolerations allow the scheduler to schedule pods with matching taints |

### radicale-Authentication specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| authentication.secretKey | string | `"users"` | Secret-Key Name for Users |
| authentication.secretName | string | `""` | Name of the Secret (overrides the default) |
| authentication.useExistingSecret | bool | `false` | Whether to use an existing Secret instead |

### Config specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| configFile.configMapKey | string | `"config.conf"` | Key to the ConfigMap-item |
| configFile.configMapName | string | `""` | Name of the existing ConfigMap |
| configFile.dynamicValues.authSection | string | `"type = htpasswd\nhtpasswd_filename = /config/users\nhtpasswd_encryption = bcrypt"` | `[auth]`-Section |
| configFile.dynamicValues.extraServerSection | string | `""` | Additional configuration for the `[server]`-Section. `hosts` is configured automatically, based on the configured exposed containerPort for `http`. |
| configFile.dynamicValues.loggingSection | string | `"level = info"` | `[logging]`-Section |
| configFile.dynamicValues.rightsSection | string | `"type = owner_only"` | `[rights]`-Section |
| configFile.dynamicValues.storageSection | string | `"type = multifilesystem\nfilesystem_folder = /data/collections"` | `[storage]`-Section |
| configFile.dynamicValues.webSection | string | `"type = internal"` | `[web]`-Section |
| configFile.useExistingConfigMap | bool | `false` | Whether to use an existing ConfigMap instead |

### Extra-Containers specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraContainers | list | `[]` | List of sidecar-Containers |

### Ingress/IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraIngressRoutes | object | `{}` | Define additional IngressRoute-resources |

### Additional-Service specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraServices | object | `{}` | Additional Services |

### Ingress/HTTP-IngressRoute specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| httpIngressRoute.certResolver | string | `""` | Name of the Certificate Resolver to use to generate automatic TLS certificates. https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/ |
| httpIngressRoute.enabled | bool | `false` | Whether to enable the HTTP-IngressRoute for radicale |
| httpIngressRoute.entryPoints | list | `[]` | Listening for Incoming Connections/Requests https://doc.traefik.io/traefik/reference/install-configuration/entrypoints/ |
| httpIngressRoute.name | string | `"http"` | Name of the HTTP-IngressRoute for radicale |
| httpIngressRoute.refMiddlewares | list | `[]` | Reference Middleware |
| httpIngressRoute.routeMatch | string | `"Host(``)"` | Route-Match of the IngressRoute |

### HTTP-Service specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| httpService | object | `{"additionalSpecs":{},"httpPort":{"name":"http","portNumber":5000,"protocol":"TCP"},"serviceName":"http","type":"ClusterIP"}` | Specification for the exposed HTTP-Service |
| httpService.additionalSpecs | object | `{}` | Additional specifications for the Service |
| httpService.httpPort.name | string | `"http"` | Name of Service-port |
| httpService.httpPort.portNumber | int | `5000` | Exposed Service-port |
| httpService.httpPort.protocol | string | `"TCP"` | Protocol |
| httpService.serviceName | string | `"http"` | Name of the HTTP-Service |
| httpService.type | string | `"ClusterIP"` | Type of the NTFY-Service resource |

### Ingress/Middleware specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| middlewares | object | `{}` | Traefik Middlewares that should be used by the IngressRoute-rule. |

### radicale-Persistence specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access-Modes of the PVC |
| persistence.claimName | string | `""` | Name of existing PersistentVolumeClaim. Gets ignored when `persistence.createPVC: true` |
| persistence.createPVC | bool | `true` | Whether to create a new PVC instead of referencing an existing one. |
| persistence.emptyDirSizeLimit | string | `"1Gi"` | SizeLimit for emptyDir (used when persistence is disabled) |
| persistence.enabled | bool | `true` | Whether to enable persistence for collections-data (enables PVC). Otherwise local ephemeral storage is being used (emptyDir). |
| persistence.storageClassName | string | `""` | StorageClassName of the PVC |
| persistence.storageRequest | string | `"5Gi"` | storage-request for the PVC |

### radicale-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| radicaleContainer.extraEnvs | list | `[]` | Additional environment variables for the Container |
| radicaleContainer.extraPorts | object | `{}` | Expose additional Container-ports |
| radicaleContainer.extraVolumeMounts | list | `[]` | Additional Volume-Mounts for Container |
| radicaleContainer.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| radicaleContainer.image.repository | string | `"tomsquest/docker-radicale"` | Container-Image-Repository |
| radicaleContainer.image.tag | string | `""` | Container-Image-Tag (overrides `.Chart.AppVersion`) |
| radicaleContainer.livenessProbe | object | `{}` | Liveness-Probe |
| radicaleContainer.readinessProbe | object | `{}` | Readiness-Probe |
| radicaleContainer.resources | object | `{}` | Container Resources |
| radicaleContainer.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":2999,"runAsNonRoot":true,"runAsUser":2999}` | Container Security Context |
| radicaleContainer.startupProbe | object | `{}` | Startup-Probe |

### radicale-Container/ports/httpPort specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| radicaleContainer.httpPort | object | `{"containerPort":5000,"name":"http"}` | HTTP-Port specifications |
| radicaleContainer.httpPort.containerPort | int | `5000` | Exposed port-number of the HTTP-Container port |
| radicaleContainer.httpPort.name | string | `"http"` | Name of the HTTP-Container port |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)