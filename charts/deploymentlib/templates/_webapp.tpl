{{- define "deploymentlib.webapp" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
  labels:
    app: {{ .Chart.Name }}
spec:
  replicas: {{ .Values.replicaCount | default 1 }}
  selector:
    matchLabels:
      app: {{ .Chart.Name }}
  template:
    metadata:
      labels:
        app: {{ .Chart.Name }}
    spec:
      {{ if .Values.serviceAccountName }}
      serviceAccountName: {{ .Values.serviceAccountName }}
      {{ end }}
      containers:
      - name: {{ .Chart.Name }}
        env:
        {{- include "deploymentlib.env-variables" . | indent 8 }}
        {{- include "deploymentlib.env-sealed-secrets" . | indent 8 }}
        {{- include "deploymentlib.env-fields" . | indent 8 }}
        image: {{ .Values.image }}:{{ $.Chart.AppVersion }}
        imagePullPolicy: {{ .Values.imagePullPolicy | default "IfNotPresent" }}
        {{- if .Values.command }}
        command: [ {{ .Values.command | quote }} ]
        {{- end -}}
        {{ if .Values.readinessPath }}
        readinessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: readinessProbe
            - name: Content-Type
              value: application/json
            path: {{ .Values.readinessPath }}
            port: {{ .Values.port }}
          initialDelaySeconds: 5
          periodSeconds: 3
        {{- end }}
        {{ if .Values.livenessPath }}
        livenessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: livenessProbe
            - name: Content-Type
              value: application/json
            path: {{ .Values.livenessPath }}
            port: {{ .Values.port }}
          initialDelaySeconds: 5
          periodSeconds: 3
        {{- end }}
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
---
{{- include "deploymentlib.sealedsecret" . }}
{{- end }}
