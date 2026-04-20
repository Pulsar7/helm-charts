# ntfy

Custom Helm-Chart for NTFY

> [!IMPORTANT]
> Only configured for Traefik-Ingress, since **IngressRoute** is being used.

![Version: 0.1.5-alpha](https://img.shields.io/badge/Version-0.1.5--alpha-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.21.0](https://img.shields.io/badge/AppVersion-v2.21.0-informational?style=flat-square)

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
| configFiles.serverYAML.dynamicValues.additionalConfig | object | `{}` | Additional NTFY-YAML-Configuration that gets appended to the YAML-config. |
| configFiles.serverYAML.dynamicValues.attachments.cacheDir | string | `"/var/lib/ntfy"` | The cache directory for attached files |
| configFiles.serverYAML.dynamicValues.attachments.enabled | bool | `false` | Whether to enable attachments. `baseURL` and `attachments.cacheDir` has to be set! |
| configFiles.serverYAML.dynamicValues.attachments.expiryDuration | string | `"3h"` | The duration after which uploaded attachments will be deleted (e.g. 3h, 20h) |
| configFiles.serverYAML.dynamicValues.attachments.fileSizeLimit | string | `"15M"` | The per-file attachment size limit (e.g. 300k, 2M, 100M) |
| configFiles.serverYAML.dynamicValues.attachments.totalSizeLimit | string | `"5G"` | The limit of the on-disk attachment cache directory (total size) |
| configFiles.serverYAML.dynamicValues.authAccess | list | `[]` | auth-access (Secret is recommended instead) |
| configFiles.serverYAML.dynamicValues.authDefaultAccess | string | `"deny-all"` | auth-default-access |
| configFiles.serverYAML.dynamicValues.authFile | string | `"/var/lib/ntfy/user.db"` | auth-file |
| configFiles.serverYAML.dynamicValues.authTokens | list | `[]` | auth-tokens (Secret is recommended instead) |
| configFiles.serverYAML.dynamicValues.authUsers | list | `[]` | auth-users (Secret is recommended instead) |
| configFiles.serverYAML.dynamicValues.baseURL | string | `""` | Public facing base URL of the service |
| configFiles.serverYAML.dynamicValues.behindProxy | bool | `false` | Whether NTFY is behind a Proxy |
| configFiles.serverYAML.dynamicValues.cacheBatchSize | int | `0` | Allow enabling async batch writing of messages. If set, messages will be queued and written to the database in batches of the given size, or after the given timeout. This is only required for high volume servers. |
| configFiles.serverYAML.dynamicValues.cacheBatchTimeout | string | `"0ms"` | Allow enabling async batch writing of messages. If set, messages will be queued and written to the database in batches of the given size, or after the given timeout. This is only required for high volume servers. |
| configFiles.serverYAML.dynamicValues.cacheDuration | string | `"72h"` | Defines the duration for which messages will be buffered before they are deleted |
| configFiles.serverYAML.dynamicValues.cacheFile | string | `"/var/lib/ntfy/cache.db"` | Messages are cached in a local SQLite database instead of only in-memory |
| configFiles.serverYAML.dynamicValues.cacheStartupQueries | string | `""` | Allows to run commands when the database is initialized |
| configFiles.serverYAML.dynamicValues.disallowedTopics | list | `[]` | Topic names that are not allowed |
| configFiles.serverYAML.dynamicValues.enableLogin | bool | `false` | Whether to allow users to log in via the web app, or API |
| configFiles.serverYAML.dynamicValues.enableMetrics | bool | `false` | Whether to enable Prometheus-style metrics via a `/metrics` endpoint  or on a dedicated listen IP/port |
| configFiles.serverYAML.dynamicValues.enableReservations | bool | `false` | Whether to allow users to reserve topics (if their tier allows it) |
| configFiles.serverYAML.dynamicValues.enableSignup | bool | `false` | Whether to allow users to sign up via the web app, or API. `enableLogin` needs to be set when enabled. |
| configFiles.serverYAML.dynamicValues.logFile | string | `""` | Filename to write logs to. If this is not set, ntfy logs to stderr. |
| configFiles.serverYAML.dynamicValues.logFormat | string | `"json"` | Defines the output format, can be "text" (default) or "json" |
| configFiles.serverYAML.dynamicValues.logLevel | string | `"info"` | Defines the default log level |
| configFiles.serverYAML.dynamicValues.logLevelOverrides | list | `[]` | Log-level-overrides (for debugging, only use temporarily) |
| configFiles.serverYAML.dynamicValues.managerInterval | string | `"1m"` | Interval in which the manager prunes old messages, deletes topics and prints the stats |
| configFiles.serverYAML.dynamicValues.proxyForwardedHeader | string | `""` | Forwarded Proxy-Header (e.g. "X-Forwarded-For") |
| configFiles.serverYAML.dynamicValues.proxyTrustedHosts | string | `""` | A comma-separated list of IP addresses, hostnames or CIDRs that are removed from  the forwarded header to determine the real IP address (e.g. "1.2.3.4, 5.6.7.8") |
| configFiles.serverYAML.dynamicValues.rateLimits.globalTopicLimit | int | `15000` | Total number of topics before the server rejects new topics |
| configFiles.serverYAML.dynamicValues.rateLimits.messageDelayLimit | string | `"3d"` | The max delay of a message when using the "Delay" header |
| configFiles.serverYAML.dynamicValues.rateLimits.messageSizeLimit | string | `"4k"` | The max size of a message body |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorAttachmentDailyBandwidthLimit | string | `"500M"` | The total daily attachment download/upload traffic limit per visitor |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorAttachmentTotalSizeLimit | string | `"100M"` | The total storage limit used for attachments per visitor |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorMessageDailyLimit | int | `0` | Hard daily limit of messages per visitor and day. The limit is reset every day at midnight UTC. If the limit is not set (or set to zero), the request limit (see above) governs the upper limit. |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorRequestLimitBurst | int | `60` | The initial bucket of requests each visitor has |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorRequestLimitExemptHosts | string | `""` | A comma-separated list of hostnames, IPs or CIDRs to be exempt from request rate limiting. Hostnames are resolved at the time the server is started. Example: "1.2.3.4,ntfy.example.com,8.7.6.0/24" |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorRequestLimitReplenish | string | `"5s"` | The rate at which the bucket is refilled |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorSubscriberRateLimiting | bool | `false` | Whether to enable subscriber-based rate limiting (mostly used for UnifiedPush) |
| configFiles.serverYAML.dynamicValues.rateLimits.visitorSubscriptionLimit | int | `30` | Number of subscriptions per visitor (IP address) |
| configFiles.serverYAML.dynamicValues.requireLogin | bool | `false` | Whether to redirect users to the login page if they are not logged in (disallows web app access without login). `enableLogin` needs to be set when enabled. |
| configFiles.serverYAML.dynamicValues.webRoot | string | `"/"` | Defines the root path of the web app, or disables the web app entirely |
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
| containers.ntfy.image.tag | string | `"v2.21.0"` | Container-Image-Tag (by default `.Chart.AppVersion` will be used) |
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