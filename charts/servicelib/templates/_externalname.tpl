{{- define "servicelib.externalname" -}}
{{- range $key, $val := .Values.externalNames }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $key }}
  labels:
    name: {{ $key }}
    app: {{ $.Chart.Name }}
    repo: {{ $.Values.labels.repo }}
spec:
  ports:
{{- range $portVal := $val.ports }}
    - name: {{ $portVal.name }}
      protocol: {{ $portVal.protocol | default "TCP" }}
      targetPort: {{ $portVal.port }}
      port: {{ $portVal.port }}
{{- end }}
  type: ExternalName
  externalName: {{ $val.url }}
{{- end }}
{{- end }}
