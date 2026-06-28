{{/*
Expand the name of the chart.
*/}}
{{- define "librefrontier.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "librefrontier.fullname" -}}
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
{{- define "librefrontier.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "librefrontier.labels" -}}
helm.sh/chart: {{ include "librefrontier.chart" . }}
{{ include "librefrontier.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "librefrontier.selectorLabels" -}}
app.kubernetes.io/name: {{ include "librefrontier.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the Librefrontier-Container-Image-URL
*/}}
{{- define "librefrontier.containerImage" -}}
{{- $containerImage := .Values.containers.librefrontier.image -}}
{{- $imageTag := $containerImage.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" $containerImage.repository $imageTag }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
See e.g.: https://github.com/bitnami/charts/blob/d9f6e8974fc9c8cbc64146e1632f70476529e720/bitnami/airflow/templates/_helpers.tpl#L434
*/}}
{{- define "librefrontier.validateValues" -}}
{{- $messages := list -}}
{{/*{{- $messages := append $messages (include "librefrontier.validateValues." .) -}}*/}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Create service-name for the http-API-Service.
*/}}
{{- define "librefrontier.serviceName.httpAPI" -}}
{{- printf "%s-http-api" (include "librefrontier.fullname" .) }}
{{- end }}

{{/*
Create service-name for the web-UI-Service.
*/}}
{{- define "librefrontier.serviceName.webUI" -}}
{{- printf "%s-web-ui" (include "librefrontier.fullname" .) }}
{{- end }}

{{/*
Create database-connection-string SecretName.
*/}}
{{- define "librefrontier.databaseConnectionString.secretName" -}}
{{- $secretName := .Values.librefrontierConfig.databaseConnectionString.secretName -}}
{{- printf "%s" $secretName }}
{{- end }}
