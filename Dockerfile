# Test stage
FROM python:3.10-alpine AS test

COPY zscalercertificate.crt  /etc/ssl/certs/

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY src/ src/
COPY tests/ tests/

RUN mkdir -p coverage-report

RUN coverage run -m unittest discover -s tests/ && \
    coverage xml -o coverage-report/coverage-python.xml && \
    python -m xmlrunner discover -s tests/ -o coverage-report/execution-python.xml

CMD [ "tail", "-f", "/dev/null" ]

# Production stage
FROM python:3.10-alpine AS production

WORKDIR /app

RUN pip install flask==3.0.3

COPY src/ src/

ENTRYPOINT ["python"]
CMD ["/app/src/app.py"]