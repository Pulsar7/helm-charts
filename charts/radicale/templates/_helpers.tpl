{{/*
Expand the name of the chart.
*/}}
{{- define "radicale.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "radicale.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "radicale.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "radicale.labels" -}}
helm.sh/chart: {{ include "radicale.chart" . }}
{{ include "radicale.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "radicale.selectorLabels" -}}
app.kubernetes.io/name: {{ include "radicale.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "radicale.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "radicale.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
See e.g.: https://github.com/bitnami/charts/blob/d9f6e8974fc9c8cbc64146e1632f70476529e720/bitnami/airflow/templates/_helpers.tpl#L434
*/}}
{{- define "radicale.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "radicale.validateValues.configFile" .) -}}
{{- $messages := append $messages (include "radicale.validateValues.ingressRoutes" .) -}}
{{- $messages := append $messages (include "radicale.validateValues.middlewares" .) -}}
{{- $messages := append $messages (include "radicale.validateValues.exposedRadicaleContainerPorts" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end }}
{{- end }}

{{/*
Validate values of radicale - configFile
*/}}
{{- define "radicale.validateValues.configFile" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- $config := .Values.configFile -}}
{{- if and $config.useExistingConfigMap (not $config.configMapName) }}
{{- $messages = append $messages "Missing required `configMapName` when `useExistingConfigMap: true`" -}}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n   > " $messages -}}
{{- if $message -}}
{{- printf " radicale: configFile\n   > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Validate values of radicale - IngressRoutes

> Checks whether the required IngressRoute-fields are given:

  * name
  * entryPoints
  * routeMatch

And for extra-IngressRoutes additionally:

  * refServiceName
  * refServicePortNumber
*/}}
{{- define "radicale.validateValues.ingressRoutes" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- if (include "radicale.createIngressRoute" .) -}}
{{- $httpIngressRoute := .Values.httpIngressRoute -}}
{{- $extraIngressRoutes := .Values.extraIngressRoutes -}}
{{- if $httpIngressRoute.enabled -}}
{{- if not $httpIngressRoute.name -}}
{{- $messages = append $messages "Missing required `name` when `httpIngressRoute: true`" -}}
{{- end }}
{{- if not $httpIngressRoute.entryPoints -}}
{{- $messages = append $messages "Missing required `entryPoints` when `httpIngressRoute: true`" -}}
{{- end }}
{{- if not $httpIngressRoute.routeMatch -}}
{{- $messages = append $messages "Missing required `routeMatch` when `httpIngressRoute: true`" -}}
{{- end }}
{{- end }}
{{- if $extraIngressRoutes -}}
{{- range $objName, $extraIngressRoute := $extraIngressRoutes -}}
{{- if not $extraIngressRoute.name -}}
{{- $messages = append $messages (printf "Missing required `name` for the extra-IngressRoute `%s`" $objName) -}}
{{- end }}
{{- if not $extraIngressRoute.entryPoints -}}
{{- $messages = append $messages (printf "Missing required `entryPoints` for the extra-IngressRoute `%s`" $objName) -}}
{{- end }}
{{- if not $extraIngressRoute.routeMatch -}}
{{- $messages = append $messages (printf "Missing required `routeMatch` for the extra-IngressRoute `%s`" $objName) -}}
{{- end }}
{{- if not $extraIngressRoute.refServiceName -}}
{{- $messages = append $messages (printf "Missing required `refServiceName` for the extra-IngressRoute `%s`" $objName) -}}
{{- end }}
{{- if not $extraIngressRoute.refServicePortNumber -}}
{{- $messages = append $messages (printf "Missing required `refServicePortNumber` for the extra-IngressRoute `%s`" $objName) -}}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n   > " $messages -}}
{{- if $message -}}
{{- printf " radicale: ingressRoutes\n   > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Validate values for radicale - middlewares
*/}}
{{- define "radicale.validateValues.middlewares" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- $middlewares := .Values.middlewares -}}
{{- if and (include "radicale.createIngressRoute" .) $middlewares -}}
{{- range $objName, $middleware := $middlewares -}}
{{- if not $middleware.name -}}
{{- $messages = append $messages (printf "Missing required `name`-Helm-Value for `%s`-middleware" $objName) -}}
{{- end }}
{{- if not $middleware.spec -}}
{{- $messages = append $messages (printf "Missing required `spec`-Helm-Value for `%s`-middleware" $objName) -}}
{{- end }}
{{- end }}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n   > " $messages -}}
{{- if $message -}}
{{- printf " radicale: middlewares\n   > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Validate values of radicale - exposed radicaleContainer-ports
*/}}
{{- define "radicale.validateValues.exposedRadicaleContainerPorts" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- $radicaleContainer := .Values.radicaleContainer -}}
{{- $httpPort := $radicaleContainer.httpPort -}}
{{- $extraPorts := $radicaleContainer.extraPorts -}}
{{- if not $httpPort.name -}}
{{- $messages = append $messages "Missing required `name`-field for the `radicaleContainer.httpPort`" -}}
{{- end }}
{{- if not $httpPort.containerPort -}}
{{- $messages = append $messages "Missing required `containerPort`-field for the `radicaleContainer.httpPort`" -}}
{{- end }}
{{- if $extraPorts -}}
{{- range $objName, $extraPort := $extraPorts -}}
{{- if not $extraPort.name -}}
{{- $messages = append $messages (printf "Missing `name`-field for the `radicaleContainer.extraPorts.%s`" $objName) -}}
{{- end }}
{{- if not $extraPort.containerPort -}}
{{- $messages = append $messages (printf "Missing `containerPort`-field for the `radicaleContainer.extraPorts.%s`" $objName) -}}
{{- end }}
{{- end }}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n   > " $messages -}}
{{- if $message -}}
{{- printf " radicale: exposedRadicaleContainerPorts\n   > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Create the radicale-Container-Image-URL
*/}}
{{- define "radicale.containerImage" -}}
{{- $containerImage := .Values.radicaleContainer.image -}}
{{- $imageTag := $containerImage.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" $containerImage.repository $imageTag }}
{{- end }}

{{/*
Create Secret-Name
*/}}
{{- define "radicale.secretName" -}}
{{- $authentication := .Values.authentication -}}
{{- default (include "radicale.fullname" .) $authentication.secretName -}}
{{- end }}

{{/*
Create ConfigMap-Name
*/}}
{{- define "radicale.configMapName" -}}
{{- $configFile := .Values.configFile -}}
{{- default (include "radicale.fullname" .) $configFile.configMapName -}}
{{- end }}

{{/*
Create PVC-Name for radicale
*/}}
{{- define "radicale.pvcName" -}}
{{- $claimName := default (include "radicale.fullname" .) .Values.persistence.claimName -}}
{{- printf "%s" $claimName }}
{{- end }}

{{/*
Create boolean whether the a IngressRoute-Resource needs to be created or not
*/}}
{{- define "radicale.createIngressRoute" -}}
{{- $httpIngressRoute := .Values.httpIngressRoute -}}
{{- $extraIngressRoutes := .Values.extraIngressRoutes -}}
{{- if or $httpIngressRoute.enabled $extraIngressRoutes -}}
true
{{- end }}
{{- end }}

{{/*
Create boolean whether the a Middleware-Resource needs to be created or not
*/}}
{{- define "radicale.createMiddleware" -}}
{{- $middlewares := .Values.middlewares -}}
{{- if and $middlewares (include "radicale.createIngressRoute" .) -}}
true
{{- end }}
{{- end }}

{{/*
Create boolean whether the a ConfigMap-Resource needs to be created or not
*/}}
{{- define "radicale.createConfigMap" -}}
{{- $configFile := .Values.configFile -}}
{{- if not $configFile.useExistingConfigMap -}}
true
{{- end }}
{{- end }}

{{/*
Create boolean whether the PersistentVolumeClaim needs to be created or not
*/}}
{{- define "radicale.createPVC" -}}
{{- $persistence := .Values.persistence -}}
{{- if and $persistence.enabled $persistence.createPVC -}}
true
{{- end }}
{{- end }}

{{/*
Create boolean whether the Secret needs to be created or not
*/}}
{{- define "radicale.createSecret" -}}
{{- $authentication := .Values.authentication -}}
{{- if not $authentication.useExistingSecret -}}
true
{{- end }}
{{- end }}
