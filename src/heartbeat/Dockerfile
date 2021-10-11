FROM docker.elastic.co/beats/heartbeat:7.9.0

COPY heartbeat.yml /usr/share/heartbeat/heartbeat.yml

COPY monitors/* /opt/heartbeat/monitors/

USER root

RUN chown -R heartbeat:heartbeat /opt/heartbeat/monitors \
    && chown -R heartbeat:heartbeat /usr/share/heartbeat

USER heartbeat