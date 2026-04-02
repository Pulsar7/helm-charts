{{/*
Expand the name of the chart.
*/}}
{{- define "ntfy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ntfy.fullname" -}}
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
{{- define "ntfy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ntfy.labels" -}}
helm.sh/chart: {{ include "ntfy.chart" . }}
{{ include "ntfy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ntfy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ntfy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the NTFY-Container-Image-URL
*/}}
{{- define "ntfy.containerImage" -}}
{{- $containerImage := .Values.containers.ntfy.image -}}
{{- $imageTag := $containerImage.tag | default .Chart.AppVersion -}}
{{- printf "%s:%s" $containerImage.repository $imageTag }}
{{- end }}

{{/*
Create Authentication-Tokens Secret-Name
*/}}
{{- define "ntfy.authTokensSecretName" -}}
{{- $authentication := .Values.authentication -}}
{{- $authTokensSecretName := $authentication.authTokens.existingSecretName | default (include "ntfy.fullname" .) -}}
{{- printf "%s" $authTokensSecretName }}
{{- end }}

{{/*
Create Authentication-Users Secret-Name
*/}}
{{- define "ntfy.authUsersSecretName" -}}
{{- $authentication := .Values.authentication -}}
{{- $authUsersSecretName := $authentication.authUsers.existingSecretName | default (include "ntfy.fullname" .) -}}
{{- printf "%s" $authUsersSecretName }}
{{- end }}

{{/*
Create PVC-Name for NTFY
*/}}
{{- define "ntfy.pvc" -}}
{{- $claimName := .Values.persistence.claimName | default (include "ntfy.fullname" .) -}}
{{- printf "%s" $claimName }}
{{- end -}}

{{/*
Create Authentication-Access Secret-Name
*/}}
{{- define "ntfy.authAccessSecretName" -}}
{{- $authentication := .Values.authentication -}}
{{- $authAccessSecretName := $authentication.authAccess.existingSecretName | default (include "ntfy.fullname" .) -}}
{{- printf "%s" $authAccessSecretName }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
See e.g.: https://github.com/bitnami/charts/blob/d9f6e8974fc9c8cbc64146e1632f70476529e720/bitnami/airflow/templates/_helpers.tpl#L434
*/}}
{{- define "ntfy.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "ntfy.validateValues.persistence" .) -}}
{{- $messages := append $messages (include "ntfy.validateValues.authentication" .) -}}
{{- $messages := append $messages (include "ntfy.validateValues.containers" .) -}}
{{- $messages := append $messages (include "ntfy.validateValues.configFiles.serverYAML" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Validate values of NTFY - PVC-specification has to be set when persistence in enabled
*/}}
{{- define "ntfy.validateValues.persistence" -}}
{{- $persistence := .Values.persistence -}}

{{- end -}}

{{/*
Validate values of NTFY - Authentication
*/}}
{{- define "ntfy.validateValues.authentication" -}}
{{- $auth := .Values.authentication -}}

{{- end -}}

{{/*
Validate values of NTFY - Containers
*/}}
{{- define "ntfy.validateValues.containers" -}}
{{- $containers := .Values.containers -}}

{{- end -}}

{{/*
Validate values of NTFY - PVC-specification has to be set when persistence in enabled
*/}}
{{- define "ntfy.validateValues.configFiles.serverYAML" -}}
{{- $conf := .Values.configFiles.serverYAML.dynamicValues -}}
{{/* `enableLogin` needs to be set when `enableSignup` enabled */}}
{{- if and $conf.enableSignup (not $conf.enableLogin) -}}
ntfy: configFiles.serverYAML
    `enableLogin` has to be enabled too when `enableSignup` is enabled
{{/* `enableLogin` needs to be set when `requireLogin` enabled */}}
{{- else if and $conf.requireLogin (not $conf.enableLogin) -}}
ntfy: configFiles.serverYAML
    `enableLogin` has to be enabled too when `requireLogin` is enabled
{{- end -}}
{{- end -}}