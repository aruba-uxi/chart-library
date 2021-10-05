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
{{- define "asimmetric.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create selector labels used by deployments and service.
*/}}
{{- define "asimmetric.selectorLabels" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end -}}

{{/*
Create labels used by most objects
*/}}
{{- define "asimmetric.labels" -}}
{{ include "asimmetric.selectorLabels" (dict "context" .context "name" .name) }}
helm.sh/chart: {{ include "asimmetric.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
repository: {{ .context.Values.global.repository }}
namespace: {{ .context.Release.Namespace }}
{{- if .context.Chart.AppVersion -}}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end -}}
{{- end -}}

{{/*
Create the name for sealed secrets
*/}}
{{- define "sealedSecret.name" -}}
{{- printf "%s-%s" .name .secretName -}}
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
helm.sh/chart: {{ include "asimmetric.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
namespace: {{ .context.Release.Namespace }}
{{- end -}}

{{/*
Inject extra environment variables
*/}}
{{- define "asimmetric.env-variables" -}}
{{- range $key, $val := .data }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end -}}

{{/*
Inject extra environment variables from fields
*/}}
{{- define "asimmetric.env-fields" -}}
{{- range $key, $val := .data }}
- name: {{ $key }}
  valueFrom:
    fieldRef:
      fieldPath: {{ $val }}
{{- end }}
{{- end -}}

{{/*
Inject extra environment variables from secrets
*/}}
{{- define "asimmetric.env-sealed-secrets" -}}
{{- range $secretName, $secretData := .data -}}
{{- range $envName := $secretData }}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ include "sealedSecret.name" (dict "name" $.name "secretName" $secretName) }}
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
{{- define "asimmetric.image" -}}
{{- $repository := default .context.Values.global.image.repository .data.repository -}}
{{- $globalTag := default "latest" .context.Values.global.image.tag -}}
{{- $tag := default $globalTag .data.tag -}}
{{ printf "%s:%s" $repository $tag }}
{{- end -}}

{{/*
Create the image pull policy to use
*/}}
{{- define "asimmetric.imagePullPolicy" -}}
{{- $globalImagePullPolicy := default "IfNotPresent" .context.Values.global.image.pullPolicy -}}
{{ printf "%s" (default $globalImagePullPolicy .data.pullPolicy) }}
{{- end -}}
