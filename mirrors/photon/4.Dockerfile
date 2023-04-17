FROM photon:4.0
RUN tdnf update -y
RUN tdnf upgrade -y
RUN tdnf install -y rpm shadow
