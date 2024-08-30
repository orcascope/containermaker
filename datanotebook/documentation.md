# Python Data Science Notebook Docker Image

This Docker image provides a Python environment with a wide range of data science libraries pre-installed. It is designed for easy access via a Jupyter Notebook in your web browser. The image is built from a minimal Python base and includes libraries for data manipulation, machine learning, and database connectivity.

## Features

- **Base Image**: `python:3.9-slim`
- **Notebook Access**: Jupyter Notebook accessible via a web browser
- **Pre-installed Libraries**:
  - Data manipulation: `pandas`, `numpy`, `polars`, `dask`,`ibis`
  - Machine learning: `scikit-learn`, `tensorflow`, `torch`, `xgboost`, `lightgbm`
  - Visualization: `matplotlib`, `seaborn`, `plotly`
  - Database access: `psycopg2-binary`, `mysqlclient`, `sqlalchemy`, `duckdb`, `pyarrow`
  - Object storage: `boto3`, `s3fs`, `minio`
  - Other utilities: `openpyxl`, `requests`, `beautifulsoup4`, `lxml`, `pyspark`, `dremio-simple-query`
- **User**: `pydata` with a working directory set to `/home/pydata/work`
- **Ports Exposed**: `8888` (Jupyter Notebook)

## Usage

### Building the Image

To build the Docker image, navigate to the directory containing the `Dockerfile` and run:

```bash
docker build -t python-notebook .
```

### Running the Container
To run the container and start the Jupyter Notebook server, use the following command:

```bash
docker run -p 8888:8888 -v $(pwd):/home/pydata/work python-notebook
```

- **Port Mapping:** The -p 8888:8888 flag maps the container's port 8888 (where the Jupyter Notebook server is running) to the host's port 8888.
- **Volume Mounting:** The -v $(pwd):/home/pydata/work flag mounts your current directory to the container's working directory. This allows you to work with your files inside the notebook.

### Accessing the Jupyter Notebook
Once the container is running, you can access the Jupyter Notebook in your web browser by navigating to:

```bash
http://localhost:8888
```

## Notes

- **Token Authentication:** The Jupyter Notebook server is started with the --NotebookApp.token='' flag, which disables token authentication. This allows direct access to the notebook without requiring a login token.

- **User Configuration:** The image uses the user pydata with the home directory set to /home/pydata. The working directory for the notebook is /home/pydata/work.

## Extending the Image
If you need to add more libraries or make additional configurations, you can extend this image by creating a new Dockerfile that builds on top of it. For example:

```dockerfile
FROM python-notebook

RUN pip install additional-library
```

## Troubleshooting

### Common Issues

- **Cannot Access Notebook:** Ensure that port 8888 is not being blocked by your firewall or used by another service.
- **Permission Errors:** Make sure the directory you're mounting ($(pwd)) has appropriate read/write permissions.