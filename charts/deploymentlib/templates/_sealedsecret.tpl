{{- define "deploymentlib.sealedsecret" -}}
{{- if .Values.envSecrets -}}
{{- range $key, $val := .Values.envSecrets }}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: {{ $key | lower }}
spec:
  encryptedData:
    {{ $key }}: {{ $val }}
---
{{- end -}}
{{- end -}}
{{- end -}}
