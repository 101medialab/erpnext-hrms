FROM frappe/bench:latest

COPY ./init.sh /workspace/
USER root
RUN chmod +x /workspace/init.sh
USER frappe

RUN pip install --no-cache-dir frappe-bench
RUN bash /workspace/init.sh