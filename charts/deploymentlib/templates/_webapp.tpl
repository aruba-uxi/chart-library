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
      revisionHistoryLimit: 3
      {{- if .Values.serviceAccount }}
      serviceAccountName: {{ .Values.serviceAccount.name }}
      {{- end }}
      containers:
      - name: {{ .Chart.Name }}
        env:
        {{- include "podlib.env-variables" .Values | indent 8 }}
        {{- include "podlib.env-sealed-secrets" .Values | indent 8 }}
        {{- include "podlib.env-fields" .Values | indent 8 }}
        image: {{ .Values.image }}:{{ $.Chart.AppVersion }}
        imagePullPolicy: {{ .Values.imagePullPolicy | default "IfNotPresent" }}
        {{- if .Values.command }}
        command: [ {{ .Values.command | quote }} ]
        {{- end -}}
        {{- if .Values.readinessProbe }}
        readinessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: readinessProbe
            - name: Content-Type
              value: application/json
            path: {{ .Values.readinessProbe.path }}
            port: {{ .Values.port }}
          initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds | default "5" }}
          periodSeconds: {{ .Values.readinessProbe.periodSeconds | default "3" }}
        {{- end }}
        {{- if .Values.livenessProbe }}
        livenessProbe:
          httpGet:
            httpHeaders:
            - name: Host
              value: livenessProbe
            - name: Content-Type
              value: application/json
            path: {{ .Values.livenessProbe.path }}
            port: {{ .Values.port }}
          initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds | default "5" }}
          periodSeconds: {{ .Values.livenessProbe.periodSeconds | default "3" }}
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
        {{- if .Values.configmap }}
        volumeMounts:
        - name: config
          mountPath: {{ .Values.configmap.path }}
        {{- end }}
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
