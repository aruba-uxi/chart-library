{{- define "deploymentlib.webapp" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
  labels:
    name: {{ .Chart.Name }}
    app: {{ .Chart.Name }}
    repo: {{ .Values.labels.repo }}
spec:
  replicas: {{ .Values.replicaCount | default 1 }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        name: {{ .Chart.Name }}
        app: {{ .Chart.Name }}
        repo: {{ .Values.labels.repo }}
    spec:
      revisionHistoryLimit: 3
      {{- if .Values.serviceAccount }}
      serviceAccountName: {{ .Values.serviceAccount.name }}
      {{- end }}
      containers:
{{- if not .Values.name }}
{{- $_ := set .Values "name" .Chart.Name }}
{{- end }}
{{- if not .Values.imageVersion }}
{{- $defaultImage := print .Values.image  ":" .Chart.AppVersion -}}
{{ $_ := set .Values "imageVersion" $defaultImage }}
{{- end }}
{{ include "podlib.container" .Values | indent 6}}
      {{- if .Values.sealedImagePullSecret }}
      imagePullSecrets:
      - name: sealed-image-pull-secret
      {{- end }}
      {{- if .Values.configmap }}
      volumes:
      - name: config
        configMap:
          name: {{ .Values.configmap.name }}
      {{- end }}
---
{{- include "podlib.sealedsecret" . }}
{{- end }}
