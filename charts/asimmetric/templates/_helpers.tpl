{{- define "application.name" -}}
{{- $name := .context.Release.Name | trunc 63 | trimSuffix "-" -}}
{{- if .appData.role -}}
    {{- printf "%s-%s" $name .appData.role -}}
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

{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ (include "application.name" (dict "context" .context "appData" .appData))}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end }}

{{- define "application.labels" -}}
{{ include "application.selectorLabels" (dict "context" .context "appData" .appData) }}
helm.sh/chart: {{ include "application.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
role: {{ .appData.role }}
repository: {{ .context.Values.global.labels.repo }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "sealedSecret.name" -}}
{{- $appName := (include "application.name" (dict "context" .context "appData" .appData)) -}}
{{- printf "%s-%s" $appName .secretName -}}
{{- end -}}

{{- define "sealedSecret.labels" -}}
{{ include "application.selectorLabels" (dict "context" .context "appData" (default dict .appData)) }}
helm.sh/chart: {{ include "application.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
repository: {{ .context.Values.global.labels.repo }}
{{- end }}

{{- define "sealedImagePullSecret.name" -}}
{{- print "sealed-image-pull-secret" -}}
{{- end -}}

{{- define "sealedImagePullSecret.labels" -}}
app.kubernetes.io/name: {{ include "sealedImagePullSecret.name" "" }}
helm.sh/chart: {{ include "application.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
{{- end }}

{{/*
Inject extra environment variables
https://helm.sh/docs/chart_template_guide/function_list/#mergeoverwrite-mustmergeoverwrite
*/}}
{{- define "application.env-variables" -}}
{{- $data := mustMergeOverwrite .context.Values.global.env .appData.env -}}
{{- range $key, $val := $data }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}

{{/*
Inject extra environment variables from fields
https://helm.sh/docs/chart_template_guide/function_list/#mergeoverwrite-mustmergeoverwrite
*/}}
{{- define "application.env-fields" -}}
{{- $data := mustMergeOverwrite .context.Values.global.envFields .appData.envFields -}}
{{- range $key, $val := $data }}
- name: {{ $key }}
  valueFrom:
   fieldRef:
     fieldPath: {{ $val }}
{{- end -}}
{{- end -}}


{{/*
Inject extra environment variables from secrets
https://helm.sh/docs/chart_template_guide/function_list/#mergeoverwrite-mustmergeoverwrite
*/}}
{{- define "application.env-sealed-secrets" -}}
{{- $data := mustMergeOverwrite .context.Values.global.envSealedSecrets .appData.envSealedSecrets -}}
{{- range $secretName, $secretData := $data }}
{{- range $envName, $secretValue := $secretData }}
- name: {{ $envName }}
  valueFrom:
   secretKeyRef:
     name: {{ include "sealedSecret.name" (dict "context" $.context "appData" $.appData "secretName" $secretName)}}
     key: {{ $envName }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "serviceAccount.name" -}}
{{- if .appData.serviceAccount.create -}}
    {{ default (include "application.name" (dict "context" .context "appData" .appData)) .appData.serviceAccount.name }}
{{- else -}}
    {{ default "default" .appData.serviceAccount.name }}
{{- end -}}
{{- end -}}
