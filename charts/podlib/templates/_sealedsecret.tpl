{{- define "podlib.sealedsecret" -}}
{{- if .Values.envSealedSecrets -}}
{{- range $secretName, $secretData := .Values.envSealedSecrets }}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: {{ $secretName }}
spec:
  encryptedData:
    {{- range $secretKey, $secretValue := $secretData }}
    {{ $secretKey }}: {{ $secretValue }}
    {{- end }}
---
{{- end -}}
{{- end -}}

{{- if .Values.sealedImagePullSecret -}}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: sealed-image-pull-secret
spec:
  encryptedData:
    .dockerconfigjson: {{ .Values.sealedImagePullSecret }}
  template:
    data: null
    metadata:
      name: sealed-image-pull-secret
      namesapce: {{ .Release.Namespace }}
    type: kubernetes.io/dockerconfigjson

---
{{- end -}}

{{- end -}}