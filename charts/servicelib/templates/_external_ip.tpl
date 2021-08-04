{{- define "servicelib.external_ip" -}}
{{- range $key, $val := .Values.externalIps }}
apiVersion: v1
kind: Service
metadata:
  name: {{ $key }}
  labels:
    app: {{ $key }}
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
