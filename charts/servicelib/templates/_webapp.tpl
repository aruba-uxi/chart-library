apiVersion: v1
kind: Service
metadata:
  name: {{ .Chart.Name }}-service
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
