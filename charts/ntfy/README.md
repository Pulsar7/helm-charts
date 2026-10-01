# ntfy

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.26.0](https://img.shields.io/badge/AppVersion-v2.26.0-informational?style=flat-square)

Helm chart to deploy ntfy

## Values

### Pod specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity expand the types of constraints you can define |
| extraVolumes | object | `{}` | Additional Volumes |
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
| authentication.authAccess.defaultSecretValue | string | `"test-user:TestTopic:rw"` | Default Secret-Value. ignored when `authTokens.useExistingSecret: true` |
| authentication.authAccess.secretKey | string | `"auth-access"` | Secret-Key Name for Authentication-Access |
| authentication.authAccess.secretName | string | `""` | Name of the Secret for Authentication-Access. |
| authentication.authAccess.useExistingSecret | bool | `false` | Whether to use an existing Secret or not |
| authentication.authTokens.defaultSecretValue | string | `"test-user:tk_84t6qy4qxadevc37jbqty4q8xlpzl:Test-Token for Test-User"` | Default Secret-Value. ignored when `authTokens.useExistingSecret: true` |
| authentication.authTokens.secretKey | string | `"auth-tokens"` | Secret-Key Name for Authentication-Tokens |
| authentication.authTokens.secretName | string | `""` | Name of the Secret for Authentication-Tokens. |
| authentication.authTokens.useExistingSecret | bool | `false` | Whether to use an existing Secret or not |
| authentication.authUsers.defaultSecretValue | string | `"test-admin:$2a$10$1Y//CVdFIQRYNfIITwqZDeqnh0bFSM/Bhxjis5gKItcgU0UrSNWAa:admin,test-user:$2a$10$1Y//CVdFIQRYNfIITwqZDeqnh0bFSM/Bhxjis5gKItcgU0UrSNWAa:user"` | Default Secret-Value. ignored when `authTokens.useExistingSecret: true` |
| authentication.authUsers.secretKey | string | `"auth-users"` | Secret-Key Name for Authentication-Users |
| authentication.authUsers.secretName | string | `""` | Name of the Secret for Authentication-Users. |
| authentication.authUsers.useExistingSecret | bool | `false` | Whether to use an existing Secret or not |

### Additional sidecar-Containers

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraContainers | list | `[]` | List of sidecar-Containers |

### Additional init-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| extraInitContainers | list | `[]` | List of additional init-Containers |

### NTFY-Container specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ntfyContainer.extraArgs | list | `[]` | Additional Container-arguments |
| ntfyContainer.extraEnvs | list | `[]` | Additional environment-Variables |
| ntfyContainer.extraVolumeMounts | list | `[]` | Additional VolumeMounts |
| ntfyContainer.image.pullPolicy | string | `"IfNotPresent"` | Container-Image pull-policy |
| ntfyContainer.image.registry | string | `"docker.io"` | Container-Image registry |
| ntfyContainer.image.repository | string | `"binwiederhier/ntfy"` | Container-Image repository |
| ntfyContainer.image.tag | string | `""` | Container-Image-Tag (overrides `.Chart.AppVersion`) |
| ntfyContainer.livenessProbe | object | `{}` | Liveness-Probe |
| ntfyContainer.readinessProbe | object | `{}` | Readiness-Probe |
| ntfyContainer.resources | object | `{}` | Container Resources |
| ntfyContainer.securityContext | object | `{"allowPrivilegeEscalation":false,"privileged":false,"runAsGroup":10000,"runAsNonRoot":true,"runAsUser":10000}` | Container Security Context |
| ntfyContainer.startupProbe | object | `{}` | Startup-Probe |

### NTFY-Service specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ntfyContainer.service.serviceName | string | `"ntfy-http"` | Name of the NTFY-Service resource |
| ntfyContainer.service.type | string | `"ClusterIP"` | Type of the NTFY-Service resource |

### NTFY-Persistence specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.emptyDir | object | `{"sizeLimit":"1Gi"}` | EmptyDir-Object that is being used when persistence is disabled. |
| persistence.enabled | bool | `true` | Whether to enable persistence for 'cache.db' and 'user.db' (enables PVC) Otherwise an emptyDir gets used the the databases. |
| persistence.persistentVolumeClaim.accessModes | list | `["ReadWriteOnce"]` | Access-Modes of the PVC. ignored when `useExistingPVC: false` |
| persistence.persistentVolumeClaim.claimName | string | `""` | Name of the PVC |
| persistence.persistentVolumeClaim.extraSpecs | object | `{}` | additional specs for the PVC. ignored when `useExistingPVC: false` |
| persistence.persistentVolumeClaim.storageClassName | string | `""` | StorageClassName of the PVC. ignored when `useExistingPVC: false` |
| persistence.persistentVolumeClaim.storageRequest | string | `"5Gi"` | `resources.storage.request` for the PVC. ignored when `useExistingPVC: false` |
| persistence.persistentVolumeClaim.useExistingPVC | bool | `false` | Whether to use an existing PersistentVolumeClaim or not. |

### Server-Config specifications

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serverConfig.configMapItemKey | string | `"server.yaml"` | Key to the ConfigMap-item |
| serverConfig.configMapName | string | `""` | Name of the ConfigMap |
| serverConfig.dynamicValues.attachments.cacheDir | string | `"/var/lib/ntfy"` | The cache directory for attached files |
| serverConfig.dynamicValues.attachments.enabled | bool | `false` | Whether to enable attachments. `baseURL` and `attachments.cacheDir` has to be set! |
| serverConfig.dynamicValues.attachments.expiryDuration | string | `"3h"` | The duration after which uploaded attachments will be deleted (e.g. 3h, 20h) |
| serverConfig.dynamicValues.attachments.fileSizeLimit | string | `"15M"` | The per-file attachment size limit (e.g. 300k, 2M, 100M) |
| serverConfig.dynamicValues.attachments.totalSizeLimit | string | `"5G"` | The limit of the on-disk attachment cache directory (total size) |
| serverConfig.dynamicValues.authAccess | list | `[]` | auth-access (Secret is recommended instead) |
| serverConfig.dynamicValues.authDefaultAccess | string | `"deny-all"` | auth-default-access |
| serverConfig.dynamicValues.authFile | string | `"/var/lib/ntfy/user.db"` | auth-file |
| serverConfig.dynamicValues.authTokens | list | `[]` | auth-tokens (Secret is recommended instead) |
| serverConfig.dynamicValues.authUsers | list | `[]` | auth-users (Secret is recommended instead) |
| serverConfig.dynamicValues.baseURL | string | `""` | Public facing base URL of the service |
| serverConfig.dynamicValues.behindProxy | bool | `false` | Whether NTFY is behind a Proxy |
| serverConfig.dynamicValues.cacheBatchSize | int | `0` | Allow enabling async batch writing of messages. If set, messages will be queued and written to the database in batches of the given size, or after the given timeout. This is only required for high volume servers. |
| serverConfig.dynamicValues.cacheBatchTimeout | string | `"0ms"` | Allow enabling async batch writing of messages. If set, messages will be queued and written to the database in batches of the given size, or after the given timeout. This is only required for high volume servers. |
| serverConfig.dynamicValues.cacheDuration | string | `"72h"` | Defines the duration for which messages will be buffered before they are deleted |
| serverConfig.dynamicValues.cacheFile | string | `"/var/lib/ntfy/cache.db"` | Messages are cached in a local SQLite database instead of only in-memory |
| serverConfig.dynamicValues.cacheStartupQueries | string | `""` | Allows to run commands when the database is initialized |
| serverConfig.dynamicValues.disallowedTopics | list | `[]` | Topic names that are not allowed |
| serverConfig.dynamicValues.enableLogin | bool | `false` | Whether to allow users to log in via the web app, or API |
| serverConfig.dynamicValues.enableMetrics | bool | `false` | Whether to enable Prometheus-style metrics via a `/metrics` endpoint  or on a dedicated listen IP/port |
| serverConfig.dynamicValues.enableReservations | bool | `false` | Whether to allow users to reserve topics (if their tier allows it) |
| serverConfig.dynamicValues.enableSignup | bool | `false` | Whether to allow users to sign up via the web app, or API. `enableLogin` needs to be set when enabled. |
| serverConfig.dynamicValues.extraConfig | string | `""` | Append additional lines to the server-config-file |
| serverConfig.dynamicValues.logFile | string | `""` | Filename to write logs to. If this is not set, ntfy logs to stderr. |
| serverConfig.dynamicValues.logFormat | string | `"json"` | Defines the output format, can be "text" (default) or "json" |
| serverConfig.dynamicValues.logLevel | string | `"info"` | Defines the default log level |
| serverConfig.dynamicValues.logLevelOverrides | list | `[]` | Log-level-overrides (for debugging, only use temporarily) |
| serverConfig.dynamicValues.managerInterval | string | `"1m"` | Interval in which the manager prunes old messages, deletes topics and prints the stats |
| serverConfig.dynamicValues.proxyForwardedHeader | string | `""` | Forwarded Proxy-Header (e.g. "X-Forwarded-For") |
| serverConfig.dynamicValues.proxyTrustedHosts | string | `""` | A comma-separated list of IP addresses, hostnames or CIDRs that are removed from  the forwarded header to determine the real IP address (e.g. "1.2.3.4, 5.6.7.8") |
| serverConfig.dynamicValues.rateLimits.globalTopicLimit | int | `15000` | Total number of topics before the server rejects new topics |
| serverConfig.dynamicValues.rateLimits.messageDelayLimit | string | `"3d"` | The max delay of a message when using the "Delay" header |
| serverConfig.dynamicValues.rateLimits.messageSizeLimit | string | `"4k"` | The max size of a message body |
| serverConfig.dynamicValues.rateLimits.visitorAttachmentDailyBandwidthLimit | string | `"500M"` | The total daily attachment download/upload traffic limit per visitor |
| serverConfig.dynamicValues.rateLimits.visitorAttachmentTotalSizeLimit | string | `"100M"` | The total storage limit used for attachments per visitor |
| serverConfig.dynamicValues.rateLimits.visitorMessageDailyLimit | int | `0` | Hard daily limit of messages per visitor and day. The limit is reset every day at midnight UTC. If the limit is not set (or set to zero), the request limit (see above) governs the upper limit. |
| serverConfig.dynamicValues.rateLimits.visitorRequestLimitBurst | int | `60` | The initial bucket of requests each visitor has |
| serverConfig.dynamicValues.rateLimits.visitorRequestLimitExemptHosts | string | `""` | A comma-separated list of hostnames, IPs or CIDRs to be exempt from request rate limiting. Hostnames are resolved at the time the server is started. Example: "1.2.3.4,ntfy.example.com,8.7.6.0/24" |
| serverConfig.dynamicValues.rateLimits.visitorRequestLimitReplenish | string | `"5s"` | The rate at which the bucket is refilled |
| serverConfig.dynamicValues.rateLimits.visitorSubscriberRateLimiting | bool | `false` | Whether to enable subscriber-based rate limiting (mostly used for UnifiedPush) |
| serverConfig.dynamicValues.rateLimits.visitorSubscriptionLimit | int | `30` | Number of subscriptions per visitor (IP address) |
| serverConfig.dynamicValues.requireLogin | bool | `false` | Whether to redirect users to the login page if they are not logged in (disallows web app access without login). `enableLogin` needs to be set when enabled. |
| serverConfig.dynamicValues.webRoot | string | `"/"` | Defines the root path of the web app, or disables the web app entirely |
| serverConfig.useExistingConfigMap | bool | `false` | Whether to use an existing ConfigMap instead of creating one. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
