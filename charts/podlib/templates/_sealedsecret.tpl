{{- define "podlib.sealedsecret" -}}
{{- if .Values.envSealedSecrets -}}
{{- range $secretName, $secretData := .Values.envSealedSecrets }}
---
apiVersion: bitnami.com/v1alpha1
kind: SealedSecret
metadata:
  name: {{ $secretName }}
  labels:
    name: {{ $secretName }}
    app: {{ $.Chart.Name }}
    repo: {{ $.Values.labels.repo }}
    version: {{ $.Chart.Version }}
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
  labels:
    name: sealed-image-pull-secret
    app: {{ .Chart.Name }}
    repo: {{ .Values.labels.repo }}
    version: {{ .Chart.Version }}
spec:
  encryptedData:
    .dockerconfigjson: {{ .Values.sealedImagePullSecret }}
  template:
    data: null
    metadata:
      name: sealed-image-pull-secret
      labels:
        name: sealed-image-pull-secret
        app: {{ .Chart.Name }}
        repo: {{ .Values.labels.repo }}
        version: {{ .Chart.Version }}
    type: kubernetes.io/dockerconfigjson
---
{{- end -}}

{{- end -}}
