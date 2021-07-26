{{- define "deploymentlib.env-variables" -}}
{{- range $key, $val := .Values.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}


{{- define "deploymentlib.env-variables-from-secrets" -}}
{{- if .envFromSecrets -}}
{{- range .envFromSecrets }}
- name: {{ .envName }}
  valueFrom:
   secretKeyRef:
     name: {{ .secretName }}
     key: {{ .secretKey }}
{{- end -}}
{{- end -}}
{{- end -}}
