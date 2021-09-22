{{- define "servicelib.application" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Chart.Name }}
  labels:
    name: {{ .Chart.Name }}
    app: {{ .Chart.Name }}
    repo: {{ .Values.labels.repo }}
    version: {{ .Chart.Version }}
spec:
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: {{ .Values.port }}
  selector:
    app: {{ .Chart.Name }}
{{- end }}
