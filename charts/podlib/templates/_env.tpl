{{/*
Inject extra environment variables
*/}}
{{- define "podlib.env-variables" -}}
{{- range $key, $val := $.env }}
- name: {{ $key }}
  value: {{ $val | quote }}
{{- end }}
{{- end }}


{{/*
Inject extra environment variables from secrets
*/}}
{{- define "podlib.env-sealed-secrets" -}}
{{- if $.envSealedSecrets -}}
{{- range $secretName, $secretData := $.envSealedSecrets }}
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
{{- define "podlib.env-fields" -}}
{{- if $.envFields -}}
{{- range $key, $val := $.envFields }}
- name: {{ $key }}
  valueFrom:
   fieldRef:
     fieldPath: {{ $val }}
{{- end -}}
{{- end -}}
{{- end -}}
