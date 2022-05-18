# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.7

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY /Audio /Audio
COPY /Data /Data
COPY /Deep3DFaceReconstruction /Deep3DFaceReconstruction
COPY /render-to-video /render-to-video
COPY image-2.12.0.tar.gz .
COPY /Models/Audio .
COPY /Models/Deep3DFaceReconstruction .
COPY /Models/render-to-video .


RUN apt-get update \
&& apt-get install -y --no-install-recommends octave liboctave-dev cmake protobuf-compiler gcc
#RUN git clone https://github.com/danielcastillac/Audio-driven-TalkingFace-HeadPose.git

# Install pip requirements
COPY requirements.txt .
RUN pip install --upgrade cython
RUN python -m pip install -r requirements.txt

RUN octave --eval "pkg install image-2.12.0.tar.gz"



#WORKDIR /app/Deep3DFaceReconstruction/tf_mesh_renderer/mesh_renderer/kernels/
#RUN g++ -std=c++11 -shared rasterize_triangles_grad.cc rasterize_triangles_op.cc rasterize_triangles_impl.cc rasterize_triangles_impl.h -o rasterize_triangles_kernel.so -fPIC -D_GLIBCXX_USE_CXX11_ABI=1 -I /usr/local/lib/python3.7/dist-packages/tensorflow/include -I /usr/local/lib/python3.7/dist-packages/tensorflow/include/external/nsync/public -L /usr/local/lib/python3.7/dist-packages/tensorflow -ltensorflow_framework -O2
RUN cd Deep3DFaceReconstruction/tf_mesh_renderer/mesh_renderer/kernels/ && g++ -std=c++11 -shared rasterize_triangles_grad.cc rasterize_triangles_op.cc rasterize_triangles_impl.cc rasterize_triangles_impl.h -o rasterize_triangles_kernel.so -fPIC -D_GLIBCXX_USE_CXX11_ABI=1 -I /usr/local/lib/python3.7/dist-packages/tensorflow/include -I /usr/local/lib/python3.7/dist-packages/tensorflow/include/external/nsync/public -L /usr/local/lib/python3.7/dist-packages/tensorflow -ltensorflow_framework -O2
WORKDIR /app/






# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

EXPOSE 8501

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
#ENTRYPOINT ["streamlit", "run"]
CMD ["python", "app.py"]
#CMD ["python", "app.py"]
#CMD ["streamlit", "run", "app.py"]