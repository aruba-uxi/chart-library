{{- define "joblib.job" -}}
{{- $appVersion := print $.Chart.AppVersion -}}
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
        image: "{{ $jobData.image.repository }}:{{ default $appVersion $jobData.image.tag }}"
        imagePullPolicy: {{ $jobData.image.pullPolicy | default "IfNotPresent" }}
        command: {{ $jobData.command }}
      restartPolicy: {{ $jobData.restartPolicy | default "OnFailure"}}
{{- end }}
{{- end }}
