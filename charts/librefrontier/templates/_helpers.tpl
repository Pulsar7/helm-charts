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
{{- $container := .Values.librefrontierContainer -}}
{{- $containerImage := $container.image -}}
{{- $imageTag := default .Chart.AppVersion $containerImage.tag -}}
{{- printf "%s/%s:%s" $containerImage.registry $containerImage.repository $imageTag }}
{{- end }}

{{/*
Compile all warnings into a single message, and call fail.
See e.g.: https://github.com/bitnami/charts/blob/d9f6e8974fc9c8cbc64146e1632f70476529e720/bitnami/airflow/templates/_helpers.tpl#L434
*/}}
{{- define "librefrontier.validateValues" -}}
{{- $messages := list -}}
{{- $messages = append $messages (include "librefrontier.validateValues.httpAPIPort" .) -}}
{{- $messages = append $messages (include "librefrontier.validateValues.ingressRoutes" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end }}
{{- end }}

{{/*
Validate values for librefrontier - httpAPIPort

> Check whether a httpAPIPort is given to expose 
*/}}
{{- define "librefrontier.validateValues.httpAPIPort" -}}
{{- $messages := list -}}
{{- $librefrontierContainer := .Values.librefrontierContainer -}}
{{- if not $librefrontierContainer.ports.httpAPI.containerPort -}}
{{- $messages = append $messages "Missing required httpAPI-containerPort" -}}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n  > " $messages -}}
{{- if $message -}}
{{- printf " librefrontier: httpAPIPort\n  > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Validate values for librefrontier - ingressRoutes

> Check whether required IngressRoute-specifications are set
> Check whether the referenced Services exists (defined by this Helm chart)
> Check whether the referenced Middleware exists (defined by this Helm chart)
*/}}
{{- define "librefrontier.validateValues.ingressRoutes" -}}
{{- $messages := list -}}
{{- $ingressRoutes := .Values.ingressRoutes -}}
{{- $services := .Values.services -}}
{{- $middlewares := .Values.middlewares -}}
{{- $foundRefService := false -}}
{{- $foundRefMiddleware := false -}}
{{- range $ingressRoute := $ingressRoutes -}}
{{- $foundRefService = false -}}
{{- $foundRefMiddleware = false -}}
{{- if $ingressRoute.enabled -}}
{{- if not $ingressRoute.entryPoints -}}
{{- $messages = append $messages "Missing required `entryPoints`-Helm-Value. List cannot be empty." -}}
{{- end }}
{{- if not $ingressRoute.routeMatch -}}
{{- $messages = append $messages "Missing required `routeMatch`-Helm-Value." -}}
{{- end }}
{{- range $service := $services -}}
{{- if eq $service.serviceName $ingressRoute.refServiceName }}
{{- $foundRefService = true -}}
{{- break -}}
{{- end }}
{{- end }}
{{- if not $foundRefService -}}
{{- $messages = append $messages (printf "Referenced an invalid Service '%s' at IngressRoute '%s'" $ingressRoute.refServiceName $ingressRoute.name) -}}
{{- end }}
{{- range $refMiddlewareName := $ingressRoute.refMiddlewareNames -}}
{{- range $middleware := $middlewares -}}
{{- if eq $middleware.name $refMiddlewareName }}
{{- $foundRefMiddleware = true -}}
{{- break -}}
{{- end }}
{{- end }}
{{- if not $foundRefMiddleware -}}
{{- $messages = append $messages (printf "Referenced an invalid Middleware '%s' at IngressRoute '%s'" $refMiddlewareName $ingressRoute.name) -}}
{{- end }}
{{- end }}
{{- end }}
{{- end }}
{{- $messages := without $messages "" -}}
{{- $message := join "\n  > " $messages -}}
{{- if $message -}}
{{- printf " librefrontier: ingressRoutes\n  > %s" $message -}}
{{- end }}
{{- end }}

{{/*
Return whether a IngressRoute-resource should be created or not
*/}}
{{- define "librefrontier.createIngressRoute" -}}
{{- $ingressRoutes := .Values.ingressRoutes -}}
{{- range $ingressRoute := $ingressRoutes -}}
{{- if $ingressRoute.enabled -}}
true
{{- break -}}
{{- end }}
{{- end }}
{{- end }}

{{/*
Return whether a Middleware-resource should be created or not
*/}}
{{- define "librefrontier.createMiddleware" -}}
{{- $middlewares := .Values.middlewares -}}
{{- if and (include "librefrontier.createIngressRoute" .) $middlewares }}
true
{{- end }}
{{- end }}

{{/*
Return whether to create a default Secret-resource or not
*/}}
{{- define "librefrontier.createSecret" -}}
{{- $config := .Values.config }}
{{- $dbConnStringConfig := $config.databaseConnectionString -}}
{{- if not $dbConnStringConfig.existingSecret }}
true
{{- end }}
{{- end }}