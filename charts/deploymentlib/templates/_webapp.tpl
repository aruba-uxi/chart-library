{{- define "deploymentlib.webapp" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.name }}
  labels:
    app: {{ .Chart.name }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ .Chart.name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.name }}
    spec:
      containers:
      - name: {{ .Chart.name }}
        env:
        {{- include "deploymentlib.env-variables" . | indent 8 }}
        image: {{ .Values.image }}:{{ $.Chart.AppVersion }}
        imagePullPolicy: IfNotPresent
        readinessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: readinessProbe
            path: {{ .Values.readinessPath }}
            port: {{ .Values.port }}
          initialDelaySeconds: 5
          periodSeconds: 3
        livenessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: livenessProbe
            path: {{ .Values.livenessPath }}
            port: {{ .Values.port }}
          initialDelaySeconds: 5
          periodSeconds: 3
        ports:
        - containerPort: {{ .Values.port }}
        resources:
          limits:
            {{- if .Values.limitCpu }}
            cpu: {{ .Values.limitCpu }}
            {{- end }}
            {{- if .Values.limitMemory }}
            memory: {{ .Values.limitMemory }}
            {{- end }}

      {{- if .Values.imagePullSecret }}
      imagePullSecrets:
      - name: {{ .Values.imagePullSecret }}
      {{- end }}
{{- end }}
