{{- define "joblib.job" -}}
{{- $defaultImage := print $.Values.image.repository  ":" $.Chart.AppVersion -}}
{{- range $jobName, $jobData := .Values.jobs }}
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
        command: {{ $jobData.command }}
      restartPolicy: {{ $jobData.restartPolicy | default "OnFailure"}}
{{- end }}
{{- end }}
