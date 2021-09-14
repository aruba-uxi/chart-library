{{- define "podlib.container" -}}
- name: {{ $.name }}
  image: {{ $.imageVersion }}
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
  {{- if $.readinessProbe }}
  readinessProbe:
    httpGet:
      httpHeaders:
      - name: Host
        value: readinessProbe
      - name: Content-Type
        value: application/json
      path: {{ $.readinessProbe.path }}
      port: {{ $.port }}
    initialDelaySeconds: {{ $.readinessProbe.initialDelaySeconds | default "5" }}
    periodSeconds: {{ $.readinessProbe.periodSeconds | default "3" }}
  {{- end }}
  {{- if $.livenessProbe }}
  livenessProbe:
    httpGet:
      httpHeaders:
      - name: Host
        value: livenessProbe
      - name: Content-Type
        value: application/json
      path: {{ $.livenessProbe.path }}
      port: {{ $.port }}
    initialDelaySeconds: {{ $.livenessProbe.initialDelaySeconds | default "5" }}
    periodSeconds: {{ $.livenessProbe.periodSeconds | default "3" }}
  {{- end }}
  {{- if $.port }}
  ports:
  - containerPort: {{ $.port }}
  {{- end }}
  {{- if or $.limitCpu $.limitMemory }}
  resources:
    limits:
      {{- if $.limitCpu }}
      cpu: {{ $.limitCpu }}
      {{- end }}
      {{- if $.limitMemory }}
      memory: {{ $.limitMemory }}
      {{- end }}
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
