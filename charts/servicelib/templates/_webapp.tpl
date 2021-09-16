{{- define "servicelib.webapp" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Chart.Name }}
  labels:
    app.kubernetes.io/name: {{ .Chart.Name }}
    app: {{ .Chart.Name }}
    repo: {{ .Values.labels.repo }}
spec:
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: {{ .Values.port }}
  selector:
    app: {{ .Chart.Name }}
{{- end }}
