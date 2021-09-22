{{/*
Expand the name of the chart.
*/}}
{{- define "webapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "webapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webapp.labels" -}}
helm.sh/chart: {{ include "webapp.chart" .context }}
{{ include "webapp.selectorLabels" (dict "context" .context "name" .name) }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app: {{ .name }}
repository: {{ .context.Values.global.labels.repo }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webapp.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end }}


{{/*
Inject extra environment variables
*/}}
{{- define "webapp.env-variables" -}}
{{- range $key, $val := .appData.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}


{{/*
Inject extra environment variables from secrets
*/}}
{{- define "webapp.env-sealed-secrets" -}}
{{- range $secretName, $secretData := .appData.envSealedSecrets }}
{{- range $envName, $secretValue := $secretData }}
- name: {{ $envName }}
  valueFrom:
   secretKeyRef:
     name: {{ $secretName }}
     key: {{ $envName }}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Inject extra environment variables from fields
*/}}
{{- define "webapp.env-fields" -}}
{{- range $key, $val := .appData.envFields }}
- name: {{ $key }}
  valueFrom:
   fieldRef:
     fieldPath: {{ $val }}
{{- end -}}
{{- end -}}

{{/*
Create a service account name
*/}}
{{- define "webapp.serviceAccountName" -}}
{{- if .appData.serviceAccount.create -}}
    {{ default .appData.name .appData.serviceAccount.name }}
{{- else -}}
    {{ default "default" .appData.serviceAccount.name }}
{{- end -}}
{{- end -}}
