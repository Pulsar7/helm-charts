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
Create the name of the service account to use
*/}}
{{- define "ntfy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ntfy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create boolean whether to create the ConfigMap-resource or not.
*/}}
{{- define "ntfy.createConfigMap" -}}
{{- $serverConfig := .Values.serverConfig -}}
{{- if not $serverConfig.useExistingConfigMap -}}
true
{{- end }}
{{- end }}

{{/*
Create boolean whether to create the ConfigMap-resource or not.
*/}}
{{- define "ntfy.createSecret" -}}
{{- $authentication := .Values.authentication -}}
{{- $authTokens := $authentication.authTokens -}}
{{- $authUsers := $authentication.authUsers -}}
{{- $authAccess := $authentication.authAccess -}}
{{- if or (not $authTokens.useExistingSecret) (not $authUsers.useExistingSecret) (not $authAccess.useExistingSecret) -}}
true
{{- end }}
{{- end }}

{{/*
Create boolean whether to create the PVC-resource or not.
*/}}
{{- define "ntfy.createPersistentVolumeClaim" -}}
{{- $persistence := .Values.persistence -}}
{{- $pvc := $persistence.persistentVolumeClaim -}}
{{- if and $persistence.enabled (not $pvc.useExistingPVC) -}}
true
{{- end }}
{{- end }}

{{/*
Create name of configMap
*/}}
{{- define "ntfy.configMapName" -}}
{{- $serverConfig := .Values.serverConfig -}}
{{- default (include "ntfy.fullname" .) $serverConfig.configMapName }}
{{- end }}

{{/*
Create name of PersistentVolumeClaim
*/}}
{{- define "ntfy.persistentVolumeClaimName" -}}
{{- $persistencePVC := .Values.persistence.persistentVolumeClaim -}}
{{- default (printf "%s-data" (include "ntfy.fullname" .)) $persistencePVC.claimName }}
{{- end }}

{{/*
Create NTFY-Container Image URL
*/}}
{{- define "ntfy.containerImage" -}}
{{- $ntfyContainerImage := .Values.ntfyContainer.image -}}
{{- $containerImageTag := default .Chart.AppVersion $ntfyContainerImage.tag -}}
{{- printf "%s/%s:%s" $ntfyContainerImage.registry $ntfyContainerImage.repository $containerImageTag -}}
{{- end }}

{{/*
Create Secret-Name for authTokens
*/}}
{{- define "ntfy.secretName.authTokens" -}}
{{- $authentication := .Values.authentication -}}
{{- $authTokens := $authentication.authTokens -}}
{{- default (printf "%s-auth-tokens" (include "ntfy.fullname" .)) $authTokens.secretName }}
{{- end }}

{{/*
Create Secret-Name for authUsers
*/}}
{{- define "ntfy.secretName.authUsers" -}}
{{- $authentication := .Values.authentication -}}
{{- $authUsers := $authentication.authUsers -}}
{{- default (printf "%s-auth-users" (include "ntfy.fullname" .)) $authUsers.secretName }}
{{- end }}

{{/*
Create Secret-Name for authAccess
*/}}
{{- define "ntfy.secretName.authAccess" -}}
{{- $authentication := .Values.authentication -}}
{{- $authAccess := $authentication.authAccess -}}
{{- default (printf "%s-auth-access" (include "ntfy.fullname" .)) $authAccess.secretName }}
{{- end }}

{{/*
Create list of Secret-Names

Using `$` as context when calling the `include`-function 
to ensure using the root-context instead of the current `range`-context.
*/}}
{{- define "ntfy.secretNames" -}}
{{- $secretItems := list "authTokens" "authUsers" "authAccess" -}}
{{- $secretNames := list -}}
{{- range $secretItems }}
{{- $funcName := (printf "ntfy.secretName.%s" .) -}}
{{- $secretNames = append $secretNames (include $funcName $) -}}
{{- end }}
{{- $secretNames | toJson -}}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
See e.g.: https://github.com/bitnami/charts/blob/d9f6e8974fc9c8cbc64146e1632f70476529e720/bitnami/airflow/templates/_helpers.tpl#L434
*/}}
{{- define "ntfy.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "ntfy.validateValues.configFile.serverConfig" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end }}
{{- end }}

{{/*
Validate values of ntfy - configFile.serverConfig
*/}}
{{- define "ntfy.validateValues.configFile.serverConfig" -}}
{{- $messages := list -}}
{{- $message := "" -}}
{{- $config := .Values.serverConfig -}}

{{- $messages := without $messages "" -}}
{{- $message := join "\n  > " $messages -}}
{{- if $message -}}
{{- printf " ntfy: serverConfig\n   > %s" $message -}}
{{- end }}
{{- end }}