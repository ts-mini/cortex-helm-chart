
{{/*
alertmanager fullname
*/}}
{{- define "cortex.alertmanagerFullname" -}}
{{ include "cortex.fullname" . }}-alertmanager
{{- end }}

{{/*
alertmanager common labels
*/}}
{{- define "cortex.alertmanagerLabels" -}}
{{ include "cortex.labels" . }}
app.kubernetes.io/component: alertmanager
{{- end }}

{{/*
alertmanager selector labels
*/}}
{{- define "cortex.alertmanagerSelectorLabels" -}}
{{ include "cortex.selectorLabels" . }}
app.kubernetes.io/component: alertmanager
{{- end }}


{{/*
alertmanager comma seperated peer list
*/}}
{{- define "cortex.alertmanagerPeers" -}}
{{- $peerlist := list -}}
{{- $fullName := include "cortex.fullname" $ -}}
{{- $serviceName := printf "%s-alertmanager-headless" $fullName -}}
{{- $clusterPort := regexReplaceAll ".+[:]" (default "0.0.0.0:9094" .Values.config.alertmanager.cluster_bind_address) "" -}}
{{- $fqdn := printf "%s.svc.%s:%s" $.Release.Namespace $.Values.clusterDomain $clusterPort -}}
{{- range $n := until (.Values.alertmanager.replicas | int ) }}
{{- $peerlist = (printf "%s-alertmanager-%s.%s.%s" $fullName ($n | toString) $serviceName $fqdn) | append $peerlist -}}
{{- end }}
{{- $peerlist | join "," -}}
{{- end }}

