{{/*
Validates the environment
*/}}
{{- define "global.environment" -}}
{{- $environment := lower .environment -}}
{{- $validEnvironments := list "dev" "staging" "production" -}}
{{- if mustHas $environment $validEnvironments -}}
    {{- printf "%s" $environment -}}
{{- else -}}
{{- fail (printf "Environment (%s) from .Values.global.environment is invalid. Valid environments are %s" $environment $validEnvironments) -}}
{{- end -}}
{{- end -}}

{{/*
Validates the role
*/}}
{{- define "application.role" -}}
{{- $role := lower .role -}}
{{- $validRoles := list "webapp" "worker" -}}
{{- if mustHas $role $validRoles -}}
    {{- printf "%s" $role -}}
{{- else -}}
{{- fail (printf "Role (%s) from .application.role is invalid. Valid roles are %s" $role $validRoles) -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aruba-uxi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create selector labels used by deployments and service.
*/}}
{{- define "aruba-uxi.selectorLabels" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end -}}

{{/*
Create labels used by most objects
*/}}
{{- define "aruba-uxi.labels" -}}
{{ include "aruba-uxi.selectorLabels" (dict "context" .context "name" .name) }}
helm.sh/chart: {{ include "aruba-uxi.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
repository: {{ .context.Values.global.repository }}
namespace: {{ .context.Release.Namespace }}
{{- if .context.Chart.AppVersion -}}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end -}}
{{- with .additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Create the name for sealed image pull secret
*/}}
{{- define "sealedImagePullSecret.name" -}}
{{- print "sealed-image-pull-secret" -}}
{{- end -}}

{{/*
Create labels specific fro sealed image pull secret object
*/}}
{{- define "sealedImagePullSecret.labels" -}}
app.kubernetes.io/name: {{ include "sealedImagePullSecret.name" "" }}
helm.sh/chart: {{ include "aruba-uxi.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
namespace: {{ .context.Release.Namespace }}
{{- end -}}

{{/*
Inject extra environment variables
*/}}
{{- define "aruba-uxi.env-variables" -}}
{{- $datadogImplementedEnvironmentVariables := list "DD_ENABLED" "DD_ENV" "DD_SERVICE" "DD_TRACE_ENABLED" -}}
{{- $sentryImplementedEnvironmentVariables := list "SENTRY_ENABLED" "SENTRY_ENVIRONMENT" -}}
{{- range $key, $val := .data }}
{{- if mustHas $key $datadogImplementedEnvironmentVariables -}}
{{- fail (printf "Env variable (%s) should not be defined in the env section. See the 'datadog' section in values.example.yaml for more info" $key) -}}
{{- end }}
{{- if mustHas $key $sentryImplementedEnvironmentVariables -}}
{{- fail (printf "Env variable (%s) should not be defined in the env section. See the 'sentry' section in values.example.yaml for more info" $key) -}}
{{- end }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end -}}

{{/*
Inject extra environment variables from fields
*/}}
{{- define "aruba-uxi.env-fields" -}}
{{- $datadogImplementedEnvironmentVariables := list "DD_AGENT_HOST" "DD_ENTITY_ID" -}}
{{- range $key, $val := .data }}
{{- if mustHas $key $datadogImplementedEnvironmentVariables -}}
{{- fail (printf "Env variable (%s) should not be defined in the envFields section. See the 'datadog' section in values.example.yaml for more info" $key) -}}
{{- end }}
- name: {{ $key }}
  valueFrom:
    fieldRef:
      fieldPath: {{ $val }}
{{- end }}
{{- end -}}

{{/*
Inject extra environment variables from secrets
*/}}
{{- define "aruba-uxi.env-sealed-secrets" -}}
{{- $sentryImplementedEnvironmentVariables := list "SENTRY_DSN" -}}
{{- range $secretName, $secretData := .data -}}
{{- range $envName := $secretData }}
{{- if mustHas $envName $sentryImplementedEnvironmentVariables -}}
{{- fail (printf "Env variable (%s) should not be defined in the envSealedSecret section. See the 'sentry' section in values.example.yaml for more info" $envName) -}}
{{- end }}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ $secretName }}
      key: {{ $envName }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Create the service account name
*/}}
{{- define "serviceAccount.name" -}}
{{- if .data.serviceAccount.create -}}
    {{ default .name .data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .data.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the image using respository and tag
*/}}
{{- define "aruba-uxi.image" -}}
{{- $globalTag := required "An image tag is required. Ensure it is defined in the values.yaml file at least" .context.Values.global.image.tag -}}
{{- $globalRepository := required "An image repository is required." .context.Values.global.image.repository -}}
{{- $repository := default $globalRepository .data.repository -}}
{{- $tag := default $globalTag .data.tag -}}
{{ printf "%s:%s" $repository $tag }}
{{- end -}}

{{/*
Create the image pull policy to use
*/}}
{{- define "aruba-uxi.imagePullPolicy" -}}
{{- $globalImagePullPolicy := default "IfNotPresent" .context.Values.global.image.pullPolicy -}}
{{ printf "%s" (default $globalImagePullPolicy .data.pullPolicy) }}
{{- end -}}

{{/*
Creates the Sentry DSN sealed secret name
*/}}
{{- define "sealedSentryDsn.name" -}}
{{- print "sentry-dsn" -}}
{{- end -}}

{{- define "sealedSentryDsn.labels" -}}
app.kubernetes.io/name: {{ include "sealedSentryDsn.name" "" }}
helm.sh/chart: {{ include "aruba-uxi.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
namespace: {{ .context.Release.Namespace }}
{{- end }}
