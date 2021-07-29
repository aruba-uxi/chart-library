{{- define "namespacelib.webapp" -}}
{{- if ne .Values.namespace "default" -}}
apiVersion: v1
kind: Namespace
metadata:
  labels:
    app: {{ .Chart.Name }}
  name: {{ .Values.namespace }}
{{- end }}
{{- end }}
