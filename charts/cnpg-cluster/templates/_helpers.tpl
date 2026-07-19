{{/*
Expand the name of the chart.
*/}}
{{- define "cnpgdb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cnpgdb.fullname" -}}
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
{{- define "cnpgdb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cnpgdb.labels" -}}
helm.sh/chart: {{ include "cnpgdb.chart" . }}
{{ include "cnpgdb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cnpgdb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cnpgdb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
See e.g.: https://github.com/bitnami/charts/blob/d9f6e8974fc9c8cbc64146e1632f70476529e720/bitnami/airflow/templates/_helpers.tpl#L434
*/}}
{{- define "cnpgdb.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "cnpgdb.validateValues.superUserAccess" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of cnpgdb - superUserAccess

> Whether `enableSuperuserAccess: true` when backup is enabled
> Whether `cnpgSuperUserSecretName` is set when `enableSuperuserAccess: true`
*/}}
{{- define "cnpgdb.validateValues.superUserAccess" -}}
{{- $postgres := .Values.postgresCluster -}}
{{- $backup := .Values.backupCronjob -}}
{{- if and $backup.enabled (not $postgres.enableSuperuserAccess) -}}
cnpgdb: enableSuperuserAccess
    You have to enable external superUserAccess when enabling Backups
{{- end -}}
{{- if and $postgres.enableSuperuserAccess (not $postgres.cnpgSuperUserSecretName) -}}
cnpgdb: cnpgSuperUserSecretName
    You have to provide a superUserAccess-Name when enabling superUserAccess
{{- end -}}
{{- end -}}