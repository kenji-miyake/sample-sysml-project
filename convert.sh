#!/bin/bash

docker run --rm -it -v $(pwd):/workspace --entrypoint "" gorenje/sysmlv2-jupyter:2021-10 \
  python /workspace/sysml2image.py src --output-notebook-path /workspace/sysml.ipynb --output-image-path /workspace/image.svg \
  -c "%viz AutowareComponent"
