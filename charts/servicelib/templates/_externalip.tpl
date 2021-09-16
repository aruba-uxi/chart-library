{{- define "servicelib.externalip" -}}
{{- range $key, $val := .Values.externalIps }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $key }}
  labels:
    name: {{ $key}}
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
  externalIPs:
{{- range $val.ips }}
  - {{ . }}
{{- end }}
{{- end }}
{{- end }}
