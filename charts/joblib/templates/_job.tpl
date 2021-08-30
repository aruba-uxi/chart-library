{{- define "joblib.job" -}}
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
        image: {{ $jobData.image | default $.Values.image }}
        imagePullPolicy: {{ $jobData.imagePullPolicy | default $.Values.imagePullPolicy | default "IfNotPresent" }}
        command: {{ $jobData.command }}
      restartPolicy: {{ $jobData.restartPolicy | default "OnFailure"}}
{{- end }}
{{- end }}
