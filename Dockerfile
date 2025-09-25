FROM quay.io/astronomer/astro-runtime:3.0-12

# Installer les dépendances Python supplémentaires si nécessaire
USER root

# Installer les packages système requis
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-libmysqlclient-dev \
        pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Revenir à l'utilisair non-root pour la sécurité
USER astro

# Installer les packages Python supplémentaires
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copier les DAGs et autres fichiers nécessaires
COPY dags/ /usr/local/airflow/dags/
COPY plugins/ /usr/local/airflow/plugins/
COPY include/ /usr/local/airflow/include/

# Définir les variables d'environnement si nécessaire
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENV AIRFLOW__CORE__ENABLE_XCOM_PICKLING=True

# Port exposé (standard pour Airflow)
EXPOSE 8080
