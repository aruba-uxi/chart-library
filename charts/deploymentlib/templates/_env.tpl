{{- define "deploymentlib.env-variables" -}}
{{- range $key, $val := .Values.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}


{{- define "deploymentlib.env-secrets" -}}
{{- if .Values.envSecrets -}}
{{- range $key, $val := .Values.envSecrets }}
- name: {{ $key }}
  valueFrom:
   secretKeyRef:
     name: {{ $key | lower | replace "_" "-" }}
     key:  {{ $key }}
{{- end -}}
{{- end -}}
{{- end -}}


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
