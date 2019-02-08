FROM alpine:3.9 as base

RUN apk --no-cache add \
    python2 \
    && find /usr -name "*.py" ! -name "__*" -exec rm {} \;

FROM base as builder

# Copy the requirements and install them
# Do this in a separate image in a separate directory
# to not have all the pip stuff in the final image
COPY requirements.txt /

RUN apk --no-cache add py2-pip \
    && pip install --upgrade pip \
    && mkdir /install \
    && pip install --prefix=/install --requirement /requirements.txt \
    && find /install -name "*.py" ! -name "__*" -exec rm {} \;

FROM base

# Copy the libraries install via pip
COPY --from=builder /install /usr

COPY dnschef.py /
COPY chef.ini /

EXPOSE 53

ENTRYPOINT ["python", "/dnschef.py", "--file", "/chef.ini", "--interface", "0.0.0.0"]
