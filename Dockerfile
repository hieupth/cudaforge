ARG BASE=ubuntu:latest
ARG MINIFORGE=Miniforge3

FROM ${BASE}
# Recall build args.
ARG MINIFORGE
# Useful envinronment.
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
# Install required packages.
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
        wget \
        curl \
        tini \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Set conda environments.
ENV CONDA_DIR=/opt/conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH=${CONDA_DIR}/bin:${PATH}
# ENV LD_LIBRARY_PATH=${CONDA_DIR}/lib:${LD_LIBRARY_PATH}
# Install mambaforge.
RUN curl -L -O https://github.com/conda-forge/miniforge/releases/latest/download/${MINIFORGE}-$(uname)-$(uname -m).sh && \
    chmod +x /${MINIFORGE}-$(uname)-$(uname -m).sh && \
    /${MINIFORGE}-$(uname)-$(uname -m).sh -b -p ${CONDA_DIR} && \
    rm /${MINIFORGE}-$(uname)-$(uname -m).sh && \
    echo ". ${CONDA_DIR}/etc/profile.d/mamba.sh" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> /etc/skel/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/mamba.sh" >> ~/.bashrc && \
    echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    ${CONDA_DIR}/bin/mamba clean -ay
# Set tini.
ENTRYPOINT ["tini", "-g", "--"]
# Set command.
CMD [ "/bin/bash" ]
