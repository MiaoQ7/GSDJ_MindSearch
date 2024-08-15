# Use the official Python base image
FROM python:3.12-slim-bookworm
ARG MY_VAR=amd64
RUN echo "MY_VAR: ${MY_VAR}"
# Set the working directory
WORKDIR /app
# 使用基于Debian或Ubuntu的基础镜像
# 设置时区为亚洲/上海（东八区）
# Install system dependencies
RUN apt-get update && \
    apt-get install -y tzdata && \
    rm -rf /var/lib/apt/lists/*
# Copy requirements.txt and install dependencies
# 设置时区为亚洲/上海（东八区）
RUN ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
COPY requirements.txt .
RUN mkdir -p /root/.pip
COPY pip.conf /root/.pip/pip.conf
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
# Copy the Python script into the container
COPY . /app/

# Expose the necessary port (9000 is webapp)
EXPOSE 9000


CMD ["uvicorn", "--host", "0.0.0.0", "--port", "9000", "--log-level", "info", "mindsearch.app:app"]

#CMD ["python", "main.py"]



#docker buildx build --platform linux/amd64 --build-arg MY_VAR=amd64 -t zzzzzga/gsdj_mindsearch --pull --push .