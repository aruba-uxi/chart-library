{{- define "servicelib.webapp" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Chart.Name }}
  namespace: {{ .Values.namespace }}
  labels:
    app: {{ .Chart.Name }}
spec:
  ports:
    - name: http
      port: 80
      protocol: TCP
      targetPort: {{ .Values.port }}
  selector:
    app: {{ .Chart.Name }}
{{- end }}
