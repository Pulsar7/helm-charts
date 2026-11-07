# radicale

Custom Helm chart to deploy radicale

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.3.1](https://img.shields.io/badge/Version-0.3.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.8.1.1](https://img.shields.io/badge/AppVersion-3.8.1.1-informational?style=flat-square)

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
| configFile.dynamicValues.loggingSection | string | `"level = info"` | `[logging]`-Section |
| configFile.dynamicValues.rightsSection | string | `"type = owner_only"` | `[rights]`-Section |
| configFile.dynamicValues.serverSection | string | `"hosts: 0.0.0.0:5232"` | `[server]`-Section |
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
| ingressRoute.certResolver | string | `""` | Name of the Certificate Resolver to use to generate automatic TLS certificates. https://doc.traefik.io/traefik/reference/install-configuration/tls/certificate-resolvers/overview/ |
| ingressRoute.enabled | bool | `false` | Whether to enable the IngressRoute for radicale |
| ingressRoute.entryPoints | list | `[]` | Listening for Incoming Connections/Requests https://doc.traefik.io/traefik/reference/install-configuration/entrypoints/ |
| ingressRoute.routeMatch | string | `"Host(``)"` | Route-Match of the IngressRoute |

### Ingress/Middleware specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| middlewares | object | `{}` | Traefik Middlewares that should be used by the IngressRoute-rule. Gets ignored when `ingressRoute.enabled: false`. |

### radicale-Persistence specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access-Modes of the PVC |
| persistence.claimName | string | `""` | Name of the PVC |
| persistence.createPVC | bool | `true` | Whether to create a new PVC |
| persistence.emptyDirSizeLimit | string | `"1Gi"` | SizeLimit for emptyDir (used when persistence is disabled) |
| persistence.enabled | bool | `true` | Whether to enable persistence for collections-data (enables PVC). Otherwise local ephemeral storage is being used (emptyDir). |
| persistence.storageClassName | string | `""` | StorageClassName of the PVC |
| persistence.storageRequest | string | `"5Gi"` | storage-request for the PVC |

### radicale-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| radicaleContainer.env | list | `[{"name":"TAKE_FILE_OWNERSHIP","value":"false"}]` | Environment variables for the Container |
| radicaleContainer.extraVolumeMounts | list | `[]` | Additional Volume-Mounts for Container |
| radicaleContainer.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| radicaleContainer.image.repository | string | `"tomsquest/docker-radicale"` | Container-Image-Repository |
| radicaleContainer.image.tag | string | `""` | Container-Image-Tag (overrides `.Chart.AppVersion`) |
| radicaleContainer.livenessProbe | object | `{}` | Liveness-Probe |
| radicaleContainer.readinessProbe | object | `{}` | Readiness-Probe |
| radicaleContainer.resources | object | `{}` | Container Resources |
| radicaleContainer.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":2999,"runAsNonRoot":true,"runAsUser":2999}` | Container Security Context |
| radicaleContainer.startupProbe | object | `{}` | Startup-Probe |

### radicale-Container/ports/http specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| radicaleContainer.ports.http.containerPort | int | `5000` | Exposed Container-port |
| radicaleContainer.ports.http.name | string | `"http"` | Name of Container-port |

### radicale-Service specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.serviceName | string | `""` | Name of the NTFY-Service resource (overrides the default) |
| service.type | string | `"ClusterIP"` | Type of the NTFY-Service resource |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)