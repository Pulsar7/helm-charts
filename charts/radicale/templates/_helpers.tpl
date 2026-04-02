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
{{- $messages := append $messages (include "radicale.validateValues.persistence" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of Radicale - PVC-specification has to be set when persistence in enabled
*/}}
{{- define "ntfy.validateValues.persistence" -}}
{{- $persistence := .Values.persistence -}}

{{- end -}}

{{/*
Create the Radicale-Container-Image-URL
*/}}
{{- define "radicale.containerImage" -}}
{{- $containerImage := .Values.containers.radicale.image -}}
{{- $imageTag := $containerImage.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" $containerImage.repository $imageTag }}
{{- end }}

{{/*
Create Secret-Name
*/}}
{{- define "radicale.secret" -}}
{{- $name := .Values.authentication.existingSecretName | default (include "radicale.fullname" .) -}}
{{- printf "%s" $name }}
{{- end }}

{{/*
Create IngressRoute-Name
*/}}
{{- define "radicale.ingressRoute" -}}
{{- printf "%s" (include "radicale.fullname" .) }}
{{- end }}

{{/*
Create ConfigMap-Name
*/}}
{{- define "radicale.configMap" -}}
{{- printf "%s" (include "radicale.fullname" .) }}
{{- end }}

{{/*
Create Service-Name
*/}}
{{- define "radicale.service" -}}
{{- printf "%s" (include "radicale.fullname" .) }}
{{- end }}

{{/*
Create PVC-Name for NTFY
*/}}
{{- define "radicale.pvc" -}}
{{- $claimName := .Values.persistence.claimName | default (include "radicale.fullname" .) -}}
{{- printf "%s" $claimName }}
{{- end -}}