{{- define "ingresslib.legacyingress" -}}
{{- if .Values.legacyIngress.enabled -}}
{{- $chartName := .Chart.Name -}}
{{- $servicePort := .Values.port -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ .Chart.Name }}-legacy-ingress
  annotations:
    kubernetes.io/ingress.class: legacy-ingress
spec:
  rules:
  {{- range .Values.legacyIngress.hosts }}
  - host: {{ .host }}
    http:
      paths:
      {{- range (.paths | default (list "/")) }}
      - path: {{ . }}
        backend:
          serviceName: {{ $chartName }}
          servicePort: {{ $servicePort}}
      {{- end }}
  {{- end }}
{{- end -}}
{{- end -}}