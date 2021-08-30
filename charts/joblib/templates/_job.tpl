{{- define "joblib.job" -}}
{{- $defaultImage := print $.Values.image  ":" $.Chart.AppVersion -}}
{{- range $jobName, $jobData := .Values.jobs }}
---
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $jobName }}
spec:
  template:
    metadata:
      name: {{ $jobName }}
    spec:
      containers:
      - name: {{ $jobName }}
        image: {{ $jobData.image | default $defaultImage }}
        imagePullPolicy: {{ $jobData.imagePullPolicy | default $.Values.imagePullPolicy | default "IfNotPresent" }}
        command: {{ toRawJson $jobData.command }}
        env:
        {{- include "podlib.env-variables" $.Values | indent 8 }}
        {{- include "podlib.env-variables" . | indent 8 }}
        {{- include "podlib.env-sealed-secrets" $.Values | indent 8 }}
        {{- include "podlib.env-sealed-secrets" . | indent 8 }}
        {{- include "podlib.env-fields" $.Values | indent 8 }}
        {{- include "podlib.env-fields" . | indent 8 }}
        resources:
          limits:
            {{- if $jobData.limitCpu }}
            cpu: {{ $jobData.limitCpu }}
            {{- end }}
            {{- if $jobData.limitMemory }}
            memory: {{ $jobData.limitMemory }}
            {{- end }}
      restartPolicy: {{ $jobData.restartPolicy | default "OnFailure"}}
      {{- if $.Values.sealedImagePullSecret }}
      imagePullSecrets:
      - name: sealed-image-pull-secret
      {{- end }}
{{- end }}
{{- end }}
