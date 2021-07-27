{{- define "deploymentlib.sealedsecret" -}}
{{- if .Values.envSecrets -}}
{{- range $key, $val := .Values.envSecrets }}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: {{ $key | lower }}
  namespace: {{ $.Values.secretNamespace }}
spec:
  encryptedData:
    {{ $key }}: {{ $val }}
  template:
    metadata:
      creationTimestamp: null
      name: {{ $key | lower }}
      namespace: {{ $.Values.secretNamespace }}
---
{{- end -}}
{{- end -}}
{{- end -}}
