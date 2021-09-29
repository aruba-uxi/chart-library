{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "application.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{- define "application.selectorLabels" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- end }}

{{- define "application.labels" -}}
{{ include "application.selectorLabels" (dict "context" .context "name" .name) }}
helm.sh/chart: {{ include "application.chart" .context }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
repository: {{ .context.Values.global.repository }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "sealedSecret.name" -}}
{{- printf "%s-%s" .name .secretName -}}
{{- end -}}

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
{{- range $key, $val := .data }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}

{{/*
Inject extra environment variables from fields
https://helm.sh/docs/chart_template_guide/function_list/#mergeoverwrite-mustmergeoverwrite
*/}}
{{- define "application.env-fields" -}}
{{- range $key, $val := .data }}
- name: {{ $key }}
  valueFrom:
   fieldRef:
     fieldPath: {{ $val }}
{{- end }}
{{- end }}

{{/*
Inject extra environment variables from secrets
https://helm.sh/docs/chart_template_guide/function_list/#mergeoverwrite-mustmergeoverwrite
*/}}
{{- define "application.env-sealed-secrets" -}}
{{- range $secretName, $secretData := .data }}
{{- range $envName, $secretValue := $secretData }}
- name: {{ $envName }}
  valueFrom:
   secretKeyRef:
     name: {{ include "sealedSecret.name" (dict "context" $.context "name" $.name "secretName" $secretName)}}
     key: {{ $envName }}
{{- end }}
{{- end }}
{{- end }}

{{- define "serviceAccount.name" -}}
{{- if .data.serviceAccount.create -}}
    {{ default .name .data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .data.serviceAccount.name }}
{{- end -}}
{{- end -}}
