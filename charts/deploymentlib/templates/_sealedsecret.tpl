{{- define "deploymentlib.sealedsecret" -}}
{{- if .Values.envSealedSecrets -}}
{{- $secretNamespace := .Values.secretNamespace -}}
{{- range $secretName, $secretData := .Values.envSealedSecrets }}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: {{ $secretName }}
  namespace: {{ $secretNamespace }}
spec:
  encryptedData:
    {{- range $secretKey, $secretValue := $secretData }}
    {{ $secretKey }}: {{ $secretValue }}
    {{- end }}
---
{{- end -}}
{{- end -}}
{{- end -}}
