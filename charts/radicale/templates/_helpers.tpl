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
{{- $messages := append $messages (include "radicale.validateValues.ingressRoute" .) -}}
{{- $messages := append $messages (include "radicale.validateValues.middlewares" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
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
Validate values for radicale - ingressRoute
*/}}
{{- define "radicale.validateValues.ingressRoute" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- $ingressRoute := .Values.ingressRoute -}}
{{- if $ingressRoute.enabled -}}
{{- if not $ingressRoute.entryPoints -}}
{{- $messages = append $messages "Missing required `entryPoints`-Helm-Value. List cannot be empty." -}}
{{- end }}
{{- if not $ingressRoute.routeMatch -}}
{{- $messages = append $messages "Missing required `routeMatch`-Helm-Value." -}}
{{- end }}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n   > " $messages -}}
{{- if $message -}}
{{- printf " radicale: ingressRoute\n   > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Validate values for radicale - middlewares
*/}}
{{- define "radicale.validateValues.middlewares" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- $ingressRoute := .Values.ingressRoute -}}
{{- $middlewares := .Values.middlewares -}}
{{- if and $ingressRoute.enabled $middlewares -}}
{{- range $objName, $middleware := $middlewares -}}
{{- if not $middleware.name -}}
{{- $messages = append $messages (printf "Missing required `name`-Helm-Value for `%s`-middleware" $objName) -}}
{{- end -}}
{{- if not $middleware.spec -}}
{{- $messages = append $messages (printf "Missing required `spec`-Helm-Value for `%s`-middleware" $objName) -}}
{{- end -}}
{{- end -}}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n   > " $messages -}}
{{- if $message -}}
{{- printf " radicale: middlewares\n   > %s" $message -}}
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
Create IngressRoute-Name
*/}}
{{- define "radicale.ingressRouteName" -}}
{{- (include "radicale.fullname" .) }}
{{- end }}

{{/*
Create ConfigMap-Name
*/}}
{{- define "radicale.configMapName" -}}
{{- $configFile := .Values.configFile -}}
{{- default (include "radicale.fullname" .) $configFile.configMapName -}}
{{- end }}

{{/*
Create Service-Name
*/}}
{{- define "radicale.serviceName" -}}
{{- $service := .Values.service -}}
{{ default (include "radicale.fullname" .) $service.serviceName }}
{{- end }}

{{/*
Create PVC-Name for radicale
*/}}
{{- define "radicale.pvcName" -}}
{{- $claimName := .Values.persistence.claimName | default (include "radicale.fullname" .) -}}
{{- printf "%s" $claimName }}
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
