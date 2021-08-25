{{- define "serviceaccountlib.serviceaccount" -}}
{{- if .Values.serviceAccount }}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ .Values.serviceAccount.name }}
  labels:
    app: {{ .Values.serviceAccount.name }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
{{- end }}
