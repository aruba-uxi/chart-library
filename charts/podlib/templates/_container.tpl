{{- define "podlib.container" -}}
- name: {{ $.name }}
  image: {{ $.image }}
  imagePullPolicy: {{ $.imagePullPolicy | default "IfNotPresent" }}
  {{- if $.command }}
  command: {{ toRawJson $.command }}
  {{- end }}
  {{- if $.env }}
  env:
  {{- include "podlib.env-variables" $ | indent 2 }}
  {{- include "podlib.env-sealed-secrets" $ | indent 2 }}
  {{- include "podlib.env-fields" $ | indent 2 }}
  {{- end }}
  resources:
    limits:
    {{- if $.limitCpu }}
      cpu: {{ $.limitCpu }}
    {{- end }}
    {{- if $.limitMemory }}
      memory: {{ $.limitMemory }}
    {{- end }}
  {{- if $.parallel }}
  parallelism: {{ $.parallel }}
  {{- end }}
  {{- if $.configmap }}
  volumeMounts:
  - name: config
    mountPath: {{ $.configmap.path }}
  {{- end }}
{{- end }}
