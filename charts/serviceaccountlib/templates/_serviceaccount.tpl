{{- define "serviceaccountlib.serviceaccount" -}}
{{- if .Values.serviceAccount }}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .Values.serviceAccount.name }}
  labels:
    app.kubernetes.io/name: {{ .Values.serviceAccount.name }}
    app: {{ .Chart.Name }}
    repo: {{ .Values.labels.repo }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}
