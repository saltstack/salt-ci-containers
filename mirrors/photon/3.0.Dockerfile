FROM photon:3.0
RUN tdnf update
RUN tdnf upgrade -y
