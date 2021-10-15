FROM grafana/grafana:7.5.3

ARG SLACK_ALERT_CHANNEL
ENV SLACK_ALERT_CHANNEL="$SLACK_ALERT_CHANNEL"

COPY datasources/* /etc/grafana/provisioning/datasources/
COPY dashboards/* /etc/grafana/provisioning/dashboards/
COPY notifiers/* /etc/grafana/provisioning/notifiers/
