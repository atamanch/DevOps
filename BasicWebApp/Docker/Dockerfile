FROM python:3

WORKDIR /usr/src/app

# streamlit-specific commands
RUN mkdir -p /root/.streamlit
RUN bash -c 'echo -e "\
[server]\n\
port = 80\n\
" > /root/.streamlit/config.toml'

# Expose port 80 so the webapp is accessible to the outside world
EXPOSE 80

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "streamlit", "run", "./MyApp.py" ]