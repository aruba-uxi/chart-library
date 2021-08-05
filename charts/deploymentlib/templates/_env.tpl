{{/*
Inject extra environment variables
*/}}
{{- define "deploymentlib.env-variables" -}}
{{- range $key, $val := .Values.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}


{{/*
Inject extra environment variables from secrets
*/}}
{{- define "deploymentlib.env-sealed-secrets" -}}
{{- if .Values.envSealedSecrets -}}
{{- range $secretName, $secretData := .Values.envSealedSecrets }}
{{- range $envName, $secretValue := $secretData }}
- name: {{ $envName }}
  valueFrom:
   secretKeyRef:
     name: {{ $secretName }}
     key: {{ $envName }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Inject extra environment variables from fields
*/}}
{{- define "deploymentlib.env-fields" -}}
{{- if .Values.envFields -}}
{{- range $key, $val := .Values.envFields }}
- name: {{ $key }}
  valueFrom:
   fieldRef:
     fieldPath: {{ $val }}
{{- end -}}
{{- end -}}
{{- end -}}
