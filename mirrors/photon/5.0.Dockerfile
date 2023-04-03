FROM photon:5.0
RUN tdnf update
RUN tdnf upgrade -y
