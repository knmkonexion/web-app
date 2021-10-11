FROM python:3.9.2-alpine

ENV user='webapp'

WORKDIR /home/app

COPY . .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt \
    && apk add curl \
    && adduser -D "${user}" \
    && chown -R "${user}":"${user}" /home/app \
    && mkdir -p /var/log/flask-app \
    && touch /var/log/flask-app/flask-app.err.log \
    && touch /var/log/flask-app/flask-app.out.log \
    && chown -R "${user}":"${user}" /var/log/flask-app

USER "${user}"

ENV VIRTUAL_ENV=/home/app/venv \
    PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python -m venv $VIRTUAL_ENV \
    && export FLASK_APP=app.py

EXPOSE 5000

CMD ["python", "app.py"]