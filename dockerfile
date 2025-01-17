# Use the official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables
ENV SPARK_VERSION=3.5.2 \
    HADOOP_VERSION=3 \
    PYTHON_VERSION=3.10

# Install dependencies
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk wget curl python${PYTHON_VERSION} python${PYTHON_VERSION}-dev python3-pip && \
    apt-get clean

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Spark
RUN wget https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark && \
    rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Set Spark environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Upgrade Pip
RUN pip3 install --upgrade pip 

# Install Python Libraries
RUN pip install --no-cache-dir \
    jupyterlab \
    scipy \
    findspark \
    getdaft[all] \
    sqlframe[all] \
    ipywidgets \
    ibis-framework[all] \
    notebook \
    pandas \
    numpy \
    matplotlib \
    seaborn \
    scikit-learn \
    tensorflow \
    torch \
    xgboost \
    lightgbm \
    dask \
    statsmodels \
    plotly \
    openpyxl \
    pyarrow \
    sqlalchemy \
    psycopg2-binary \
    requests \
    beautifulsoup4 \
    lxml \
    duckdb \
    polars \
    pyspark \
    dremio-simple-query \
    boto3 \
    s3fs \
    minio

# more libraries
RUN pip install --no-cache-dir \
    pyiceberg[gcsfs,adlfs,s3fs,sql-sqlite,sql-postgres,glue,hive]

# Even More Libraries
RUN pip install --no-cache-dir \
    datafusion

# Expose Jupyter Notebook port
EXPOSE 8888

# Expose Spark ports
# Spark Web UI
EXPOSE 4040  
# Spark Standalone Mode Cluster Manager
EXPOSE 7077  
# Spark History Server
EXPOSE 8080  
# Spark History Server (alternative port)
EXPOSE 18080 
# Spark Standalone Mode REST Server
EXPOSE 6066  
# Spark Worker Web UI
EXPOSE 7078  
# Spark Master Web UI
EXPOSE 8081  

# Create a working directory
WORKDIR /workspace

# Set Spark environment variables
ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH

# Set umask globally by adding it to the entrypoint
RUN echo "umask 000" >> /etc/profile

# Start Spark Master, Worker, and JupyterLab
CMD bash -c "source /etc/profile && \
    $SPARK_HOME/sbin/start-master.sh && \
    $SPARK_HOME/sbin/start-worker.sh spark://$(hostname):7077 && \
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' --NotebookApp.password=''"