### Infinispan Session Caching ###
FROM ibmcom/websphere-liberty:kernel-java8-openj9-ubi AS infinispan-client

# Install Infinispan client jars
USER root
RUN infinispan-client-setup.sh
USER 1001

FROM ibmcom/websphere-liberty:kernel-java8-openj9-ubi AS open-liberty-infinispan

# Copy Infinispan client jars to Open Liberty shared resources
COPY --chown=1001:0 --from=infinispan-client /opt/ibm/wlp/usr/shared/resources/infinispan /opt/ibm/wlp/usr/shared/resources/infinispan

# Instruct configure.sh to use Infinispan for session caching.
# This should be set to the Infinispan service name.
# TIP - Run the following oc/kubectl command with admin permissions to determine this value:
#       oc get infinispan -o jsonpath={.items[0].metadata.name}
ENV INFINISPAN_SERVICE_NAME=example-infinispan

# Uncomment and set to override auto detected values.
# These are normally not needed if running in a Kubernetes environment.
# One such scenario would be when the Infinispan and Liberty deployments are in different namespaces/projects.
#ENV INFINISPAN_HOST=
#ENV INFINISPAN_PORT=
#ENV INFINISPAN_USER=
#ENV INFINISPAN_PASS=

# This script will add the requested XML snippets and grow image to be fit-for-purpose
RUN configure.sh
