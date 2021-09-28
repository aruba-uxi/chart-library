{{- define "joblib.jobs" -}}
{{- $defaultImage := print $.Values.image  ":" $.Chart.AppVersion -}}
{{- range $jobData := $.Values.jobs }}
---
{{- if not $jobData.image }}
{{ $_ := set $jobData "imageVersion" $defaultImage }}
{{ else }}
{{ $_ := set $jobData "imageVersion" $jobData.image }}
{{- end }}
{{- if not $jobData.imagePullPolicy }}
{{ $_ := set $jobData "imagePullPolicy" $.Values.imagePullPolicy }}
{{- end }}
{{- if not $jobData.env }}
{{ $_ := set $jobData "env" dict }}
{{- end }}
{{- if not $.Values.env }}
{{ $_ := set $.Values "env" dict }}
{{- end }}
{{ $_ := merge $jobData.env $.Values.env $jobData.env }}
{{- if not $jobData.envSealedSecrets }}
{{ $_ := set $jobData "envSealedSecrets" dict }}
{{- end }}
{{- if not $.Values.envSealedSecrets }}
{{ $_ := set $.Values "envSealedSecrets" dict }}
{{- end }}
{{ $_ := merge $jobData.envSealedSecrets $.Values.envSealedSecrets $jobData.envSealedSecrets }}
{{- if $.Values.envFields }}
{{ $_ := set $jobData "envFields" $.Values.envFields }}
{{- end }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $jobData.name }}
  labels:
    name: {{ $jobData.name }}
    app: {{ $.Chart.Name }}
    repo: {{ $.Values.labels.repo }}
    version: {{ $.Chart.Version }}
spec:
  template:
    metadata:
      name: {{ $jobData.name }}
      labels:
        name: {{ $jobData.name }}
        app: {{ $.Chart.Name }}
        repo: {{ $.Values.labels.repo }}
        version: {{ $.Chart.Version }}
    spec:
      containers:
{{ include "podlib.container" $jobData | indent 6}}
      restartPolicy: {{ $jobData.restartPolicy | default "OnFailure"}}
      {{- if $.Values.sealedImagePullSecret }}
      imagePullSecrets:
      - name: sealed-image-pull-secret
      {{- end }}
      {{- if $jobData.configmap }}
      volumes:
      - name: config
        configMap:
          name: {{ $jobData.configmap.name }}
      {{- end }}

{{- end }}
{{- end }}