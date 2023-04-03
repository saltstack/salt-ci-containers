FROM photon:4.0
RUN tdnf update
RUN tdnf upgrade -y
