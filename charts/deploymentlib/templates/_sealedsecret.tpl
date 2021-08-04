{{- define "deploymentlib.sealedsecret" -}}
{{- if .Values.envSecrets -}}
{{- range .Values.envSecrets }}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: {{ .secretName }}
  namespace: {{ .secretNamespace }}
spec:
  encryptedData:
    {{ .secretKey }}: {{ .secretValue }}
---
{{- end -}}
{{- end -}}
{{- end -}}
