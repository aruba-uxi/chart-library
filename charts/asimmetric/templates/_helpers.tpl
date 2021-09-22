{{/*
Expand the name of the chart.
*/}}
{{- define "application.name" -}}
{{- $validRoles := list "service" "worker" -}}
{{- $name := .context.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- if .appData.role -}}
  {{- if has .appData.role $validRoles -}}
    {{- printf "%s-%s" $name .appData.role -}}
  {{- else -}}
    {{- required "role is invalid" .appData.role -}}
  {{- end -}}
{{- else -}}
  {{- printf "%s" $name -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "application.labels" -}}
helm.sh/chart: {{ include "application.chart" .context }}
{{ include "application.selectorLabels" (dict "context" .context "appData" .appData) }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app: {{ (include "application.name" (dict "context" .context "appData" .appData)) }}
{{- if .appData.role }}
role: {{ .appData.role }}
{{- end }}
repository: {{ .context.Values.global.labels.repo }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ (include "application.name" (dict "context" .context "appData" .appData))}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end }}


{{/*
Inject extra environment variables
*/}}
{{- define "application.env-variables" -}}
{{- range $key, $val := .appData.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}


{{/*
Inject extra environment variables from secrets
*/}}
{{- define "application.env-sealed-secrets" -}}
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
{{- define "application.env-fields" -}}
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
{{- define "application.serviceAccountName" -}}
{{- if .appData.serviceAccount.create -}}
    {{ default (include "application.name" (dict "context" .context "appData" .appData)) .appData.serviceAccount.name }}
{{- else -}}
    {{ default "default" .appData.serviceAccount.name }}
{{- end -}}
{{- end -}}
